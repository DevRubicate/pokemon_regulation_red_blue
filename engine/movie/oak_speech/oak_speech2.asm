OakExplainRules:
    ld a, [wCustomPokemonCode]
    ld hl, wCustomPokemonCode+1
    or [hl]
    ld hl, wCustomPokemonCode+2
    or [hl]
    ld hl, wCustomPokemonCode+3
    or [hl]
    ld hl, wCustomPokemonCode+4
    or [hl]
    ld hl, wCustomPokemonCode+5
    or [hl]
    ld hl, wCustomPokemonCode+6
    or [hl]
    ld hl, wCustomPokemonCode+7
    or [hl]
    ld hl, wCustomPokemonCode+8
    or [hl]
    ld hl, wCustomPokemonCode+9
    or [hl]
    jp z, .noCustomRules            ; skip rules dialog if every rule is 0

    call GBFadeOutToWhite
    call ClearScreen
    ld de, ProfOakPic
    lb bc, BANK(ProfOakPic), $00
    call IntroDisplayPicCenteredOrUpperRight
    call FadeInIntroPic
    ld hl, OakSpeechRuleStart
    call PrintText

    ld a, [wCustomPokemonCode]    ; load the custom starter rule
    or a
    jr z, .noCustomStarter        ; skip text if there is no rule
    ld [wd11e], a
    farcall PokedexToIndex
    farcall GetMonName
    ld hl, OakSpeechRuleCustomStarter
    call PrintText
.noCustomStarter

; CUSTOM MOVE 1
    ld a, [wCustomPokemonCode+5]    ; load the custom move 1 rule
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
    ld a, [wCustomPokemonCode+6]    ; load the custom move 2 rule
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
    ld a, [wCustomPokemonCode+7]    ; load the custom move 3 rule
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
    ld a, [wCustomPokemonCode+8]    ; load the custom move 4 rule
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



    ld a, [wCustomPokemonCode+1]    ; load the difficulty rule
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right (upper nibble is now lower nibble)
    jr z, .noDifficulty             ; skip text if there is no difficulty
    dec a                           ; decrease by 1 for the table lookup
    ld hl, _DifficultyLabels
    ld bc, 4
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleDifficulty
    call PrintText
.noDifficulty

    ld a, [wCustomPokemonCode+1]    ; load the monotype rule
    and $f                          ; remove the upper 4 bits
    jr z, .noMonotype               ; skip text if there is no monotype rule
    dec a                           ; decrease by 1 for the table lookup
    ld hl, _MonotypeLabels
    ld bc, 9
    call AddNTimes
    ld de, wcd6d
    ld a, BANK(_DifficultyLabels)
    call FarCopyData
    ld hl, OakSpeechRuleMonotype
    call PrintText
.noMonotype

    ld a, [wCustomPokemonCode+2]    ; load the no evolve rule
    bit 0, a
    jr z, .noEvolve                 ; skip text if there is no rule
    ld hl, OakSpeechRuleNoEvolve
    call PrintText
.noEvolve

    ld a, [wCustomPokemonCode+2]    ; load the no trainer exp rule
    bit 1, a
    jr z, .noTrainerExp             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrainerExp
    call PrintText
.noTrainerExp

    ld a, [wCustomPokemonCode+2]    ; load the no wild exp rule
    bit 2, a
    jr z, .noWildExp                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWildExp
    call PrintText
.noWildExp

    ld a, [wCustomPokemonCode+2]    ; load the no wild encounters rule
    bit 3, a
    jr z, .noWildMon                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWild
    call PrintText
.noWildMon

    ld a, [wCustomPokemonCode+2]    ; load the no catch wild rule
    bit 4, a
    jr z, .noCatchWild              ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchWild
    call PrintText
.noCatchWild

    ld a, [wCustomPokemonCode+2]    ; load the no catch legendary rule
    bit 5, a
    jr z, .noCatchLegendary         ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchLegendary
    call PrintText
.noCatchLegendary

    ld a, [wCustomPokemonCode+2]    ; load the no gift pokemon rule
    bit 6, a
    jr z, .noGiftMon                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoGiftMon
    call PrintText
.noGiftMon

    ld a, [wCustomPokemonCode+2]    ; load the no trade pokemon rule
    bit 7, a
    jr z, .noTrade                  ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrade
    call PrintText
.noTrade

    ld a, [wCustomPokemonCode+3]    ; load the no restorative item combat rule
    bit 0, a
    jr z, .noRestorativeItemCombat      ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemCombat
    call PrintText
.noRestorativeItemCombat

    ld a, [wCustomPokemonCode+3]    ; load the no restorative item noncombat rule
    bit 1, a
    jr z, .noRestorativeItemNonCombat   ; skip text if there is no rule
    ld hl, OakSpeechRuleNoRestorativeItemNonCombat
    call PrintText
.noRestorativeItemNonCombat

    ld a, [wCustomPokemonCode+3]    ; load the no battle item combat rule
    bit 2, a
    jr z, .noBattleItem             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoBattleItem
    call PrintText
.noBattleItem

    ld a, [wCustomPokemonCode+3]    ; load the no shopping rule
    bit 3, a
    jr z, .noShopping               ; skip text if there is no rule
    ld hl, OakSpeechRuleNoShopping
    call PrintText
.noShopping

    ld a, [wCustomPokemonCode+3]    ; load the direct HM rule
    bit 4, a
    jr z, .noDirectHM               ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDirectHM
    call PrintText
.noDirectHM

    ld a, [wCustomPokemonCode+3]    ; load the no TM and HM rule
    bit 5, a
    jr z, .noTMandHM                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTMandHM
    call PrintText
.noTMandHM

    ld a, [wCustomPokemonCode+3]    ; load the no moves from leveling rule
    bit 6, a
    jr z, .noLevelMoves             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoLevelMoves
    call PrintText
.noLevelMoves

    ld a, [wCustomPokemonCode+3]    ; load the daycare rule
    bit 7, a
    jr z, .noDaycare                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoDaycare
    call PrintText
.noDaycare

    ld a, [wCustomPokemonCode+4]    ; load the catch trainer pokemon rule
    bit 0, a
    jr z, .noCatchTrainerPokemon    ; skip text if there is no rule
    ld hl, OakSpeechRuleCatchTrainerPokemon
    call PrintText
.noCatchTrainerPokemon

    ld a, [wCustomPokemonCode+4]    ; load the solor starter pokemon rule
    bit 1, a
    jr z, .noSoloStarter            ; skip text if there is no rule
    ld hl, OakSpeechRuleSoloStarter
    call PrintText
.noSoloStarter

    ld a, [wCustomPokemonCode+4]    ; load the pokemon perish rule
    bit 2, a
    jr z, .noPokemonPerish            ; skip text if there is no rule
    ld hl, OakSpeechRulePokemonPerish
    call PrintText
.noPokemonPerish

    ld a, [wCustomPokemonCode+4]    ; load the savefile permadeath rule
    bit 3, a
    jr z, .noSavefilePermadeagth    ; skip text if there is no rule
    ld hl, OakSpeechRuleSavefilePermadeath
    call PrintText
.noSavefilePermadeagth

.noCustomRules
    ret

SetMoveNameAsDeleted:
    ld hl, _MoveDeleted
    ld bc, 8
    ld de, wcd6d
    ld a, BANK(_MoveDeleted)
    call FarCopyData
    ret
