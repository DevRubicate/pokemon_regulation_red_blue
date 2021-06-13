_AddPartyMon::
; Adds a new mon to the player's or enemy's party.
; [wMonDataLocation] is used in an unusual way in this function.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
	ld de, wPartyCount
	ld a, [wMonDataLocation]
	and $f
	jr z, .next
	ld de, wEnemyPartyCount
.next
	ld a, [de]
	inc a
	cp PARTY_LENGTH + 1
	ret nc ; return if the party is already full
	ld [de], a
	ld a, [de]
	ldh [hNewPartyLength], a
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [wcf91]
	ld [de], a ; write species of new mon in party list
	inc de
	ld a, $ff ; terminator
	ld [de], a
	ld hl, wPartyMonOT
	ld a, [wMonDataLocation]
	and $f
	jr z, .next2
	ld hl, wEnemyMonOT
.next2
	ldh a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMonDataLocation]
	and a
	jr nz, .skipNaming
	ld hl, wPartyMonNicks
	ldh a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
.skipNaming
	ld hl, wPartyMons
	ld a, [wMonDataLocation]
	and $f
	jr z, .next3
	ld hl, wEnemyMons
.next3
	ldh a, [hNewPartyLength]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHeader
	ld a, [hli]
	ld [de], a ; species
	inc de
	pop hl
	push hl
	ld a, [wMonDataLocation]
	and $f
	ld a, ATKDEFDV_TRAINER  ; set enemy trainer mon IVs to fixed average values
	ld b, SPDSPCDV_TRAINER
	jr nz, .next4

; If the mon is being added to the player's party, update the pokedex.
	ld a, [wcf91]
	ld [wd11e], a
	push de
	predef IndexToPokedex
	pop de
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	call FlagAction
	ld a, c ; whether the mon was already flagged as owned
	ld [wUnusedD153], a ; not read
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	push bc
	call FlagAction
	pop bc
	ld hl, wPokedexSeen
	call FlagAction

	pop hl
	push hl

	ld a, [wIsInBattle]
	and a ; is this a wild mon caught in battle?
	jr nz, .copyEnemyMonData

; Not wild.
	call Random ; generate random IVs
	ld b, a
	call Random

.next4
	push bc
	ld bc, wPartyMon1DVs - wPartyMon1
	add hl, bc
	pop bc
	ld [hli], a
	ld [hl], b         ; write IVs
	ld bc, (wPartyMon1HPExp - 1) - (wPartyMon1DVs + 1)
	add hl, bc
	ld a, 1
	ld c, a
	xor a
	ld b, a
	call CalcStat      ; calc HP stat (set cur Hp to max HP)
	ldh a, [hMultiplicand+1]
	ld [de], a
	inc de
	ldh a, [hMultiplicand+2]
	ld [de], a
	inc de
	xor a
	ld [de], a         ; box level
	inc de
	ld [de], a         ; status ailments
	inc de
	jr .copyMonTypesAndMoves
.copyEnemyMonData
	ld bc, wEnemyMon1DVs - wEnemyMon1
	add hl, bc
	ld a, [wEnemyMonDVs] ; copy IVs from cur enemy mon
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a
	ld a, [wEnemyMonHP]    ; copy HP from cur enemy mon
	ld [de], a
	inc de
	ld a, [wEnemyMonHP+1]
	ld [de], a
	inc de
	xor a
	ld [de], a                ; box level
	inc de
	ld a, [wEnemyMonStatus]   ; copy status ailments from cur enemy mon
	ld [de], a
	inc de
.copyMonTypesAndMoves
	ld hl, wMonHTypes
	ld a, [hli]       ; type 1
	ld [de], a
	inc de
	ld a, [hli]       ; type 2
	ld [de], a
	inc de


    ld a, [wMonDataLocation]
    and $f
    jr nz, .copyCatchRate       ; This pokemon doesn't belong to the player, copy the vanilla catch rate

    ; For pokemon belonging to the player, we use catch rate for something else

    inc hl                      ; advance the pokemon stats pointer
    ld a, [wAddedMonStarter]    ; check if this is the starter pokemon
    or a
    jr z, .notStarter1


    ld a, $80
    ld [de], a                  ; Set highest bit of pokemon catchrate
    jr .continue
.notStarter1
    ld a, 0
    ld [de], a                  ; Save player pokemon catchrate to 0
    jr .continue
.copyCatchRate
	ld a, [hli]       ; catch rate (held item in gen 2)
	ld [de], a
.continue
    ld hl, wMonHMoves
    ld a, d
    ld [wTemp1], a
    ld a, e
    ld [wTemp2], a

	ld a, [hli]
	inc de
	push de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	push de
	dec de
	dec de
	dec de
	xor a
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves


    ld a, [wAddedMonStarter]
    or a
    jr z, .notStarter2

    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    call OverwriteMovesCustom

.notStarter2

	pop de
	ld a, [wPlayerID]  ; set trainer ID to player ID
	inc de
	ld [de], a
	ld a, [wPlayerID + 1]
	inc de
	ld [de], a
	push de
	ld a, [wCurEnemyLVL]
	ld d, a
	callfar CalcExperience
	pop de
	inc de
	ldh a, [hExperience] ; write experience
	ld [de], a
	inc de
	ldh a, [hExperience + 1]
	ld [de], a
	inc de
	ldh a, [hExperience + 2]
	ld [de], a
	xor a
	ld b, NUM_STATS * 2
.writeEVsLoop              ; set all EVs to 0
	inc de
	ld [de], a
	dec b
	jr nz, .writeEVsLoop
	inc de
	inc de
	pop hl
	call AddPartyMon_WriteMovePP
	inc de
	ld a, [wCurEnemyLVL]
	ld [de], a
	inc de
	ld a, [wIsInBattle]
	dec a
	jr nz, .calcFreshStats
	ld hl, wEnemyMonMaxHP
	ld bc, $a
	call CopyData          ; copy stats of cur enemy mon
	pop hl
	jr .done
.calcFreshStats
	pop hl
	ld bc, wPartyMon1HPExp - 1 - wPartyMon1
	add hl, bc
	ld b, $0
	call CalcStats         ; calculate fresh set of stats
.done
    ld a, 0
    ld [wAddedMonStarter], a
	scf
	ret

OverwriteMovesCustom:

    inc de                          ; pointer to the first move
    ld a, [wRegulationCode+5]    ; load the first custom move
    or a
    jr z, .skipMove1                ; if the move value is 0 then skip
    cp $FF                          ; $FF means we want this move deleted
    jr nz, .writeMove1              ; if it wasn't $FF then write the move value

    inc de                          ; Point to move 2
    ld a, [de]                      ; Read move 2
    dec de                          ; Point to move 1
    ld [de], a                      ; Write move 1
    inc de
    inc de                          ; Point to move 3
    ld a, [de]                      ; Read move 3
    dec de                          ; Point to move 2
    ld [de], a                      ; Write move 2
    inc de
    inc de                          ; Point to move 4
    ld a, [de]                      ; Read move 4
    dec de                          ; Point to move 3
    ld [de], a                      ; Write move 3
    inc de                          ; Point to move 4
    ld a, 0
    ld [de], a                      ; Write move 4 (empty)
    dec de
    dec de
    dec de
    dec de                          ; Point to move 0 (so next is move 1)
    jr .skipMove1

.writeMove1
    ld [de], a                      ; write this move into the pokemon
.skipMove1

    inc de
    ld a, [wRegulationCode+6]
    or a
    jr z, .skipMove2
    cp $FF
    jr nz, .writeMove2

    inc de                          ; Point to move 3
    ld a, [de]                      ; Read move 3
    dec de                          ; Point to move 2
    ld [de], a                      ; Write move 2
    inc de
    inc de                          ; Point to move 4
    ld a, [de]                      ; Read move 4
    dec de                          ; Point to move 3
    ld [de], a                      ; Write move 3
    inc de                          ; Point to move 4
    ld a, 0
    ld [de], a                      ; Write move 4 (empty)
    dec de
    dec de
    dec de                          ; Point to move 1 (so next is move 2)
    jr .skipMove2

.writeMove2
    ld [de], a
.skipMove2

    inc de
    ld a, [wRegulationCode+7]
    or a
    jr z, .skipMove3
    cp $FF
    jr nz, .writeMove3

    inc de                          ; Point to move 4
    ld a, [de]                      ; Read move 4
    dec de                          ; Point to move 3
    ld [de], a                      ; Write move 3
    inc de                          ; Point to move 4
    ld a, 0
    ld [de], a                      ; Write move 4 (empty)
    dec de
    dec de                          ; Point to move 2 (so next is move 3)
    jr .skipMove3

.writeMove3
    ld [de], a
.skipMove3

    inc de
    ld a, [wRegulationCode+8]
    or a
    jr z, .skipMove4
    cp $FF
    jr nz, .writeMove4
    ld a, 0
.writeMove4
    ld [de], a
.skipMove4

    ret



LoadMovePPs:
	call GetPredefRegisters
	; fallthrough
AddPartyMon_WriteMovePP:
	ld b, NUM_MOVES
.pploop
	ld a, [hli]     ; read move ID
	and a
	jr z, .empty
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	pop bc
	pop de
	pop hl
	ld a, [wcd6d + 5] ; PP is byte 5 of move data
.empty
	inc de
	ld [de], a
	dec b
	jr nz, .pploop ; there are still moves to read
	ret

; adds enemy mon [wcf91] (at position [wWhichPokemon] in enemy list) to own party
; used in the cable club trade center
_AddEnemyMonToPlayerParty::
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z            ; party full, return failure
	inc a
	ld [hl], a       ; add 1 to party members
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf91]
	ld [hli], a      ; add mon as last list entry
	ld [hl], $ff     ; write new sentinel
	ld hl, wPartyMons
	ld a, [wPartyCount]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wLoadedMon
	call CopyData    ; write new mon's data (from wLoadedMon)
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonOT
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's OT name (from an enemy mon)
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's nickname (from an enemy mon)
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call FlagAction ; add to owned pokemon
	pop bc
	ld hl, wPokedexSeen
	call FlagAction ; add to seen pokemon
	and a
	ret                  ; return success

_MoveMon::
	ld a, [wMoveMonType]
	and a   ; BOX_TO_PARTY
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .findMonDataSrc
	; else it's PARTY_TO_BOX
	ld hl, wBoxCount
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMoveMonType]
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .copySpecies
	ld a, [wcf91]
.copySpecies
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
.findMonDataDest
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount]
	jr nz, .addMonOffset
	; if it's PARTY_TO_BOX
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wBoxCount]
.addMonOffset
	dec a
	call AddNTimes
.findMonDataSrc
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .addMonOffset2
	cp DAYCARE_TO_PARTY
	ld hl, wDayCareMon
	jr z, .copyMonData
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.addMonOffset2
	ld a, [wWhichPokemon]
	call AddNTimes
.copyMonData
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wMoveMonType]
	and a ; BOX_TO_PARTY
	jr z, .findOTdest
	cp DAYCARE_TO_PARTY
	jr z, .findOTdest
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld a, [hl] ; hl = Level
	inc de
	inc de
	inc de
	ld [de], a ; de = BoxLevel
.findOTdest
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonOT
	jr z, .findOTsrc
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .addOToffset
	ld hl, wBoxMonOT
	ld a, [wBoxCount]
.addOToffset
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.findOTsrc
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .addOToffset2
	ld hl, wDayCareMonOT
	cp DAYCARE_TO_PARTY
	jr z, .copyOT
	ld hl, wPartyMonOT
.addOToffset2
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.copyOT
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
.findNickDest
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .findNickSrc
	dec a
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	jr nz, .addNickOffset
	ld hl, wBoxMonNicks
	ld a, [wBoxCount]
.addNickOffset
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.findNickSrc
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .addNickOffset2
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .copyNick
	ld hl, wPartyMonNicks
.addNickOffset2
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.copyNick
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld a, [wMoveMonType]
	cp PARTY_TO_BOX
	jr z, .done
	cp PARTY_TO_DAYCARE
	jr z, .done
	push hl
	srl a
	add $2
	ld [wMonDataLocation], a
	call LoadMonData
	farcall CalcLevelFromExperience
	ld a, d
	ld [wCurEnemyLVL], a
	pop hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld [hli], a
	ld d, h
	ld e, l
	ld bc, -18
	add hl, bc
	ld b, $1
	call CalcStats
.done
	and a
	ret
