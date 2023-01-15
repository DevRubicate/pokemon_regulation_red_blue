RegulationBoostLevel:
    ld a, [wCurEnemyLVL]
    ld d, a                         ; save the pokemon's base level in d

    ld a, [wRegulationCode+1]    ; load the difficulty rule
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right (upper nibble is now lower nibble)
    jr z, .noModifier               ; If modifier is 0, skip this process
    ld e, a                         ; save the difficulty modifier in e

    ; We do this calculation in three parts:
    ; 1. The fraction of the lowest 2 bits
    ; 2. Then add base level
    ; 3. the fraction of the highest 6 bits

    ; We only need to check for overflow during step 3

    ; Step 1
    ld a, d                         ; pokemon base level
    and $3                          ; discard all but the bottom 2 bits
    ld c, a                         ; store in c
    ld a, 0                         ; set a to 0
    ld b, e                         ; difficulty modifier
.loop1
    add c                           ; add c to a
    dec b                           ; decrease b by 1
    jr nz, .loop1                   ; if b != 0 then goto loop1
    srl a                           ; shift right
    srl a                           ; shift right (now divided by 4)

    ; Step 2
    add d                           ; add base pokemon level to modified pokemon level

    ; Step 3
    ld c, d                         ; pokemon base level
    srl c                           ; shift right
    srl c                           ; shift right (now divided by 4)
    scf
    ccf                             ; clear carry
    ld b, e                         ; difficulty modifier
.loop2
    adc c
    jr c, .maxLevel                 ; if we have a carry, it means we went past max level
    dec b                           ; decrease number of modifier steps left
    jr nz, .loop2                   ; if b != 0 then goto loop2
    ld [wCurEnemyLVL], a
    ret
.noModifier
    ld a, d                         ; restore pokemon's level
    ld [wCurEnemyLVL], a
    ret
.maxLevel
    ld a, 255
    ld [wCurEnemyLVL], a
    ret

RegulationInitTrainer::

    RegulationTriggerStart      wRegulationTriggerTrainerBattle, NIL, wTrainerNo, NIL, NIL, NIL, NIL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wCurOpponent]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattle

    ; Convert trainer class index from 1-47 to 201-247
    ld a, [wVariableA]
    add OPP_ID_OFFSET
    ld [wCurOpponent], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattle, NIL, wTrainerNo, NIL, NIL, NIL, NIL, NIL, NIL

    ret


ReadTrainer:

; don't change any moves in a link battle
	ld a, [wLinkState]
	and a
	ret nz

; set [wEnemyPartyCount] to 0, [wEnemyPartySpecies] to FF
; XXX first is total enemy pokemon?
; XXX second is species of first pokemon?
	ld hl, wEnemyPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

; get the pointer to trainer data for this class
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET + 1 ; convert value from pokemon to trainer
	add a
	ld hl, TrainerDataPointers
	ld c, a
	ld b, 0
	add hl, bc ; hl points to trainer class



	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTrainerNo]
	ld b, a
; At this point b contains the trainer number,
; and hl points to the trainer class.
; Our next task is to iterate through the trainers,
; decrementing b each time, until we get to the right one.
.outer
	dec b
	jr z, .IterateTrainer
.inner
	ld a, [hli]
	and a
	jr nz, .inner
	jr .outer



; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
; else the first byte is the level of every pokemon on the team
.IterateTrainer
    safecall RegulationTriggerTrainerLoadData
	ld a, [hli]
	cp $FF ; is the trainer special?
	jp z, .SpecialTrainer ; if so, check for special moves
	ld [wCurEnemyLVL], a
    call RegulationBoostLevel
.LoopTrainerData
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jr nz, .continue
    jp .FinishUp
.continue
	ld [wcf91], a ; write species somewhere (XXX why?)
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a

    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemon, NIL, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wCurOpponent]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemon

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemon, NIL, NIL, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL


    ld a, [wcf91]
	push hl
	call AddPartyMon
	pop hl
	jp .LoopTrainerData
.SpecialTrainer
; if this code is being run:
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jp z, .AddLoneMove
	ld [wCurEnemyLVL], a
    call RegulationBoostLevel
	ld a, [hli]
	ld [wcf91], a              ; Pokemon species
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a

    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemon, NIL, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wCurOpponent]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemon

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemon, NIL, NIL, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL


	push hl
	call AddPartyMon
	pop hl
	jp .SpecialTrainer
.AddLoneMove
; does the trainer have a single monster with a different move?
	ld a, [wLoneAttackNo] ; Brock is 01, Misty is 02, Erika is 04, etc
	and a
	jr z, .AddTeamMove
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, LoneMoves
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld hl, wEnemyMon1Moves + 2
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld [hl], d
	jr .FinishUp
.AddTeamMove
; check if our trainer's team has special moves

; get trainer class number
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET
	ld b, a
	ld hl, TeamMoves

; iterate through entries in TeamMoves, checking each for our trainer class
.IterateTeamMoves
	ld a, [hli]
	cp b
	jr z, .GiveTeamMoves ; is there a match?
	inc hl ; if not, go to the next entry
	inc a
	jr nz, .IterateTeamMoves

; no matches found. is this trainer champion rival?
	ld a, b
	cp RIVAL3
	jr z, .ChampionRival
	jr .FinishUp ; nope
.GiveTeamMoves
	ld a, [hl]
	ld [wEnemyMon5Moves + 2], a
	jr .FinishUp
.ChampionRival ; give moves to his team

; pidgeot
	ld a, SKY_ATTACK
	ld [wEnemyMon1Moves + 2], a

; starter
	ld a, [wRivalStarter]
	cp STARTER3
	ld b, MEGA_DRAIN
	jr z, .GiveStarterMove
	cp STARTER1
	ld b, FIRE_BLAST
	jr z, .GiveStarterMove
	ld b, BLIZZARD ; must be squirtle
.GiveStarterMove
	ld a, b
	ld [wEnemyMon6Moves + 2], a
.FinishUp
; clear wAmountMoneyWon addresses
	xor a
	ld de, wAmountMoneyWon
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	ld a, [wCurEnemyLVL]
	ld b, a
.LastLoop
; update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl, wTrainerBaseMoney + 1
	ld c, 2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz, .LastLoop ; repeat wCurEnemyLVL times
	ret
