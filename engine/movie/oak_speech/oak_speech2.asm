OakExplainRules:
    ld hl, OakSpeechRuleStart
    call PrintText
    ld a, [wRegulationCode]    ; load the custom starter rule
    or a
    jr z, .noCustomStarter        ; skip text if there is no rule
    ld [wd11e], a
    farcall GetMonName
    ld hl, OakSpeechRuleCustomStarter
    call PrintText
.noCustomStarter

; CUSTOM MOVE 1
    ld a, [wRegulationCode+5]    ; load the custom move 1 rule
    or a
    jr z, .noMove1                  ; skip text if there is no rule
    cp $FF
    jr nz, .continue1               ; skip text if there is no rule
    call SetMoveNameAsDeleted
    jr .print1
.continue1
    ld [wd11e], a
    call GetMoveName
.print1
    ld hl, OakSpeechRuleCustomMove1
    call PrintText
.noMove1

; CUSTOM MOVE 2
    ld a, [wRegulationCode+6]    ; load the custom move 2 rule
    or a
    jr z, .noMove2                  ; skip text if there is no rule
    cp $FF
    jr nz, .continue2               ; skip text if there is no rule
    call SetMoveNameAsDeleted
    jr .print2
.continue2
    ld [wd11e], a
    call GetMoveName
.print2
    ld hl, OakSpeechRuleCustomMove2
    call PrintText
.noMove2

; CUSTOM MOVE 3
    ld a, [wRegulationCode+7]    ; load the custom move 3 rule
    or a
    jr z, .noMove3                  ; skip text if there is no rule
    cp $FF
    jr nz, .continue3               ; skip text if there is no rule
    call SetMoveNameAsDeleted
    jr .print3
.continue3
    ld [wd11e], a
    call GetMoveName
.print3
    ld hl, OakSpeechRuleCustomMove3
    call PrintText
.noMove3


; CUSTOM MOVE 4
    ld a, [wRegulationCode+8]    ; load the custom move 4 rule
    or a
    jr z, .noMove4                  ; skip text if there is no rule
    cp $FF
    jr nz, .continue4               ; skip text if there is no rule
    call SetMoveNameAsDeleted
    jr .print4
.continue4
    ld [wd11e], a
    call GetMoveName
.print4
    ld hl, OakSpeechRuleCustomMove4
    call PrintText
.noMove4



    ld a, [wRegulationCode+1]    ; load the difficulty rule
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right (upper nibble is now lower nibble)
    jr z, :+             ; skip text if there is no difficulty
    dec a                           ; decrease by 1 for the table lookup
    ld hl, _DifficultyLabels
    ld bc, 4
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleDifficulty
    call PrintText
:
    ld a, [wRegulationCode+1]    ; load the monotype rule
    and $f                          ; remove the upper 4 bits
    jr z, :+               ; skip text if there is no monotype rule
    dec a                           ; decrease by 1 for the table lookup
    ld hl, _MonotypeLabels
    ld bc, 9
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleMonotype
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no evolve rule
    bit 0, a
    jr z, :+                 ; skip text if there is no rule
    ld hl, OakSpeechRuleNoEvolve
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no trainer exp rule
    bit 1, a
    jr z, :+             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrainerExp
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no wild exp rule
    bit 2, a
    jr z, :+                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWildExp
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no wild encounters rule
    bit 3, a
    jr z, :+                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWild
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no catch wild rule
    bit 4, a
    jr z, :+              ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchWild
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no catch legendary rule
    bit 5, a
    jr z, :+         ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchLegendary
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no gift pokemon rule
    bit 6, a
    jr z, :+                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoGiftMon
    call PrintText
:
    ld a, [wRegulationCode+2]    ; load the no trade pokemon rule
    bit 7, a
    jr z, :+                  ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrade
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no restorative item combat rule
    bit 0, a
    jr z, :+      ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemCombat
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no restorative item noncombat rule
    bit 1, a
    jr z, :+   ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemNonCombat
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no battle item combat rule
    bit 2, a
    jr z, :+             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoBattleItem
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no shopping rule
    bit 3, a
    jr z, :+               ; skip text if there is no rule
    ld hl, OakSpeechRuleNoShopping
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the direct HM rule
    bit 4, a
    jr z, :+               ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDirectHM
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no TM and HM rule
    bit 5, a
    jr z, :+                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTMandHM
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the no moves from leveling rule
    bit 6, a
    jr z, :+             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoLevelMoves
    call PrintText
:
    ld a, [wRegulationCode+3]    ; load the daycare rule
    bit 7, a
    jr z, :+                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDaycare
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the catch trainer pokemon rule
    bit 0, a
    jr z, :+    ; skip text if there is no rule
    ld hl, OakSpeechRuleCatchTrainerPokemon
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the solor starter pokemon rule
    bit 1, a
    jr z, :+            ; skip text if there is no rule
    ld hl, OakSpeechRuleSoloStarter
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the pokemon perish rule
    bit 2, a
    jr z, :+            ; skip text if there is no rule
    ld hl, OakSpeechRulePokemonPerish
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the savefile permadeath rule
    bit 3, a
    jr z, :+     ; skip text if there is no rule
    ld hl, OakSpeechRuleSavefilePermadeath
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the trade stone rule
    bit 4, a
    jr z, :+             ; skip text if there is no rule
    ld hl, OakSpeechRuleAidGivesTradeStone
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the no running from wild encounters rule
    bit 5, a
    jr z, :+             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRunningWildBattle
    call PrintText
:
    ld a, [wRegulationCode+4]     ; load the your moves cannot be super effective rule
    bit 6, a
    jr z, :+                      ; skip text if there is no rule
    ld hl, OakSpeechRuleNoSuperEffectiveMove
    call PrintText
:
    ld a, [wRegulationCode+4]    ; load the trainers respawn when using Pokecenter or blacking out rule
    bit 7, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleTrainersRespawn
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the travel and HMs are not gated by Gym Leaders
    bit 0, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleTravelAndHMNotGated
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the no pokemon center rule
    bit 1, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleNoPokemonCenter
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the no catching Safari Zone rule
    bit 2, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchingSafariZone
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the sent to title screen on blackout rule
    bit 3, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleSentToTitleBlackout
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the can only capture pokemon on first encounter in each area rule
    bit 4, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechRuleOnlyCatchFirstEncounter
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the only your Super Effective moves can deal damage rule
    bit 5, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechOnlySuperEffectiveDealDamage
    call PrintText
:
    ld a, [wRegulationCode+9]    ; load the return to the last Pokecenter when you load rule
    bit 6, a
    jr z, :+                     ; skip text if there is no rule
    ld hl, OakSpeechWarpPokecenterOnLoad
    call PrintText
:


.noCustomRules
    ret

SetMoveNameAsDeleted:
    ld hl, _MoveDeleted
    ld bc, 8
    ld de, wcd6d
    ld a, BANK(_MoveDeleted)
    call FarCopyData
    ret

OakSpeechRuleStart:
    text_far _OakSpeechRuleStart
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
