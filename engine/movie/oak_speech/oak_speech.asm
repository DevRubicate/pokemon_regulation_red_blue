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
    call OakExplainRules
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
OakSpeechCatchTrainerPokemon:
    text_far _OakSpeechCatchTrainerPokemon
    text_end


ChooseCode:
    ld hl, wCustomPokemonCode
    ld a, NAME_CODE_SCREEN
    ld [wNamingScreenType], a
    call DisplayNamingScreen
    call ClearScreen
    call Delay3
    ret

ChoosePlayerName:
    call OakSpeechSlidePicRight
    ld de, DefaultNamesPlayer
    call DisplayIntroNameTextBox
    ld a, [wCurrentMenuItem]
    and a
    jr z, .customName
    ld hl, DefaultNamesPlayerList
    call GetDefaultName
    ld de, wPlayerName
    call OakSpeechSlidePicLeft
    jr .done
.customName
    ld hl, wPlayerName
    xor a ; NAME_PLAYER_SCREEN
    ld [wNamingScreenType], a
    call DisplayNamingScreen
    ld a, [wcf4b]
    cp "@"
    jr z, .customName
    call ClearScreen
    call Delay3
    ld de, RedPicFront
    ld b, BANK(RedPicFront)
    call IntroDisplayPicCenteredOrUpperRight
.done
    ld hl, YourNameIsText
    jp PrintText

YourNameIsText:
    text_far _YourNameIsText
    text_end

ChooseRivalName:
    call OakSpeechSlidePicRight
    ld de, DefaultNamesRival
    call DisplayIntroNameTextBox
    ld a, [wCurrentMenuItem]
    and a
    jr z, .customName
    ld hl, DefaultNamesRivalList
    call GetDefaultName
    ld de, wRivalName
    call OakSpeechSlidePicLeft
    jr .done
.customName
    ld hl, wRivalName
    ld a, NAME_RIVAL_SCREEN
    ld [wNamingScreenType], a
    call DisplayNamingScreen
    ld a, [wcf4b]
    cp "@"
    jr z, .customName
    call ClearScreen
    call Delay3
    ld de, Rival1Pic
    ld b, $13
    call IntroDisplayPicCenteredOrUpperRight
.done
    ld hl, HisNameIsText
    jp PrintText

HisNameIsText:
    text_far _HisNameIsText
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




OakSpeechSlidePicLeft:
    push de
    hlcoord 0, 0
    lb bc, 12, 11
    call ClearScreenArea ; clear the name list text box
    ld c, 10
    call DelayFrames
    pop de
    ld hl, wcd6d
    ld bc, NAME_LENGTH
    call CopyData
    call Delay3
    hlcoord 12, 4
    lb de, 6, 6 * SCREEN_WIDTH + 5
    ld a, $ff
    jr OakSpeechSlidePicCommon

OakSpeechSlidePicRight:
    hlcoord 5, 4
    lb de, 6, 6 * SCREEN_WIDTH + 5
    xor a

OakSpeechSlidePicCommon:
    push hl
    push de
    push bc
    ldh [hSlideDirection], a
    ld a, d
    ldh [hSlideAmount], a
    ld a, e
    ldh [hSlidingRegionSize], a
    ld c, a
    ldh a, [hSlideDirection]
    and a
    jr nz, .next
; If sliding right, point hl to the end of the pic's tiles.
    ld d, 0
    add hl, de
.next
    ld d, h
    ld e, l
.loop
    xor a
    ldh [hAutoBGTransferEnabled], a
    ldh a, [hSlideDirection]
    and a
    jr nz, .slideLeft
; sliding right
    ld a, [hli]
    ld [hld], a
    dec hl
    jr .next2
.slideLeft
    ld a, [hld]
    ld [hli], a
    inc hl
.next2
    dec c
    jr nz, .loop
    ldh a, [hSlideDirection]
    and a
    jr z, .next3
; If sliding left, we need to zero the last tile in the pic (there is no need
; to take a corresponding action when sliding right because hl initially points
; to a 0 tile in that case).
    xor a
    dec hl
    ld [hl], a
.next3
    ld a, 1
    ldh [hAutoBGTransferEnabled], a
    call Delay3
    ldh a, [hSlidingRegionSize]
    ld c, a
    ld h, d
    ld l, e
    ldh a, [hSlideDirection]
    and a
    jr nz, .slideLeft2
    inc hl
    jr .next4
.slideLeft2
    dec hl
.next4
    ld d, h
    ld e, l
    ldh a, [hSlideAmount]
    dec a
    ldh [hSlideAmount], a
    jr nz, .loop
    pop bc
    pop de
    pop hl
    ret

DisplayIntroNameTextBox:
    push de
    hlcoord 0, 0
    ld b, $a
    ld c, $9
    call TextBoxBorder
    hlcoord 3, 0
    ld de, .namestring
    call PlaceString
    pop de
    hlcoord 2, 2
    call PlaceString
    call UpdateSprites
    xor a
    ld [wCurrentMenuItem], a
    ld [wLastMenuItem], a
    inc a
    ld [wTopMenuItemX], a
    ld [wMenuWatchedKeys], a ; A_BUTTON
    inc a
    ld [wTopMenuItemY], a
    inc a
    ld [wMaxMenuItem], a
    jp HandleMenuInput

.namestring
    db "NAME@"

INCLUDE "data/player_names.asm"

GetDefaultName:
; a = name index
; hl = name list
    ld b, a
    ld c, 0
.loop
    ld d, h
    ld e, l
.innerLoop
    ld a, [hli]
    cp "@"
    jr nz, .innerLoop
    ld a, b
    cp c
    jr z, .foundName
    inc c
    jr .loop
.foundName
    ld h, d
    ld l, e
    ld de, wcd6d
    ld bc, NAME_BUFFER_LENGTH
    jp CopyData

INCLUDE "data/player_names_list.asm"

LinkMenuEmptyText:
    text_end
