OakExplainRules:
; I WILL NOW EXPLAIN THE RULES
    ld hl, OakSpeechRuleStart
    call PrintText

;;;;;;;;;;;;;;;;;;
; CUSTOM LOGIC
;;;;;;;;;;;;;;;;;;

; RANDOMIZED POKEMON - 792B46
    ld a, [wRegulationChecksum]
    cp $79
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $2B
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $46
    jr nz, :+
    ld hl, OakSpeechRuleRandomizer
    call PrintText
    jp .gameOptions
    :

; SNAKES AND LADDERS - 5D7778
    ld a, [wRegulationChecksum]
    cp $5D
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $77
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $78
    jr nz, :+
    ld hl, OakSpeechRuleSnakesAndLadders
    call PrintText
    jp .gameOptions
    :

; CREEPYPASTA - 2B880A
    ld a, [wRegulationChecksum]
    cp $2B
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $88
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $0A
    jr nz, :+
    ld hl, OakSpeechRuleCreepypasta
    call PrintText
    jp .gameOptions
    :

; CLIPPEDWINGS - C3650A
    ld a, [wRegulationChecksum]
    cp $C3
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $65
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $0A
    jr nz, :+
    ld hl, OakSpeechRuleClippedWings
    call PrintText
    jp .gameOptions
    :

; THUNDERFISH - 79450A
    ld a, [wRegulationChecksum]
    cp $79
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $45
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $0A
    jr nz, :+
    ld hl, OakSpeechRuleThunderfish
    call PrintText
    jp .gameOptions
    :

; PAY2WIN - EB270A
    ld a, [wRegulationChecksum]
    cp $EB
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $27
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $0A
    jr nz, :+
    ld hl, OakSpeechRulePay2Win
    call PrintText
    jr .gameOptions
    :

; RIPANDTEAR - 99250A
    ld a, [wRegulationChecksum]
    cp $99
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $25
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $0A
    jr nz, :+
    ld hl, OakSpeechRuleRipAndTear
    call PrintText
    jr .gameOptions
    :

; BALLSOFSTEEL - 962EFA
    ld a, [wRegulationChecksum]
    cp $96
    jr nz, :+
    ld a, [wRegulationChecksum+1]
    cp $2E
    jr nz, :+
    ld a, [wRegulationChecksum+2]
    cp $FA
    jr nz, :+
    ld hl, OakSpeechRuleBallsOfSteel
    call PrintText
    jr .gameOptions
    :

; MANUAL CUSTOM LOGIC
    ld a, [wRegulationCustomLogicLength]
    or a
    jr z, .gameOptions
    ld hl, OakSpeechRuleUnknownCustomLogic
    call PrintText

;;;;;;;;;;;;;;;;;;
; GAME OPTIONS
;;;;;;;;;;;;;;;;;;
.gameOptions:

; STARTER POKEMON
    ld a, [wRegulationCode]             ; load the custom starter rule
    or a
    jr z, :+                            ; skip text if there is no rule
    ld [wd11e], a
    farcall GetMonName
    ld hl, OakSpeechRuleCustomStarter
    call PrintText
    :

; CUSTOM MOVE 1
    ld a, [wRegulationCode+5]           ; load the custom move 1 rule
    or a
    jr z, :+                            ; skip text if there is no rule
    call EstablishMoveName
    ld hl, OakSpeechRuleCustomMove1
    call PrintText
    :

; CUSTOM MOVE 2
    ld a, [wRegulationCode+6]           ; load the custom move 2 rule
    or a
    jr z, :+                            ; skip text if there is no rule
    call EstablishMoveName
    ld hl, OakSpeechRuleCustomMove2
    call PrintText
    :

; CUSTOM MOVE 3
    ld a, [wRegulationCode+7]           ; load the custom move 3 rule
    or a
    jr z, :+                            ; skip text if there is no rule
    call EstablishMoveName
    ld hl, OakSpeechRuleCustomMove3
    call PrintText
    :

; CUSTOM MOVE 4
    ld a, [wRegulationCode+8]           ; load the custom move 4 rule
    or a
    jr z, :+                            ; skip text if there is no rule
    call EstablishMoveName
    ld hl, OakSpeechRuleCustomMove4
    call PrintText
    :

; DIFFICULTY
    ld a, [wRegulationCode+1]           ; load the difficulty rule
    srl a                               ; shift right
    srl a                               ; shift right
    srl a                               ; shift right
    srl a                               ; shift right (upper nibble is now lower nibble)
    jr z, :+                            ; skip text if there is no difficulty
    dec a                               ; decrease by 1 for the table lookup
    ld hl, _DifficultyLabels
    ld bc, 4
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleDifficulty
    call PrintText
    :

; MONOTYPE
    ld a, [wRegulationCode+1]           ; load the monotype rule
    and $f                              ; remove the upper 4 bits
    jr z, :+                            ; skip text if there is no monotype rule
    dec a                               ; decrease by 1 for the table lookup
    ld hl, _MonotypeLabels
    ld bc, 9
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleMonotype
    call PrintText
    :

;;;;;;;;;;;;;;;;;;
; GETTING POKEMON
;;;;;;;;;;;;;;;;;;

; ONLY CATCH POKEMON ON FIRST ENCOUNTER
    ld a, [wRegulationCode+9]           ; load the can only capture pokemon on first encounter in each area rule
    bit 4, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleOnlyCatchFirstEncounter
    call PrintText
    :

; NO CATCH WILD
    ld a, [wRegulationCode+2]           ; load the no catch wild rule
    bit 4, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchWild
    call PrintText
    :

; NO CATCH LEGENDARY
    ld a, [wRegulationCode+2]           ; load the no catch legendary rule
    bit 5, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchLegendary
    call PrintText
    :

; NO GIFT POKEMON
    ld a, [wRegulationCode+2]           ; load the no gift pokemon rule
    bit 6, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoGiftMon
    call PrintText
    :

; NO TRADE POKEMON
    ld a, [wRegulationCode+2]           ; load the no trade pokemon rule
    bit 7, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrade
    call PrintText
    :

; NO SAFARI ZONE
    ld a, [wRegulationCode+9]           ; load the no catching Safari Zone rule
    bit 2, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchingSafariZone
    call PrintText
    :

; CATCH TRAINER POKEMON
    ld a, [wRegulationCode+4]           ; load the catch trainer pokemon rule
    bit 0, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleCatchTrainerPokemon
    call PrintText
    :

;;;;;;;;;;;;;;;;;;
; ITEMS
;;;;;;;;;;;;;;;;;;

; NO SHOPPING
    ld a, [wRegulationCode+3]           ; load the no shopping rule
    bit 3, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoShopping
    call PrintText
    :

; NO RESTORATIVE ITEMS IN BATTLE
    ld a, [wRegulationCode+3]           ; load the no restorative item combat rule
    bit 0, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemCombat
    call PrintText
    :

; NO RESTORATIVE ITEMS OUTSIDE BATTLE
    ld a, [wRegulationCode+3]           ; load the no restorative item noncombat rule
    bit 1, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemNonCombat
    call PrintText
    :

; NO BATTLE ITEMS
    ld a, [wRegulationCode+3]           ; load the no battle item combat rule
    bit 2, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoBattleItem
    call PrintText
    :

; TRADE STONE
    ld a, [wRegulationCode+4]           ; load the trade stone rule
    bit 4, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleAidGivesTradeStone
    call PrintText
    :

;;;;;;;;;;;;;;;;;;
; BATTLES
;;;;;;;;;;;;;;;;;;

; ONLY STARTER POKEMON
    ld a, [wRegulationCode+4]           ; load the solo starter pokemon rule
    bit 1, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleSoloStarter
    call PrintText
    :

; NO WILD ENCOUNTERS
    ld a, [wRegulationCode+2]           ; load the no wild encounters rule
    bit 3, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWild
    call PrintText
    :

; NO TRAINER EXP
    ld a, [wRegulationCode+2]           ; load the no trainer exp rule
    bit 1, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrainerExp
    call PrintText
    :

; NO WILD EXP
    ld a, [wRegulationCode+2]           ; load the no wild exp rule
    bit 2, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWildExp
    call PrintText
    :

; NO RUNNING FROM WILD ENCOUNTERS
    ld a, [wRegulationCode+4]           ; load the no running from wild encounters rule
    bit 5, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRunningWildBattle
    call PrintText
    :

; SUPER EFFECTIVE MOVES DO NOT DO MORE DAMAGE
    ld a, [wRegulationCode+4]           ; load the your super effective moves do not do more damage rule
    bit 6, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoSuperEffectiveMove
    call PrintText
    :

; ONLY SUPER EFFECTIVE MOVES DEALS DAMAGE
    ld a, [wRegulationCode+9]           ; load the only your Super Effective moves deal damage rule
    bit 5, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechOnlySuperEffectiveDealDamage
    call PrintText
    :

;;;;;;;;;;;;;;;;;;
; POKEMON
;;;;;;;;;;;;;;;;;;

; NO EVOLVE
    ld a, [wRegulationCode+2]           ; load the no evolve rule
    bit 0, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoEvolve
    call PrintText
    :

; CANNOT TEACH TM AND HM
    ld a, [wRegulationCode+3]           ; load the no TM and HM rule
    bit 5, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTMandHM
    call PrintText
    :

; NO MOVES FROM LEVELING
    ld a, [wRegulationCode+3]           ; load the no moves from leveling rule
    bit 6, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoLevelMoves
    call PrintText
    :

; NO DAYCARE
    ld a, [wRegulationCode+3]           ; load the daycare rule
    bit 7, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDaycare
    call PrintText
    :

; POKEMON PERISH
    ld a, [wRegulationCode+4]           ; load the pokemon perish rule
    bit 2, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRulePokemonPerish
    call PrintText
    :

;;;;;;;;;;;;;;;;;;
; OTHER
;;;;;;;;;;;;;;;;;;

; TRAINERS RESPAWN
    ld a, [wRegulationCode+4]           ; load the trainers respawn when using Pokecenter or blacking out rule
    bit 7, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleTrainersRespawn
    call PrintText
    :

; NO POKEMON CENTER
    ld a, [wRegulationCode+9]           ; load the no pokemon center rule
    bit 1, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoPokemonCenter
    call PrintText
    :

; RETURN TO POKECENTER ON LOAD
    ld a, [wRegulationCode+9]           ; load the return to the last Pokecenter when you load rule
    bit 6, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechWarpPokecenterOnLoad
    call PrintText
    :

; TITLE SCREEN ON BLACKOUT
    ld a, [wRegulationCode+9]           ; load the sent to title screen on blackout rule
    bit 3, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleSentToTitleBlackout
    call PrintText
    :

; SAVEFILE PERMADEATH
    ld a, [wRegulationCode+4]           ; load the savefile permadeath rule
    bit 3, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleSavefilePermadeath
    call PrintText
    :

; USE HM DIRECTLY
    ld a, [wRegulationCode+3]           ; load the direct HM rule
    bit 4, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDirectHM
    call PrintText
    :

; TRAVEL AND HM IS NOT GATED
    ld a, [wRegulationCode+9]           ; load the travel and HMs are not gated by Gym Leaders
    bit 0, a
    jr z, :+                            ; skip text if there is no rule
    ld hl, OakSpeechRuleTravelAndHMNotGated
    call PrintText
    :

    ret

EstablishMoveName:
    cp $FF
    jr z, :+                   ; If the move id is $FF that means the move was deleted
    ; This is a legitimate move, so load the name
    ld [wd11e], a
    jp GetMoveName
    ; This move was deleted, so load "deleted" as the name
    :
    ld hl, _MoveDeleted
    ld bc, 8
    ld de, wcd6d
    ld a, BANK(_MoveDeleted)
    jp FarCopyData

OakSpeechRuleStart:
    text_far _OakSpeechRuleStart
    text_end
OakSpeechRuleUnknownCustomLogic:
    text_far _OakSpeechRuleUnknownCustomLogic
    text_end
OakSpeechRuleRandomizer:
    text_far _OakSpeechRuleRandomizer
    text_end
OakSpeechRuleSnakesAndLadders:
    text_far _OakSpeechRuleSnakesAndLadders
    text_end
OakSpeechRuleCreepypasta:
    text_far _OakSpeechRuleCreepypasta
    text_end
OakSpeechRuleClippedWings:
    text_far _OakSpeechRuleClippedWings
    text_end
OakSpeechRuleThunderfish:
    text_far _OakSpeechRuleThunderfish
    text_end
OakSpeechRulePay2Win:
    text_far _OakSpeechRulePay2Win
    text_end
OakSpeechRuleRipAndTear:
    text_far _OakSpeechRuleRipAndTear
    text_end
OakSpeechRuleBallsOfSteel:
    text_far _OakSpeechRuleBallsOfSteel
    text_end
OakSpeechRuleCustomStarter:
    text_far _OakSpeechRuleCustomStarter
    text_end
OakSpeechRuleCustomMove1:
    text_far _OakSpeechRuleCustomMove1
    text_end
OakSpeechRuleCustomMove2:
    text_far _OakSpeechRuleCustomMove2
    text_end
OakSpeechRuleCustomMove3:
    text_far _OakSpeechRuleCustomMove3
    text_end
OakSpeechRuleCustomMove4:
    text_far _OakSpeechRuleCustomMove4
    text_end
OakSpeechRuleDifficulty:
    text_far _OakSpeechRuleDifficulty
    text_end
OakSpeechRuleMonotype:
    text_far _OakSpeechRuleMonotype
    text_end
OakSpeechRuleNoEvolve:
    text_far _OakSpeechRuleNoEvolve
    text_end
OakSpeechRuleNoTrainerExp:
    text_far _OakSpeechRuleNoTrainerExp
    text_end
OakSpeechRuleNoWildExp:
    text_far _OakSpeechRuleNoWildExp
    text_end
OakSpeechRuleNoWild:
    text_far _OakSpeechRuleNoWild
    text_end
OakSpeechRuleNoCatchWild:
    text_far _OakSpeechRuleNoCatchWild
    text_end
OakSpeechRuleNoCatchLegendary:
    text_far _OakSpeechRuleNoCatchLegendary
    text_end
OakSpeechRuleNoGiftMon:
    text_far _OakSpeechRuleNoGiftMon
    text_end
OakSpeechRuleNoTrade:
    text_far _OakSpeechRuleNoTrade
    text_end
OakSpeechRuleNoRestorativeItemCombat:
    text_far _OakSpeechRuleNoRestorativeItemCombat
    text_end
OakSpeechRuleNoRestorativeItemNonCombat:
    text_far _OakSpeechRuleNoRestorativeItemNonCombat
    text_end
OakSpeechRuleNoBattleItem:
    text_far _OakSpeechRuleNoBattleItem
    text_end
OakSpeechRuleNoShopping:
    text_far _OakSpeechRuleNoShopping
    text_end
OakSpeechRuleNoDirectHM:
    text_far _OakSpeechRuleNoDirectHM
    text_end
OakSpeechRuleNoTMandHM:
    text_far _OakSpeechRuleNoTMandHM
    text_end
OakSpeechRuleNoLevelMoves:
    text_far _OakSpeechRuleLevelMoves
    text_end
OakSpeechRuleNoDaycare:
    text_far _OakSpeechRuleNoDaycare
    text_end
OakSpeechRuleCatchTrainerPokemon:
    text_far _OakSpeechRuleCatchTrainerPokemon
    text_end
OakSpeechRuleSoloStarter:
    text_far _OakSpeechRuleSoloStarter
    text_end
OakSpeechRulePokemonPerish:
    text_far _OakSpeechRulePokemonPerish
    text_end
OakSpeechRuleSavefilePermadeath:
    text_far _OakSpeechRuleSavefilePermadeath
    text_end
OakSpeechRuleAidGivesTradeStone:
    text_far _OakSpeechRuleAidGivesTradeStone
    text_end
OakSpeechRuleNoRunningWildBattle:
    text_far _OakSpeechRuleNoRunningWildBattle
    text_end
OakSpeechRuleNoSuperEffectiveMove:
    text_far _OakSpeechRuleNoSuperEffectiveMove
    text_end
OakSpeechRuleTrainersRespawn:
    text_far _OakSpeechRuleTrainersRespawn
    text_end
OakSpeechRuleTravelAndHMNotGated:
    text_far _OakSpeechRuleTravelAndHMNotGated
    text_end
OakSpeechRuleNoPokemonCenter:
    text_far _OakSpeechRuleNoPokemonCenter
    text_end
OakSpeechRuleNoCatchingSafariZone:
    text_far _OakSpeechRuleNoCatchingSafariZone
    text_end
OakSpeechRuleSentToTitleBlackout:
    text_far _OakSpeechRuleSentToTitleBlackout
    text_end
OakSpeechRuleOnlyCatchFirstEncounter:
    text_far _OakSpeechRuleOnlyCatchFirstEncounter
    text_end
OakSpeechOnlySuperEffectiveDealDamage:
    text_far _OakSpeechOnlySuperEffectiveDealDamage
    text_end
OakSpeechWarpPokecenterOnLoad:
    text_far _OakSpeechWarpPokecenterOnLoad
    text_end
