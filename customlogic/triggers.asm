RegulationTriggerTrainerBattlePokemonMoves::
    ld a, [wMonDataLocation]
    cp ENEMY_PARTY_DATA
    jp nz, .exit

    ; MOVE 1
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove1, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 1st move
    ld d, a
    ld a, 8
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove1, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 1st move
    ld d, a
    ld a, 8
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove1, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 2
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove2, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 9 offset which takes us to the 2nd move
    ld d, a
    ld a, 9
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove2, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 9 offset which takes us to the 2nd move
    ld d, a
    ld a, 9
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove2, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 3
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove3, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 10 offset which takes us to the 3rd move
    ld d, a
    ld a, 10
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove3, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 10 offset which takes us to the 3rd move
    ld d, a
    ld a, 10
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove3, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 4
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove4, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 11 offset which takes us to the 4th move
    ld d, a
    ld a, 11
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove4

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 11 offset which takes us to the 4th move
    ld d, a
    ld a, 11
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    .exit
    ret

RegulationTriggerFoundPokemonMoves::
    ld a, [wMonDataLocation]
    cp ENEMY_PARTY_DATA
    jp z, .exit

    ; MOVE 1
    RegulationTriggerStart      wRegulationTriggerFoundPokemonMove1, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Load move 1 and put it in variable D
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de                  ; point to move 1
    ld a, [de]              ; read out move 1
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerFoundPokemonMove1

    ; Save this new move in variable D into to move 1
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de                  ; point to move 1
    ld a, [wVariableD+1]
    ld [de], a              ; write to move 1

    RegulationTriggerEnd        wRegulationTriggerFoundPokemonMove1, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 2
    RegulationTriggerStart      wRegulationTriggerFoundPokemonMove2, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Load move 2 and put it in variable D
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de                  ; point to move 2
    ld a, [de]              ; read out move 2
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerFoundPokemonMove2

    ; Save this new move in variable D into to move 2
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de                  ; point to move 2
    ld a, [wVariableD+1]
    ld [de], a              ; write to move 2

    RegulationTriggerEnd        wRegulationTriggerFoundPokemonMove2, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 3
    RegulationTriggerStart      wRegulationTriggerFoundPokemonMove3, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Load move 3 and put it in variable D
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de
    inc de                  ; point to move 3
    ld a, [de]              ; read out move 3
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerFoundPokemonMove3

    ; Save this new move in variable D into to move 3
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de
    inc de                  ; point to move 3
    ld a, [wVariableD+1]
    ld [de], a              ; write to move 3

    RegulationTriggerEnd        wRegulationTriggerFoundPokemonMove3, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 4
    RegulationTriggerStart      wRegulationTriggerFoundPokemonMove4, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Load move 4 and put it in variable D
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de
    inc de
    inc de                  ; point to move 4
    ld a, [de]              ; read out move 4
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+3]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerFoundPokemonMove4

    ; Save this new move in variable D into to move 4
    ld a, [wTemp1]
    ld d, a
    ld a, [wTemp2]
    ld e, a
    inc de
    inc de
    inc de
    inc de                  ; point to move 4
    ld a, [wVariableD+1]
    ld [de], a              ; write to move 4

    RegulationTriggerEnd        wRegulationTriggerFoundPokemonMove4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    .exit
    ret


RegulationTriggerWildBattlePokemonMoves::

    ; MOVE 1
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove1, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+0]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove1

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+0], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove1, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 2
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove2, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+1]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove2

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+1], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove2, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 3
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove3, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+2]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove3

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+2], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove3, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL



    ; MOVE 4
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove4, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+3]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove4

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+3], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ret



RegulationTriggerFoundPokemonStarter::
    RegulationTriggerStart      wRegulationTriggerFoundPokemon, NIL, wCurMap, NIL, wRegulationPlayerTrueStarter, NIL, NIL, NIL, NIL
    RegulationTriggerExecute    wRegulationTriggerFoundPokemon
    RegulationTriggerEnd        wRegulationTriggerFoundPokemon, NIL, NIL, NIL, wRegulationPlayerTrueStarter, NIL, NIL, NIL, NIL ; TODO: add support for the variable C to change what level this pokemon starts at
    ret

RegulationTriggerFoundPokemon::
    RegulationTriggerStart      wRegulationTriggerFoundPokemon, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL
    RegulationTriggerExecute    wRegulationTriggerFoundPokemon
    RegulationTriggerEnd        wRegulationTriggerFoundPokemon, NIL, NIL, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL
    ret

RegulationTriggerSentPokemon::

    ld a, [wIsInBattle]
    dec a           ; is it a trainer battle?
    jp z, .continue

    RegulationTriggerStart      wRegulationTriggerTrainerBattleSentPokemon, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattleSentPokemon
    RegulationTriggerEnd        wRegulationTriggerTrainerBattleSentPokemon, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL
    ret

.continue

    RegulationTriggerStart      wRegulationTriggerWildBattleSentPokemon, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL
    RegulationTriggerExecute    wRegulationTriggerWildBattleSentPokemon
    RegulationTriggerEnd        wRegulationTriggerWildBattleSentPokemon, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ret

RegulationTriggerCalcPokemonStats::

    ld a, [wIsInBattle]
    cp 2                ; Is this a trainer battle?
    jp nz, .continue


    RegulationTriggerStart      wRegulationTriggerTrainerBattleCalcPokemonStats, wCurOpponent, wTrainerNo, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wVariableA]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattleCalcPokemonStats
    RegulationTriggerEnd        wRegulationTriggerTrainerBattleCalcPokemonStats, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ret

.continue

    ld a, [wIsInBattle]
    cp 1                ; Is this a wild battle?
    jp nz, .exit

    RegulationTriggerStart      wRegulationTriggerWildBattleCalcPokemonStats, NIL, wCurMap, NIL, wcf91, NIL, wCurEnemyLVL, NIL, NIL
    RegulationTriggerExecute    wRegulationTriggerWildBattleCalcPokemonStats
    RegulationTriggerEnd        wRegulationTriggerWildBattleCalcPokemonStats, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

.exit
    ret

RegulationTriggerTrainerLoadData::

    ld de, (wRegulationCustomLogic ^ $FFFF) + 1
    add hl, de

    ld a, h
    ld [wVariableB], a
    ld a, l
    ld [wVariableB+1], a

    RegulationTriggerStart      wRegulationTriggerTrainerLoadData, NIL, wTrainerNo, NIL, NIL, NIL, NIL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wCurOpponent]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerLoadData

    RegulationTriggerEnd        wRegulationTriggerTrainerLoadData, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL

    ld a, [wVariableB]
    ld h, a
    ld a, [wVariableB+1]
    ld l, a

    ld de, wRegulationCustomLogic
    add hl, de

    ret


RegulationTriggerTrainerBattleTurn::
    ld a, [wIsInBattle]
    dec a
    ret z ; if not a trainer, we're done here

    RegulationTriggerStart      wRegulationTriggerTrainerBattleTurn, NIL, wTrainerNo, NIL, NIL, NIL, NIL, NIL, NIL

    ; Convert trainer class index from 201-247 to 1-47
    ld a, [wCurOpponent]
    sub OPP_ID_OFFSET
    ld [wVariableA], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattleTurn
    RegulationTriggerEnd        wRegulationTriggerTrainerBattleTurn, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL


    ret

RegulationTriggerLearnMoveByLevel::
    RegulationTriggerStart      wRegulationTriggerLearnMove, NIL, NIL, NIL, wcf91, NIL, wCurEnemyLVL, NIL, wMoveNum
    RegulationTriggerExecute    wRegulationTriggerLearnMove
    RegulationTriggerEnd        wRegulationTriggerLearnMove, NIL, NIL, NIL, NIL, NIL, NIL, NIL, wMoveNum
    ret
