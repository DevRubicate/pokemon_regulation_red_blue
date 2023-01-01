bankpointer: MACRO
    dw \1
    db BANK(\1)
ENDM

ExternalFunctions::
    bankpointer RegulationAIUseFullRestore                              ; 0
    bankpointer RegulationAIUsePotion                                   ; 1
    bankpointer RegulationAIUseSuperPotion                              ; 2
    bankpointer RegulationAIUseHyperPotion                              ; 3
    bankpointer RegulationAIUseFullHeal                                 ; 4
    bankpointer RegulationAIUseXAccuracy                                ; 5
    bankpointer RegulationAIUseGuardSpec                                ; 6
    bankpointer RegulationAIUseXAttack                                  ; 7
    bankpointer RegulationAIUseXDefend                                  ; 8
    bankpointer RegulationAIUseXSpeed                                   ; 9
    bankpointer RegulationAIUseXSpecial                                 ; 10
    bankpointer RegulationAIUseDireHit                                  ; 11
    bankpointer RegulationHideObject                                    ; 12
    bankpointer RegulationShowObject                                    ; 13
    bankpointer RegulationPokemonNoToIndex                              ; 14
    bankpointer RegulationPokemonIndexToNo                              ; 15
    bankpointer RegulationRandomizeTruly                                ; 16
    bankpointer SetRegulationOptionStarter                              ; 17
    bankpointer SetRegulationOptionStarterMove1                         ; 18
    bankpointer SetRegulationOptionStarterMove2                         ; 19
    bankpointer SetRegulationOptionStarterMove3                         ; 20
    bankpointer SetRegulationOptionStarterMove4                         ; 21
    bankpointer SetRegulationOptionTrainerLevelIncrease                 ; 22
    bankpointer SetRegulationOptionMonotypeRestriction                  ; 23
    bankpointer SetRegulationOptionCatchFirstEncounterOnly              ; 24
    bankpointer SetRegulationOptionBanCatchWildPokemon                  ; 25
    bankpointer SetRegulationOptionBanCatchLegendaryPokemon             ; 26
    bankpointer SetRegulationOptionBanCatchSafariPokemon                ; 27
    bankpointer SetRegulationOptionBanGiftPokemon                       ; 28
    bankpointer SetRegulationOptionBanTradePokemon                      ; 29
    bankpointer SetRegulationOptionCanCatchTrainerPokemon               ; 30
    bankpointer SetRegulationOptionBanShop                              ; 31
    bankpointer SetRegulationOptionBanRestorativeItemsInBattle          ; 32
    bankpointer SetRegulationOptionBanRestorativeItemsOutsideBattle     ; 33
    bankpointer SetRegulationOptionBanBattleItems                       ; 34
    bankpointer SetRegulationOptionCanGetTradeStone                     ; 35
    bankpointer SetRegulationOptionBanNonStarterPokemonInBattle         ; 36
    bankpointer SetRegulationOptionBanWildEcnounters                    ; 37
    bankpointer SetRegulationOptionBanExpTrainerBattle                  ; 38
    bankpointer SetRegulationOptionBanExpWildBattle                     ; 39
    bankpointer SetRegulationOptionBanRun                               ; 40
    bankpointer SetRegulationOptionBanSuperEffectiveDamage              ; 41
    bankpointer SetRegulationOptionBanNonSuperEffectiveDamage           ; 42
    bankpointer SetRegulationOptionBanEvolution                         ; 43
    bankpointer SetRegulationOptionBanTeachingTMHM                      ; 44
    bankpointer SetRegulationOptionBanLevelUpMoves                      ; 45
    bankpointer SetRegulationOptionBanDaycare                           ; 46
    bankpointer SetRegulationOptionPokemonPermadeath                    ; 47
    bankpointer SetRegulationOptionTrainersRespawn                      ; 48
    bankpointer SetRegulationOptionBanPokecenter                        ; 49
    bankpointer SetRegulationOptionTitleScreenOnBlackout                ; 50
    bankpointer SetRegulationOptionSavefileErasedOnBlackout             ; 51
    bankpointer SetRegulationOptionUseHMDirectly                        ; 52
    bankpointer SetRegulationOptionTravelAndHMNotGated                  ; 53
    bankpointer SetRegulationOptionPokecenterWarpOnLoad                 ; 54

RegulationAIPlayRestoringSFX:
    ld a, SFX_HEAL_AILMENT
    jp PlaySoundWaitForCurrent

RegulationAIUseFullRestore:
    call RegulationAICureStatus
    ld a, FULL_RESTORE
    ld [wAIItem], a
    ld de, wHPBarOldHP
    ld hl, wEnemyMonHP + 1
    ld a, [hld]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    inc de
    ld hl, wEnemyMonMaxHP + 1
    ld a, [hld]
    ld [de], a
    inc de
    ld [wHPBarMaxHP], a
    ld [wEnemyMonHP + 1], a
    ld a, [hl]
    ld [de], a
    ld [wHPBarMaxHP+1], a
    ld [wEnemyMonHP], a
    jr RegulationAIPrintItemUseAndUpdateHPBar

RegulationAIUsePotion:
    ld a, POTION
    ld b, 20
    jr RegulationAIRecoverHP

RegulationAIUseSuperPotion:
    ld a, SUPER_POTION
    ld b, 50
    jr RegulationAIRecoverHP

RegulationAIUseHyperPotion:
    ld a, HYPER_POTION
    ld b, 200
    ; fallthrough

RegulationAIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
    ld [wAIItem], a
    ld hl, wEnemyMonHP + 1
    ld a, [hl]
    ld [wHPBarOldHP], a
    add b
    ld [hld], a
    ld [wHPBarNewHP], a
    ld a, [hl]
    ld [wHPBarOldHP+1], a
    ld [wHPBarNewHP+1], a
    jr nc, .next
    inc a
    ld [hl], a
    ld [wHPBarNewHP+1], a
.next
    inc hl
    ld a, [hld]
    ld b, a
    ld de, wEnemyMonMaxHP + 1
    ld a, [de]
    dec de
    ld [wHPBarMaxHP], a
    sub b
    ld a, [hli]
    ld b, a
    ld a, [de]
    ld [wHPBarMaxHP+1], a
    sbc b
    jr nc, RegulationAIPrintItemUseAndUpdateHPBar
    inc de
    ld a, [de]
    dec de
    ld [hld], a
    ld [wHPBarNewHP], a
    ld a, [de]
    ld [hl], a
    ld [wHPBarNewHP+1], a
    ; fallthrough

RegulationAIPrintItemUseAndUpdateHPBar:
    call RegulationAIPrintItemUse_
    hlcoord 2, 2
    xor a
    ld [wHPBarType], a
    predef UpdateHPBar2
    ret

RegulationAISwitchIfEnoughMons:
; enemy trainer switches if there are 2 or more unfainted mons in party
    ld a, [wEnemyPartyCount]
    ld c, a
    ld hl, wEnemyMon1HP

    ld d, 0 ; keep count of unfainted monsters

    ; count how many monsters haven't fainted yet
.loop
    ld a, [hli]
    ld b, a
    ld a, [hld]
    or b
    jr z, .Fainted ; has monster fainted?
    inc d
.Fainted
    push bc
    ld bc, wEnemyMon2 - wEnemyMon1
    add hl, bc
    pop bc
    dec c
    jr nz, .loop

    ld a, d ; how many available monsters are there?
    cp 2    ; don't bother if only 1
    jp nc, RegulationSwitchEnemyMon
    and a
    ret

RegulationSwitchEnemyMon:

; prepare to withdraw the active monster: copy hp, number, and status to roster

    ld a, [wEnemyMonPartyPos]
    ld hl, wEnemyMon1HP
    ld bc, wEnemyMon2 - wEnemyMon1
    call AddNTimes
    ld d, h
    ld e, l
    ld hl, wEnemyMonHP
    ld bc, 4
    call CopyData

    ld hl, AIBattleWithdrawText
    call PrintText

    ; This wFirstMonsNotOutYet variable is abused to prevent the player from
    ; switching in a new mon in response to this switch.
    ld a, 1
    ld [wFirstMonsNotOutYet], a
    callfar EnemySendOut
    xor a
    ld [wFirstMonsNotOutYet], a

    ld a, [wLinkState]
    cp LINK_STATE_BATTLING
    ret z
    scf
    ret

RegulationAIBattleWithdrawText:
    text_far _AIBattleWithdrawText
    text_end

RegulationAIUseFullHeal:
    call RegulationAIPlayRestoringSFX
    call RegulationAICureStatus
    ld a, FULL_HEAL
    jp RegulationAIPrintItemUse

RegulationAICureStatus:
; cures the status of enemy's active pokemon
    ld a, [wEnemyMonPartyPos]
    ld hl, wEnemyMon1Status
    ld bc, wEnemyMon2 - wEnemyMon1
    call AddNTimes
    xor a
    ld [hl], a ; clear status in enemy team roster
    ld [wEnemyMonStatus], a ; clear status of active enemy
    ld hl, wEnemyBattleStatus3
    res 0, [hl]
    ret

RegulationAIUseXAccuracy: ; unused
    call RegulationAIPlayRestoringSFX
    ld hl, wEnemyBattleStatus2
    set 0, [hl]
    ld a, X_ACCURACY
    jp RegulationAIPrintItemUse

RegulationAIUseGuardSpec:
    call RegulationAIPlayRestoringSFX
    ld hl, wEnemyBattleStatus2
    set 1, [hl]
    ld a, GUARD_SPEC
    jp RegulationAIPrintItemUse

RegulationAIUseDireHit: ; unused
    call RegulationAIPlayRestoringSFX
    ld hl, wEnemyBattleStatus2
    set 2, [hl]
    ld a, DIRE_HIT
    jp RegulationAIPrintItemUse

RegulationAICheckIfHPBelowFraction:
; return carry if enemy trainer's current HP is below 1 / a of the maximum
    ldh [hDivisor], a
    ld hl, wEnemyMonMaxHP
    ld a, [hli]
    ldh [hDividend], a
    ld a, [hl]
    ldh [hDividend + 1], a
    ld b, 2
    call Divide
    ldh a, [hQuotient + 3]
    ld c, a
    ldh a, [hQuotient + 2]
    ld b, a
    ld hl, wEnemyMonHP + 1
    ld a, [hld]
    ld e, a
    ld a, [hl]
    ld d, a
    ld a, d
    sub b
    ret nz
    ld a, e
    sub c
    ret

RegulationAIUseXAttack:

    ld b, $A
    ld a, X_ATTACK
    jr RegulationAIIncreaseStat

RegulationAIUseXDefend:
    ld b, $B
    ld a, X_DEFEND
    jr RegulationAIIncreaseStat

RegulationAIUseXSpeed:
    ld b, $C
    ld a, X_SPEED
    jr RegulationAIIncreaseStat

RegulationAIUseXSpecial:
    ld b, $D
    ld a, X_SPECIAL
    ; fallthrough

RegulationAIIncreaseStat:
    ld [wAIItem], a
    push bc
    call RegulationAIPrintItemUse_
    pop bc
    ld hl, wEnemyMoveEffect
    ld a, [hld]
    push af
    ld a, [hl]
    push af
    push hl
    ld a, ANIM_AF
    ld [hli], a
    ld [hl], b
    callfar StatModifierUpEffect
    pop hl
    pop af
    ld [hli], a
    pop af
    ld [hl], a
    ret

RegulationAIPrintItemUse:
    ld [wAIItem], a
    call RegulationAIPrintItemUse_
    ret

RegulationAIPrintItemUse_:
; print "x used [wAIItem] on z!"
    ld a, [wAIItem]
    ld [wd11e], a
    call GetItemName
    ld hl, RegulationAIBattleUseItemText
    jp PrintText

RegulationAIBattleUseItemText:
    text_far _AIBattleUseItemText
    text_end


; byte 0 - Starter Pokemon
; byte 1h - Difficulty
; byte 1l - Monotype challenge
; byte 2
;           0: Pokemon can't evolve
;           1: No exp from trainer battles
;           2: No exp from wild pokemon
;           3: No random wild encounters
;           4: Can't catch wild pokemon
;           5: Can't catch legendary pokemon
;           6: Can't get gift pokemon
;           7: Can't trade pokemon
; byte 3
;           0: No restorative items in combat
;           1: No restorative items outside battle
;           2: No battle items
;           3: No marts or vending machine
;           4: HMs are used directly
;           5: TMs and HMs can't be taught
;           6: No moves from leveling up
;           7: No daycare
; byte 4
;           0: Catch trainer pokemon
;           1: Knocked out if not using starter
;           2: Pokemon deleted when fainted
;           3: Savefile deleted on blackout
;           4: Trade Stone
;           5: Can't run from wild battles
;           6: No extra damage from super effective moves
;           7: Trainers reset on pokemon center or blackout
;
; byte 5 - Starter pokemon move 1
; byte 6 - Starter pokemon move 2
; byte 7 - Starter pokemon move 3
; byte 8 - Starter pokemon move 4
; byte 9
;           0: Travel and HMs not gated by Gym Leaders
;           1: Cannot use pokecenters or party heals
;           2: No catching safari zone pokemon
;           3: Sent to title screen on blacking out
;           4: Can only capture pokemon on first encounter in each area
;           5: Only your super effective moves have an effect
;           6: Return to the last Pokecenter when you save
;           7:

SetRegulationOptionStarter:
    ld a, [wRegulationCustomLogicVariableA+1]
    push af
    safecall RegulationPokemonNoToIndex
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCode], a
    pop af
    ld [wRegulationCustomLogicVariableA+1], a
    ret

SetRegulationOptionStarterMove1:

    ret

SetRegulationOptionStarterMove2:

    ret

SetRegulationOptionStarterMove3:

    ret

SetRegulationOptionStarterMove4:

    ret

SetRegulationOptionTrainerLevelIncrease:
    ; Load out the existing option byte but mask out the upper difficulty bits
    ld a, [wRegulationCode+1]
    and %00001111
    ld b, a

    ; Load out the new difficulty bits, mask out the rest, and rotate them to the upper bits
    ld a, [wRegulationCustomLogicVariableA+1]
    and %00001111
    rlc a
    rlc a
    rlc a
    rlc a

    ; OR the two together
    or a, b

    ; Save the new difficulty
    ld [wRegulationCode+1], a

    ret

SetRegulationOptionMonotypeRestriction:
    ; Load out the existing option byte but mask out the lower monotype bits
    ld a, [wRegulationCode+1]
    and %11110000
    ld b, a

    ; Load out the new monotype bits, mask out the rest
    ld a, [wRegulationCustomLogicVariableA+1]
    and %00001111

    ; OR the two together
    or a, b

    ; Save the new monotype rule
    ld [wRegulationCode+1], a

    ret

SetRegulationOptionCatchFirstEncounterOnly:

    ; Load out the existing option byte but mask out all irrelevant bits
    ld a, [wRegulationCode+9]
    and %00010000
    ld b, a

    ; Load out the new rule bit, mask out everything else
    ld a, [wRegulationCustomLogicVariableA+1]
    and %00000001
    rlc a
    rlc a
    rlc a
    rlc a                       ; Rotate the bit into place

    ; OR the two together
    or a, b

    ; Save the new monotype rule
    ld [wRegulationCode+9], a

    ret

SetRegulationOptionBanCatchWildPokemon:

    ret

SetRegulationOptionBanCatchLegendaryPokemon:

    ret

SetRegulationOptionBanCatchSafariPokemon:

    ret

SetRegulationOptionBanGiftPokemon:

    ret

SetRegulationOptionBanTradePokemon:

    ret

SetRegulationOptionCanCatchTrainerPokemon:

    ret

SetRegulationOptionBanShop:

    ret

SetRegulationOptionBanRestorativeItemsInBattle:

    ret

SetRegulationOptionBanRestorativeItemsOutsideBattle:

    ret

SetRegulationOptionBanBattleItems:

    ret

SetRegulationOptionCanGetTradeStone:

    ret

SetRegulationOptionBanNonStarterPokemonInBattle:

    ret

SetRegulationOptionBanWildEcnounters:

    ret

SetRegulationOptionBanExpTrainerBattle:

    ret

SetRegulationOptionBanExpWildBattle:

    ret

SetRegulationOptionBanRun:

    ret

SetRegulationOptionBanSuperEffectiveDamage:

    ret

SetRegulationOptionBanNonSuperEffectiveDamage:

    ret

SetRegulationOptionBanEvolution:

    ret

SetRegulationOptionBanTeachingTMHM:

    ret

SetRegulationOptionBanLevelUpMoves:

    ret

SetRegulationOptionBanDaycare:

    ret

SetRegulationOptionPokemonPermadeath:

    ret

SetRegulationOptionTrainersRespawn:

    ret

SetRegulationOptionBanPokecenter:

    ret

SetRegulationOptionTitleScreenOnBlackout:

    ret

SetRegulationOptionSavefileErasedOnBlackout:

    ret

SetRegulationOptionUseHMDirectly:

    ret

SetRegulationOptionTravelAndHMNotGated:

    ret

SetRegulationOptionPokecenterWarpOnLoad:

    ret


_DisplayBoxText::
    text "Test! Test! I"
    line "remember now! His"
    prompt

DisplayBoxText:
    text_far _DisplayBoxText
    text_end

DisplayBox::
    ld hl, DisplayBoxText
    jp PrintText
    ret





RegulationHideObject::
    ld hl, wMissableObjectFlags
    ld a, [wRegulationCustomLogicVariableA+1]
    ld c, a
    ld b, FLAG_SET
    safecall FlagAction
    safecall UpdateSprites
    ret

RegulationShowObject::
    ld hl, wMissableObjectFlags
    ld a, [wRegulationCustomLogicVariableA+1]
    ld c, a
    ld b, FLAG_RESET
    safecall FlagAction
    safecall UpdateSprites
    ret

RegulationPokemonNoToIndex::
    ld a, [wRegulationCustomLogicVariableA+1]
    ld b, a
    ld c, 0
    ld hl, PokemonIndexTable
.loop ; go through the list until we find an entry with a matching dex number
    inc c
    ld a, [hli]
    cp b
    jr nz, .loop
    ld a, c
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ret


RegulationPokemonIndexToNo::
    ; converts the index number at wd11e to a Pokédex number
    ld a, [wRegulationCustomLogicVariableA+1]
    dec a
    ld hl, PokemonIndexTable
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ret

PokemonIndexTable:
    table_width 1, PokemonIndexTable
    db DEX_RHYDON
    db DEX_KANGASKHAN
    db DEX_NIDORAN_M
    db DEX_CLEFAIRY
    db DEX_SPEAROW
    db DEX_VOLTORB
    db DEX_NIDOKING
    db DEX_SLOWBRO
    db DEX_IVYSAUR
    db DEX_EXEGGUTOR
    db DEX_LICKITUNG
    db DEX_EXEGGCUTE
    db DEX_GRIMER
    db DEX_GENGAR
    db DEX_NIDORAN_F
    db DEX_NIDOQUEEN
    db DEX_CUBONE
    db DEX_RHYHORN
    db DEX_LAPRAS
    db DEX_ARCANINE
    db DEX_MEW
    db DEX_GYARADOS
    db DEX_SHELLDER
    db DEX_TENTACOOL
    db DEX_GASTLY
    db DEX_SCYTHER
    db DEX_STARYU
    db DEX_BLASTOISE
    db DEX_PINSIR
    db DEX_TANGELA
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_GROWLITHE
    db DEX_ONIX
    db DEX_FEAROW
    db DEX_PIDGEY
    db DEX_SLOWPOKE
    db DEX_KADABRA
    db DEX_GRAVELER
    db DEX_CHANSEY
    db DEX_MACHOKE
    db DEX_MR_MIME
    db DEX_HITMONLEE
    db DEX_HITMONCHAN
    db DEX_ARBOK
    db DEX_PARASECT
    db DEX_PSYDUCK
    db DEX_DROWZEE
    db DEX_GOLEM
    db 0 ; MISSINGNO.
    db DEX_MAGMAR
    db 0 ; MISSINGNO.
    db DEX_ELECTABUZZ
    db DEX_MAGNETON
    db DEX_KOFFING
    db 0 ; MISSINGNO.
    db DEX_MANKEY
    db DEX_SEEL
    db DEX_DIGLETT
    db DEX_TAUROS
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_FARFETCHD
    db DEX_VENONAT
    db DEX_DRAGONITE
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_DODUO
    db DEX_POLIWAG
    db DEX_JYNX
    db DEX_MOLTRES
    db DEX_ARTICUNO
    db DEX_ZAPDOS
    db DEX_DITTO
    db DEX_MEOWTH
    db DEX_KRABBY
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_VULPIX
    db DEX_NINETALES
    db DEX_PIKACHU
    db DEX_RAICHU
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_DRATINI
    db DEX_DRAGONAIR
    db DEX_KABUTO
    db DEX_KABUTOPS
    db DEX_HORSEA
    db DEX_SEADRA
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_SANDSHREW
    db DEX_SANDSLASH
    db DEX_OMANYTE
    db DEX_OMASTAR
    db DEX_JIGGLYPUFF
    db DEX_WIGGLYTUFF
    db DEX_EEVEE
    db DEX_FLAREON
    db DEX_JOLTEON
    db DEX_VAPOREON
    db DEX_MACHOP
    db DEX_ZUBAT
    db DEX_EKANS
    db DEX_PARAS
    db DEX_POLIWHIRL
    db DEX_POLIWRATH
    db DEX_WEEDLE
    db DEX_KAKUNA
    db DEX_BEEDRILL
    db 0 ; MISSINGNO.
    db DEX_DODRIO
    db DEX_PRIMEAPE
    db DEX_DUGTRIO
    db DEX_VENOMOTH
    db DEX_DEWGONG
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_CATERPIE
    db DEX_METAPOD
    db DEX_BUTTERFREE
    db DEX_MACHAMP
    db 0 ; MISSINGNO.
    db DEX_GOLDUCK
    db DEX_HYPNO
    db DEX_GOLBAT
    db DEX_MEWTWO
    db DEX_SNORLAX
    db DEX_MAGIKARP
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_MUK
    db 0 ; MISSINGNO.
    db DEX_KINGLER
    db DEX_CLOYSTER
    db 0 ; MISSINGNO.
    db DEX_ELECTRODE
    db DEX_CLEFABLE
    db DEX_WEEZING
    db DEX_PERSIAN
    db DEX_MAROWAK
    db 0 ; MISSINGNO.
    db DEX_HAUNTER
    db DEX_ABRA
    db DEX_ALAKAZAM
    db DEX_PIDGEOTTO
    db DEX_PIDGEOT
    db DEX_STARMIE
    db DEX_BULBASAUR
    db DEX_VENUSAUR
    db DEX_TENTACRUEL
    db 0 ; MISSINGNO.
    db DEX_GOLDEEN
    db DEX_SEAKING
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_PONYTA
    db DEX_RAPIDASH
    db DEX_RATTATA
    db DEX_RATICATE
    db DEX_NIDORINO
    db DEX_NIDORINA
    db DEX_GEODUDE
    db DEX_PORYGON
    db DEX_AERODACTYL
    db 0 ; MISSINGNO.
    db DEX_MAGNEMITE
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_CHARMANDER
    db DEX_SQUIRTLE
    db DEX_CHARMELEON
    db DEX_WARTORTLE
    db DEX_CHARIZARD
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db 0 ; MISSINGNO.
    db DEX_ODDISH
    db DEX_GLOOM
    db DEX_VILEPLUME
    db DEX_BELLSPROUT
    db DEX_WEEPINBELL
    db DEX_VICTREEBEL
    assert_table_length NUM_POKEMON_INDEXES
