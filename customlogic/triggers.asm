RegulationTriggerTrainerBattlePokemonMoves::
    ld a, [wMonDataLocation]
    cp ENEMY_PARTY_DATA
    jp nz, .notEnemyPokemon

    ; MOVE 1
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove1, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

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

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove1

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

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 2
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove2, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 1st move
    ld d, a
    ld a, 9
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove2

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 2nd move
    ld d, a
    ld a, 9
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 3
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove3, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 1st move
    ld d, a
    ld a, 10
    ld e, a
    add hl, de
    ld a, [hl]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerTrainerBattlePokemonMove3

    ; Save this new move in variable D into to the pokemon data
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 3rd move
    ld d, a
    ld a, 10
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 4
    RegulationTriggerStart      wRegulationTriggerTrainerBattlePokemonMove4, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wNewlyMintedMonPointer]              ; Find the address for this new pokemon
    ld h, a
    ld a, [wNewlyMintedMonPointer+1]
    ld l, a
    ld a, 0                                     ; Add 8 offset which takes us to the 1st move
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
    ld a, 0                                     ; Add 8 offset which takes us to the 4th move
    ld d, a
    ld a, 11
    ld e, a
    add hl, de
    ld a, [wVariableD+1]
    ld [hl], a

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

.notEnemyPokemon
    ret



RegulationTriggerWildBattlePokemonMoves::
    ld a, [wMonDataLocation]
    cp ENEMY_PARTY_DATA
    jp nz, .notEnemyPokemon

    ; MOVE 1
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove1, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a


    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+0]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove1

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+0], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 2
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove2, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+1]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove2

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+1], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 3
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove3, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+2]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove3

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+2], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL



    ; MOVE 4
    RegulationTriggerStart      wRegulationTriggerWildBattlePokemonMove4, wCurOpponent, wTrainerNo, NULL, wcf91, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert trainer class index from 201-247 to 0-46
    ld a, [wVariableA]
    sub OPP_ID_OFFSET + 1
    ld [wVariableA], a

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    call IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    ; Load the move and put it in variable D
    ld a, [wEnemyMonMoves+3]
    ld [wVariableD+1], a
    ld a, 0
    ld [wVariableD], a

    RegulationTriggerExecute    wRegulationTriggerWildBattlePokemonMove4

    ; Save this new move in variable D into to the pokemon data
    ld a, [wVariableD+1]
    ld [wEnemyMonMoves+3], a

    RegulationTriggerEnd        wRegulationTriggerWildBattlePokemonMove4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

.notEnemyPokemon
    ret
