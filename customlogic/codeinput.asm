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
    dw wRegulationTriggerWildBattlePokemon
    dw wRegulationTriggerWildBattlePokemonMove1
    dw wRegulationTriggerWildBattlePokemonMove2
    dw wRegulationTriggerWildBattlePokemonMove3
    dw wRegulationTriggerWildBattlePokemonMove4

CopyNewCustomLogicCode:
    ; Load the location of the trigger and set it to the custom logic program counter
    ld hl, wcf4b+1                          ; Find the address in the text buffer holding our trigger index
    ld a, [hl]                              ; Load the trigger index
    or a
    jr z, .triggerLess                      ; If the trigger index is 0, it means no trigger
    ld bc, 0
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
    ld bc, 0
    ld a, [wVariableA]
    sub 1
    ld c, a                                 ; bc should now be the between 1 to 9

    ; Destination
    ld hl, wRegulationCustomLogic           ; The destination for the copy is wRegulationCustomLogic
    ld de, 0
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
    ld a, [wVariableA]                      ; Load the length of this new custom logic (2 to 10)
    sub 1                                   ; Subtract 2 (skipping the initial $FF and the trigger code), but add 1 to include an automatic $00 terminator at the end
    ld hl, wRegulationCustomLogicLength     ; Load the address of the existing length from previous custom logic
    add a, [hl]                             ; Add the two lengths together
    ld [wRegulationCustomLogicLength], a    ; Record the new length

    ret

CopyContinuedCustomLogicCode:

    ; Length
    ld bc, 0
    ld a, [wVariableA]                      ; Load the length
    inc a                                   ; Increase by 1 because we want to include an extra $00 terminator at the end
    ld c, a                                 ; bc should now be the between 1 to 9

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
    ld a, [wVariableA]                      ; Load the length of this new custom logic (2 to 10)
    ld hl, wRegulationCustomLogicLength     ; Load the address of the existing length from previous custom logic
    add a, [hl]                             ; Add the two lengths together
    ld [wRegulationCustomLogicLength], a    ; Record the new length

    ret

