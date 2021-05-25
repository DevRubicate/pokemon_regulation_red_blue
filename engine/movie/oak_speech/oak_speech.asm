SetDefaultNames:
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [wOptions]
	push af
	ld a, [wd732]
	push af
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	xor a
	call FillMemory
	pop af
	ld [wd732], a
	pop af
	ld [wOptions], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	ld hl, NintenText
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, SonyText
	ld de, wRivalName
	ld bc, NAME_LENGTH
	jp CopyData

OakSpeech:
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
	call ClearScreen
	call LoadTextBoxTilePatterns
	call SetDefaultNames
	predef InitPlayerData2
	ld hl, wNumBoxItems
	ld a, POTION
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one potion
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call SpecialWarpIn
	xor a
	ldh [hTileAnimations], a
	ld a, [wd732]
    call ChooseCode
	ld de, ProfOakPic
	lb bc, BANK(ProfOakPic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, OakSpeechText1
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
    ld a, [wCustomPokemonCode]  ; Load out starting pokemon rule
    cp 0
    jr z, .nocustom
    ld [wd11e], a
    callfar PokedexToIndex
    ld a, [wd11e]
    jr .displaycustom
.nocustom
	ld a, NIDORINO
.displaycustom
	ld [wd0b5], a
	ld [wcf91], a
	call GetMonHeader
	hlcoord 6, 4
	call LoadFlippedFrontSpriteByMonIndex
	call MovePicLeft
	ld hl, OakSpeechText2
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	call IntroDisplayPicCenteredOrUpperRight
	call MovePicLeft
	ld hl, IntroducePlayerText
	call PrintText
	call ChoosePlayerName
	call GBFadeOutToWhite
	call ClearScreen
	ld de, Rival1Pic
	lb bc, BANK(Rival1Pic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, IntroduceRivalText
	call PrintText
	call ChooseRivalName
.skipChoosingNames
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

    ld a, [wCustomPokemonCode+1]    ; load the difficulty rule
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right
    srl a                           ; shift right (upper nibble is now lower nibble)
    jr z, .noDifficulty             ; skip text if there is no difficulty
    dec a                           ; decrease by 1 for the table lookup
    ld hl, DifficultyLabels
    ld bc, 4
    call AddNTimes
    ld de, wcd6d
    call CopyData
    ld hl, OakSpeechRuleDifficulty
    call PrintText
.noDifficulty

    ld a, [wCustomPokemonCode+1]    ; load the monotype rule
    and $f                          ; remove the upper 4 bits
    jr z, .noMonotype               ; skip text if there is no monotype rule
    dec a                           ; decrease by 1 for the table lookup
    ld hl, MonotypeLabels
    ld bc, 9
    call AddNTimes
    ld de, wcd6d
    call CopyData
    ld hl, OakSpeechRuleMonotype
    call PrintText
.noMonotype

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $1                          ; look at bit 0
    jr z, .noEvolve                 ; skip text if there is no rule
    ld hl, OakSpeechRuleNoEvolve
    call PrintText
.noEvolve

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $2                          ; look at bit 1
    jr z, .noTrainerExp             ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrainerExp
    call PrintText
.noTrainerExp

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $4                          ; look at bit 2
    jr z, .noWildExp                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWildExp
    call PrintText
.noWildExp

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $8                          ; look at bit 3
    jr z, .noWildMon                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoWild
    call PrintText
.noWildMon

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $10                         ; look at bit 4
    jr z, .noCatchWild              ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchWild
    call PrintText
.noCatchWild

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $20                         ; look at bit 5
    jr z, .noCatchLegendary         ; skip text if there is no rule
    ld hl, OakSpeechRuleNoCatchLegendary
    call PrintText
.noCatchLegendary

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $40                         ; look at bit 6
    jr z, .noGiftMon                ; skip text if there is no rule
    ld hl, OakSpeechRuleNoGiftMon
    call PrintText
.noGiftMon

    ld a, [wCustomPokemonCode+2]    ; load the rule
    and $80                         ; look at bit 7
    jr z, .noTrade                  ; skip text if there is no rule
    ld hl, OakSpeechRuleNoTrade
    call PrintText
.noTrade





.noCustomRules
	call GBFadeOutToWhite
	call ClearScreen
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
	call IntroDisplayPicCenteredOrUpperRight
	call GBFadeInFromWhite
	ld a, [wd72d]
	and a
	jr nz, .next
	ld hl, OakSpeechText3
	call PrintText
.next
	ldh a, [hLoadedROMBank]
	push af
	ld a, SFX_SHRINK
	call PlaySound
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ld c, 4
	call DelayFrames
	ld de, RedSprite
	ld hl, vSprites
	lb bc, BANK(RedSprite), $0C
	call CopyVideoData
	ld de, ShrinkPic1
	lb bc, BANK(ShrinkPic1), $00
	call IntroDisplayPicCenteredOrUpperRight
	ld c, 4
	call DelayFrames
	ld de, ShrinkPic2
	lb bc, BANK(ShrinkPic2), $00
	call IntroDisplayPicCenteredOrUpperRight
	call ResetPlayerSpriteData
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(Music_PalletTown)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, 10
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ld c, 20
	call DelayFrames
	hlcoord 6, 5
	ld b, 7
	ld c, 7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld c, 50
	call DelayFrames
	call GBFadeOutToWhite
	jp ClearScreen
OakSpeechText1:
	text_far _OakSpeechText1
	text_end
OakSpeechText2:
	text_far _OakSpeechText2A
	sound_cry_nidorina
	text_far _OakSpeechText2B
	text_end
IntroducePlayerText:
	text_far _IntroducePlayerText
	text_end
IntroduceRivalText:
	text_far _IntroduceRivalText
	text_end
OakSpeechText3:
	text_far _OakSpeechText3
	text_end
OakSpeechRuleStart:
    text_far _OakSpeechRuleStart
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








FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ldh [rBGP], a
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100

MovePicLeft:
	ld a, 119
	ldh [rWX], a
	call DelayFrame

	ld a, %11100100
	ldh [rBGP], a
.next
	call DelayFrame
	ldh a, [rWX]
	sub 8
	cp $FF
	ret z
	ldh [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, $310
	call CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	hlcoord 15, 1
	jr nz, .next
	hlcoord 6, 4
.next
	xor a
	ldh [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap

DifficultyLabels:
    db "25@@"
    db "50@@"
    db "75@@"
    db "100@"
    db "125@"
    db "150@"
    db "175@"
    db "200@"
    db "225@"
    db "250@"
    db "275@"
    db "300@"
    db "325@"
    db "350@"
    db "375@"

MonotypeLabels:
    db "NORMAL@@@"
    db "FIGHTING@"
    db "FLYING@@@"
    db "POISON@@@"
    db "GROUND@@@"
    db "ROCK@@@@@"
    db "BUG@@@@@@"
    db "GHOST@@@@"
    db "FIRE@@@@@"
    db "WATER@@@@"
    db "GRASS@@@@"
    db "ELECTRIC@"
    db "PSYCHIC@@"
    db "ICE@@@@@@"
    db "DRAGON@@@"
