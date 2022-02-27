TriggerTable:
    dw $0000
    dw wRegulationTriggerNewGame
    dw wRegulationTriggerBlackedOut
    dw wRegulationTriggerRanAway
    dw wRegulationTriggerPartyHealed
    dw wRegulationTriggerFoundItem
    dw wRegulationTriggerFoundPokemon
    dw wRegulationTriggerUsedItem
    dw wRegulationTriggerPokemonFainted
    dw wRegulationTriggerPokemonCaught
    dw wRegulationTriggerPokemonGainExp
    dw wRegulationTriggerPokemonGainLevel
    dw wRegulationTriggerPokemonGainMove
    dw wRegulationTriggerPokemonEvolve
    dw wRegulationTriggerTrainerBattle
    dw wRegulationTriggerTrainerBattlePokemon
    dw wRegulationTriggerTrainerBattlePokemonMove1
    dw wRegulationTriggerTrainerBattlePokemonMove2
    dw wRegulationTriggerTrainerBattlePokemonMove3
    dw wRegulationTriggerTrainerBattlePokemonMove4
    dw wRegulationTriggerTrainerBattleSentPokemon
    dw wRegulationTriggerWildBattlePokemon
    dw wRegulationTriggerWildBattlePokemonMove1
    dw wRegulationTriggerWildBattlePokemonMove2
    dw wRegulationTriggerWildBattlePokemonMove3
    dw wRegulationTriggerWildBattlePokemonMove4
    dw wRegulationTriggerWildBattleSentPokemon
    dw wRegulationTriggerTrainerBattleCalcPokemonStats
    dw wRegulationTriggerWildBattleCalcPokemonStats
    dw wRegulationTriggerTrainerLoadData
    dw wRegulationTriggerTrainerBattleTurn

CopyNewCustomLogicCode::

    ; Load the location of the trigger and set it to the custom logic program counter
    ld hl, wcf4b+1                          ; Find the address in the text buffer holding our trigger index
    ld a, [hl]                              ; Load the trigger index
    or a
    jr z, .triggerLess                      ; If the trigger index is 0, it means no trigger
    ld b, 0
    ld c, a                                 ; bc now holds the trigger index
    ld hl, TriggerTable                     ; Load the base address of the TriggerTable
    add hl, bc
    add hl, bc                              ; Add the trigger index twice (each entry is 2 bytes wide)
    ld a, [hli]                             ; Load out the upper byte of the trigger address from TriggerTable
    ld c, a
    ld a, [hl]                              ; Load out the lower byte of the trigger address from TriggerTable
    ld h, a
    ld l, c                                 ; Move the full address to hl
    ld a, [wRegulationCustomLogicLength]    ; Load the entry point for the new custom logic entry
    add 1                                   ; Add 1 as $00 means that the trigger is inactive, so the entry point uses a 1-based index
    ld [hl], a                              ; Save this entry point as the trigger value

    .triggerLess

    ; Length
    ld bc, 8

    ; Destination
    ld hl, wRegulationCustomLogic           ; The destination for the copy is wRegulationCustomLogic
    ld d, 0
    ld a, [wRegulationCustomLogicLength]
    ld e, a
    add hl, de                              ; But we want to add an offset equal to how much we already copied there earlier
    ld d, h
    ld e, l                                 ; Set this destination in de

    ; Source
    ld hl, wcf4b+2                          ; The source for the copy is wcf4b, but we start 2 bytes out to skip the $FF and trigger code

    ; Copy
    call CopyData

    ; Record the new length of the total custom logic
    ld a, [wRegulationCustomLogicLength]    ; Load the old length
    add a, 9
    jr c, CodeOverflow
    ld [wRegulationCustomLogicLength], a    ; Record the new length

    ret

CopyContinuedCustomLogicCode::

    ; Length
    ld bc, 10

    ; Destination
    ld hl, wRegulationCustomLogic           ; The destination for the copy is wRegulationCustomLogic
    ld de, 0
    ld a, [wRegulationCustomLogicLength]
    dec a                                   ; Last segment we terminated with a $00, but now we want to override that with this continued code
    ld e, a
    add hl, de                              ; But we want to add an offset equal to how much we already copied there earlier
    ld d, h
    ld e, l                                 ; Set this destination in de

    ; Source
    ld hl, wcf4b                            ; The source for the copy is wcf4b, and this time we don't start 2 bytes out

    ; Copy
    call CopyData

    ; Record the new length of the total custom logic
    ld a, [wRegulationCustomLogicLength]    ; Load the old length
    add a, 10
    jr c, CodeOverflow
    ld [wRegulationCustomLogicLength], a    ; Record the new length

    ret

CodeOverflow::
    ld hl, CodeOverflowText
    call PrintText
    jp Init


CodeOverflowText:
    text_far _CodeOverflowText
    text_end


RewindWaste::

    ; This routine will rewind the wRegulationCustomLogicLength pointer to avoid excessive waste with 00 values

    ld a, [wRegulationCustomLogicLength]
    ld e, a
    ld d, 0

    ld hl, wRegulationCustomLogic
    add hl, de

    ; The idea behind this loop is to go backwards until we find the first non-zero byte

    .loop

    ; decrement hl and e by 1 each
    dec hl
    dec e

    ; Load the byte we are now looking at
    ld a, [hl]
    or a

    ; If the byte is zero keep looping
    jr z, .loop

    ; Loop is over

    ; Increment e by 2, so the pointer will be 2 bytes removed from the last non-zero byte
    inc e
    inc e

    ; Save the new pointer
    ld a, e
    ld [wRegulationCustomLogicLength], a

    ret

ProcessManuallyInputByte::

    ld a, [hli]
    cp $50
    jr z, .zero
    cp $0
    jr z, .zero

    .continue

    cp $f0
    jr nc, .number
    sbc $75
    jr .save

    .number

    sbc $f6

    .save

    ld b, a
    sla b
    sla b
    sla b
    sla b
    ld a, [hli]
    cp $50
    jr z, .zero2
    cp $0
    jr z, .zero2

    .continue2

    cp $f0
    jr nc, .number2
    sbc $75
    jr .save2

    .number2

    sbc $f6

    .save2

    adc b
    ld [de], a
    inc de

    ld c, a

    ; Checksum calculations

    ; Load the first byte of the checksum
    ; Add the input byte
    ; Store it back into the first byte of the checksum
    ld a, [wRegulationChecksum+0]
    adc c
    ld [wRegulationChecksum+0], a

    ; Load the second byte of the checksum
    ; Subtract the first byte of the checksum
    ; Xor the input byte
    ; Store it back into the second byte of the checksum
    ld b, a
    ld a, [wRegulationChecksum+1]
    sub b
    xor c
    ld [wRegulationChecksum+1], a

    ; Load the third byte of the checksum
    ; Increment by one
    ; Store it back into the third byte of the checksum
    ld a, [wRegulationChecksum+2]
    inc a
    ld [wRegulationChecksum+2], a

    ret

    .zero

    ld a, $f6
    jr .continue

    .zero2

    ld a, $f6
    jr .continue2

    ret
