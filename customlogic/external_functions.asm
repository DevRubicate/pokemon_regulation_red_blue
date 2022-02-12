bankpointer: MACRO
    dw \1
    db BANK(\1)
ENDM

ExternalFunctions::
    bankpointer AIUseFullRestore                ; 0
    bankpointer AIUsePotion                     ; 1
    bankpointer AIUseSuperPotion                ; 2
    bankpointer AIUseHyperPotion                ; 3
    bankpointer AIUseFullHeal                   ; 4
    bankpointer AIUseXAccuracy                  ; 5
    bankpointer AIUseGuardSpec                  ; 6
    bankpointer AIUseDireHit                    ; 7
    bankpointer AIUseXAttack                    ; 8
    bankpointer AIUseXDefend                    ; 9
    bankpointer AIUseXSpeed                     ; 10
    bankpointer AIUseXSpecial                   ; 11
    bankpointer RegulationHideObject            ; 12
    bankpointer RegulationShowObject            ; 13
    bankpointer RegulationPokemonNoToIndex      ; 14
    bankpointer RegulationPokemonIndexToNo      ; 15
    bankpointer RegulationRandomizeTruly        ; 16
    bankpointer DebugABC                        ; 17
    bankpointer DebugDST                        ; 18











DebugABC::
    ld a, [wRegulationCustomLogicVariableC]
    ld b, a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld c, a

    ld a, [wRegulationCustomLogicVariableB]
    ld d, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld e, a

    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a

    debug

    ret

DebugDST::
    ld a, [wRegulationCustomLogicVariableD]
    ld b, a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld c, a

    ld a, [wRegulationCustomLogicVariableS]
    ld d, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld e, a

    ld a, [wRegulationCustomLogicVariableT]
    ld h, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld l, a

    debug

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
