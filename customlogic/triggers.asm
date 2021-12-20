RegulationTriggerTrainerBattlePokemonMoves::
    ld a, [wMonDataLocation]
    cp ENEMY_PARTY_DATA
    jp nz, .exit

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
    ld a, 0                                     ; Add 9 offset which takes us to the 2nd move
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
    ld a, 0                                     ; Add 9 offset which takes us to the 2nd move
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
    ld a, 0                                     ; Add 10 offset which takes us to the 3rd move
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
    ld a, 0                                     ; Add 10 offset which takes us to the 3rd move
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

    RegulationTriggerEnd        wRegulationTriggerTrainerBattlePokemonMove4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

.exit
    ret



RegulationTriggerWildBattlePokemonMoves::

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

    ret


RegulationTriggerFoundPokemon::


    RegulationTriggerStart      wRegulationTriggerFoundPokemon, NULL, NULL, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

    ; Convert pokemon from index to pokedex No
    ld a, [wcf91]
    ld [wd11e], a
    farcall IndexToPokedex
    ld a, [wd11e]
    ld [wVariableB+1], a

    RegulationTriggerExecute    wRegulationTriggerFoundPokemon

    ; Convert pokemon from pokedex No to index
    ld a, [wVariableB+1]
    ld [wd11e], a
    farcall PokedexToIndex
    ld a, [wd11e]
    ld [wcf91], a

    RegulationTriggerEnd        wRegulationTriggerFoundPokemon, NULL, NULL, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

    ret


RegulationTriggerSentPokemon::

    ld a, [wIsInBattle]
    dec a           ; is it a trainer battle?
    jp z, .continue

    RegulationTriggerStart      wRegulationTriggerTrainerBattleSentPokemon, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

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

    RegulationTriggerExecute    wRegulationTriggerTrainerBattleSentPokemon
    RegulationTriggerEnd        wRegulationTriggerTrainerBattleSentPokemon, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    ret

.continue

    RegulationTriggerStart      wRegulationTriggerWildBattleSentPokemon, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

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

    RegulationTriggerExecute    wRegulationTriggerWildBattleSentPokemon
    RegulationTriggerEnd        wRegulationTriggerWildBattleSentPokemon, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

    ret

RegulationTriggerCalcPokemonStats::

    ld a, [wIsInBattle]
    cp 2                ; Is this a trainer battle?
    jp nz, .continue


    RegulationTriggerStart      wRegulationTriggerTrainerBattleCalcPokemonStats, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

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

    RegulationTriggerExecute    wRegulationTriggerTrainerBattleCalcPokemonStats
    RegulationTriggerEnd        wRegulationTriggerTrainerBattleCalcPokemonStats, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

    ret

.continue

    ld a, [wIsInBattle]
    cp 1                ; Is this a wild battle?
    jp nz, .exit

    RegulationTriggerStart      wRegulationTriggerWildBattleCalcPokemonStats, wCurOpponent, wTrainerNo, NULL, NULL, NULL, wCurEnemyLVL, NULL, NULL

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

    RegulationTriggerExecute    wRegulationTriggerWildBattleCalcPokemonStats
    RegulationTriggerEnd        wRegulationTriggerWildBattleCalcPokemonStats, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

.exit
    ret
