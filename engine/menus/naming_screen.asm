AskName:
	call SaveScreenTilesToBuffer1
	call GetPredefRegisters
	push hl
	ld a, [wIsInBattle]
	dec a
	hlcoord 0, 0
	ld b, 4
	ld c, 11
	call z, ClearScreenArea ; only if in wild battle
	ld a, [wcf91]
	ld [wd11e], a
	call GetMonName
	ld hl, DoYouWantToNicknameText
	call PrintText
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declinedNickname
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	push hl
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wIsInBattle]
	and a
	jr nz, .inBattle
	call ReloadMapSpriteTilePatterns
.inBattle
	call LoadScreenTilesFromBuffer1
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ld a, [wcf4b]
	cp "@"
	ret nz
.declinedNickname
	ld d, h
	ld e, l
	ld hl, wcd6d
	ld bc, NAME_LENGTH
	jp CopyData

DoYouWantToNicknameText:
	text_far _DoYouWantToNicknameText
	text_end

DisplayNameRaterScreen::
	ld hl, wBuffer
	xor a
	ld [wUpdateSpritesEnabled], a
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	ld a, [wcf4b]
	cp "@"
	jr z, .playerCancelled
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wBuffer
	ld bc, NAME_LENGTH
	call CopyData
	and a
	ret
.playerCancelled
	scf
	ret


DisplayNamingScreen:
	push hl
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call LoadHpBarAndStatusTilePatterns
	call LoadEDTile
    ld a, [wNamingScreenType]
    cp NAME_MON_SCREEN
    jr z, .showSprite
    jr .skipSprite
.showSprite
    farcall LoadMonPartySpriteGfx
.skipSprite
	hlcoord 0, 4
	ld b, 9
	ld c, 18
	call TextBoxBorder
	call PrintNamingText
	ld a, 3
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld [wLastMenuItem], a
	ld [wCurrentMenuItem], a
	ld a, $ff
	ld [wMenuWatchedKeys], a
	ld a, 7
	ld [wMaxMenuItem], a
	ld a, "@"
	ld [wcf4b], a
	xor a
	ld hl, wNamingScreenSubmitName
	ld [hli], a
	ld [hli], a
	ld [wAnimCounter], a
.selectReturnPoint
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .useCodeInput
	call PrintAlphabet
	call GBPalNormal
    jr .ABStartReturnPoint
.useCodeInput
    call PrintCodeInput
    call GBPalNormal
.ABStartReturnPoint
	ld a, [wNamingScreenSubmitName]
	and a
	jr nz, .submitNickname
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr nz, .printName
    call PrintCodeAndUnderscores
    jr .dPadReturnPoint
.printName
	call PrintNicknameAndUnderscores
.dPadReturnPoint
	call PlaceMenuCursor
.inputLoop
	ld a, [wCurrentMenuItem]
	push af
	farcall AnimatePartyMon_ForceSpeed1
	pop af
	ld [wCurrentMenuItem], a
	call JoypadLowSensitivity
	ldh a, [hJoyPressed]
	and a
	jr z, .inputLoop
	ld hl, .namingScreenButtonFunctions
.checkForPressedButton
	sla a
	jr c, .foundPressedButton
	inc hl
	inc hl
	inc hl
	inc hl
	jr .checkForPressedButton
.foundPressedButton
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	jp hl

.submitNickname
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .submitCode
	pop de
	ld hl, wcf4b
	ld bc, NAME_LENGTH
	call CopyData
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call ClearSprites
	call RunDefaultPaletteCommand
	call GBPalNormal
	xor a
	ld [wAnimCounter], a
	ld hl, wd730
	res 6, [hl]
	ld a, [wIsInBattle]
	and a
	jp z, LoadTextBoxTilePatterns
	jpfar LoadHudTilePatterns

.submitCode
    pop de
    ld hl, wcf4b
    ld de, wcf4b
    ld bc, 10
    call ProcessCode
    call SaveCode
    jr nz, .doneInputtingCodeSegments

    ; clear out the text buffer
    ld a, 0
    ld [wcf4b+ 0], a
    ld [wcf4b+ 1], a
    ld [wcf4b+ 2], a
    ld [wcf4b+ 3], a
    ld [wcf4b+ 4], a
    ld [wcf4b+ 5], a
    ld [wcf4b+ 6], a
    ld [wcf4b+ 7], a
    ld [wcf4b+ 8], a
    ld [wcf4b+ 9], a
    ld [wcf4b+10], a
    ld [wcf4b+11], a
    ld [wcf4b+12], a
    ld [wcf4b+13], a
    ld [wcf4b+14], a
    ld [wcf4b+15], a
    ld [wcf4b+16], a
    ld [wcf4b+17], a
    ld [wcf4b+18], a
    ld [wcf4b+19], a

    jp DisplayNamingScreen              ; Player gets to write another segment

.doneInputtingCodeSegments
    call GBPalWhiteOutWithDelay3
    call ClearScreen
    call ClearSprites
    call RunDefaultPaletteCommand
    call GBPalNormal
    xor a
    ld [wAnimCounter], a
    ld hl, wd730
    res 6, [hl]
    ld a, [wIsInBattle]
    and a
    jp z, LoadTextBoxTilePatterns
    jpfar LoadHudTilePatterns


.namingScreenButtonFunctions
	dw .dPadReturnPoint
	dw .pressedDown
	dw .dPadReturnPoint
	dw .pressedUp
	dw .dPadReturnPoint
	dw .pressedLeft
	dw .dPadReturnPoint
	dw .pressedRight
	dw .ABStartReturnPoint
	dw .pressedStart
	dw .selectReturnPoint
	dw .pressedSelect
	dw .ABStartReturnPoint
	dw .pressedB
	dw .ABStartReturnPoint
	dw .pressedA

.pressedA_changedCase
	pop de
	ld de, .selectReturnPoint
	push de
.pressedSelect
	ld a, [wAlphabetCase]
	xor $1
	ld [wAlphabetCase], a
	ret

.pressedStart
	ld a, 1
	ld [wNamingScreenSubmitName], a
	ret

.pressedA
	ld a, [wCurrentMenuItem]
	cp $5 ; "ED" row
	jr nz, .didNotPressED
	ld a, [wTopMenuItemX]
	cp $11 ; "ED" column
	jr z, .pressedStart
.didNotPressED
	ld a, [wCurrentMenuItem]
	cp $6 ; case switch row
	jr nz, .didNotPressCaseSwtich
	ld a, [wTopMenuItemX]
	cp $1 ; case switch column
	jr z, .pressedA_changedCase
.didNotPressCaseSwtich
	ld hl, wMenuCursorLocation
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hl]
	ld [wNamingScreenLetter], a
	call CalcStringLength
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .checkCodeLength
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, .checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $7 ; max length of player/rival names
	jr .checkNameLength
.checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp $a ; max length of pokemon nicknames
.checkNameLength
	jr c, .addLetter
	ret
.checkCodeLength
    ld a, [wNamingScreenNameLength]
    cp 20 ; max length of codes
    jr c, .addLetter
    ret

.addLetter
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr nz, .continue
    ld a, [wNamingScreenLetter] ; forbid whitespace in a code
    cp " "
    jr z, .preventLetter
.continue
	ld a, [wNamingScreenLetter]
	ld [hli], a
	ld [hl], "@"
	ld a, SFX_PRESS_AB
	call PlaySound
	ret
.preventLetter
    ret
.pressedB
	ld a, [wNamingScreenNameLength]
	and a
	ret z
	call CalcStringLength
	dec hl
	ld [hl], "@"
	ret
.pressedRight
	ld a, [wCurrentMenuItem]
	cp $6
	ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	cp $11 ; max
	jp z, .wrapToFirstColumn
	inc a
	inc a
	jr .done
.wrapToFirstColumn
	ld a, $1
	jr .done
.pressedLeft
	ld a, [wCurrentMenuItem]
	cp $6
	ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	dec a
	jp z, .wrapToLastColumn
	dec a
	jr .done
.wrapToLastColumn
	ld a, $11 ; max
	jr .done
.pressedUp
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	and a
	ret nz
	ld a, $6 ; wrap to bottom row
	ld [wCurrentMenuItem], a
	ld a, $1 ; force left column
	jr .done
.pressedDown
	ld a, [wCurrentMenuItem]
	inc a
	ld [wCurrentMenuItem], a
	cp $7
	jr nz, .wrapToTopRow
	ld a, $1
	ld [wCurrentMenuItem], a
	jr .done
.wrapToTopRow
	cp $6
	ret nz
	ld a, $1
.done
	ld [wTopMenuItemX], a
	jp EraseMenuCursor


ProcessCode:
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte
    call ProcessCodeByte

    ld a, 0
    ld [wcf4b+10], a    ; Make sure the code terminates with a 0

    ; Count how long the length is
    ld a, 11
    ld b, a
    ld hl, wcf4b+10
.loop
    dec b
    dec hl
    ld a, [hl]
    cp 0
    jr z, .loop
    ld a, b
    ld [wVariableA], a  ; Save the length of the code in VariableA

    ret


ProcessCodeByte:
    ld a, [hli]
    cp $50
    jr z, .zero
    cp $0
    jr z, .zero
.continue
    cp $f0
    jr nc, .number
    sbc $75
    jr .save
.number
    sbc $f6
.save
    ld b, a
    sla b
    sla b
    sla b
    sla b
    ld a, [hli]
    cp $50
    jr z, .zero2
    cp $0
    jr z, .zero2
.continue2
    cp $f0
    jr nc, .number2
    sbc $75
    jr .save2
.number2
    sbc $f6
.save2
    adc b
    ld [de], a
    inc de
    ret
.zero
    ld a, $f6
    jr .continue
.zero2
    ld a, $f6
    jr .continue2

SaveCode:
    ld hl, wcf4b
    ld a, [hl]
    cp $FF                      ; Is the value FF, which means custom logic?
    jr nz, .notNewCustomLogicCode
    call CopyNewCustomLogicCode

    call ClearScreen
    call ClearSprites
    ld hl, CodeAcceptedGiveNextPart
    call PrintText

    xor a
    ret     ; Ask for more codes
.notNewCustomLogicCode
    jr nz, .notContinuedCustomLogicCode
    call CopyContinuedCustomLogicCode

    call ClearScreen
    call ClearSprites
    ld hl, CodeAcceptedGiveNextPart
    call PrintText

    xor a
    ret     ; Ask for more codes
.notContinuedCustomLogicCode

    cp 152                      ; Have you inputed a starter pokemon between 0 to 151?
    jr nc, .notFinalCode
    call CopyFinalCode

    ld a, 1
    or a
    ret     ; Do not ask for more codes
.notFinalCode
    ; ouch this code wasn't acceptable, tell that to the player
    call ClearScreen
    call ClearSprites
    ld hl, InvalidRegulationCode
    call PrintText

    xor a
    ret     ; Ask for new code

CopyFinalCode:
; Copy bc bytes from hl to de.
    ld hl, wcf4b
    ld de, wRegulationCode
    ld bc, 10
    call CopyData
    ret

CopyNewCustomLogicCode:
    ld hl, wcf4b+1
    ld a, [hl]
    cp $01                                           ; Trigger CalculateEnemyLevel
    jr nz, .noTriggerCalculateEnemyLevel

    ld a, 1
    ld [wRegulationTriggerCalculateEnemyLevel], a

    jr .copy
.noTriggerCalculateEnemyLevel
    ;cp $2                           ; Trigger: B
    ;cp $3                           ; Trigger: C

.copy
    ld bc, 0
    ld a, [wVariableA]              ; Load the length of the code
    sub 1                           ; Subtract 2 (to account for us skipping the initial $FF and the trigger code), but add 1 for the extra terminator
    ld c, a                         ; Load a into b, bc should now be the length - 2
    ld hl, wcf4b+2                  ; Copy starting 2 bytes out, skipping the initial $FF for custom logic and the trigger code
    ld de, wRegulationCustomLogic   ; destination
    call CopyData
    ret

CopyContinuedCustomLogicCode:

    ret

LoadEDTile:
	ld de, ED_Tile
	ld hl, vFont tile $70
	ld bc, (ED_TileEnd - ED_Tile) / $8
	; to fix the graphical bug on poor emulators
	;lb bc, BANK(ED_Tile), (ED_TileEnd - ED_Tile) / $8
	jp CopyVideoDataDouble

ED_Tile:
	INCBIN "gfx/font/ED.1bpp"
ED_TileEnd:

PrintAlphabet:
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, [wAlphabetCase]
	and a
	ld de, LowerCaseAlphabet
	jr nz, .lowercase
	ld de, UpperCaseAlphabet
.lowercase
	hlcoord 2, 5
	lb bc, 5, 9 ; 5 rows, 9 columns
.outerLoop
	push bc
.innerLoop
	ld a, [de]
	ld [hli], a
	inc hl
	inc de
	dec c
	jr nz, .innerLoop
	ld bc, SCREEN_WIDTH + 2
	add hl, bc
	pop bc
	dec b
	jr nz, .outerLoop
	call PlaceString
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	jp Delay3

PrintCodeInput:
    xor a
    ldh [hAutoBGTransferEnabled], a
    ld de, CodeInput
    hlcoord 2, 5
    lb bc, 2, 9 ; 5 rows, 9 columns
.outerLoop
    push bc
.innerLoop
    ld a, [de]
    ld [hli], a
    inc hl
    inc de
    dec c
    jr nz, .innerLoop
    ld bc, SCREEN_WIDTH + 2
    add hl, bc
    pop bc
    dec b
    jr nz, .outerLoop
    call PlaceString

    hlcoord 18, 13
    ld de, CodeInputEnd
    call PlaceString

    ld a, $1
    ldh [hAutoBGTransferEnabled], a
    jp Delay3


INCLUDE "data/text/alphabets.asm"
INCLUDE "data/text/codeinput.asm"

PrintNicknameAndUnderscores:
	call CalcStringLength
	ld a, c
	ld [wNamingScreenNameLength], a
	hlcoord 10, 2
	lb bc, 1, 19
	call ClearScreenArea
	hlcoord 10, 2
	ld de, wcf4b
	call PlaceString
	hlcoord 10, 3
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .codeinput1
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, .pokemon1
	ld b, 7 ; player or rival max name length
	jr .playerOrRival1
.codeinput1
    ld b, 20 ; code max input
    jr .playerOrRival1
.pokemon1
	ld b, 10 ; pokemon max name length
.playerOrRival1
	ld a, $76 ; underscore tile id
.placeUnderscoreLoop
	ld [hli], a
	dec b
	jr nz, .placeUnderscoreLoop
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .codeinput2
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, [wNamingScreenNameLength]
	jr nc, .pokemon2
	cp 7 ; player or rival max name length
	jr .playerOrRival2
.codeinput2
    cp 20 ; code max input
    jr .playerOrRival2
.pokemon2
	cp 10 ; pokemon max name length
.playerOrRival2
	jr nz, .emptySpacesRemaining
	; when all spaces are filled, force the cursor onto the ED tile
	call EraseMenuCursor
	ld a, $11 ; "ED" x coord
	ld [wTopMenuItemX], a
	ld a, $5 ; "ED" y coord
	ld [wCurrentMenuItem], a
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, 9 ; keep the last underscore raised
	jr nc, .pokemon3
	ld a, 6 ; keep the last underscore raised
.pokemon3
.emptySpacesRemaining
	ld c, a
	ld b, $0
	hlcoord 10, 3
	add hl, bc
	ld [hl], $77 ; raised underscore tile id
	ret

PrintCodeAndUnderscores:
    call CalcStringLength
    ld a, c
    ld [wNamingScreenNameLength], a
    hlcoord 0, 2
    lb bc, 1, 20
    call ClearScreenArea
    hlcoord 0, 2
    ld de, wcf4b
    call PlaceString
    hlcoord 0, 3
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .codeinput1
    ld a, [wNamingScreenType]
    cp NAME_MON_SCREEN
    jr nc, .pokemon1
    ld b, 7 ; player or rival max name length
    jr .playerOrRival1
.codeinput1
    ld b, 20 ; code max input
    jr .playerOrRival1
.pokemon1
    ld b, 10 ; pokemon max name length
.playerOrRival1
    ld a, $76 ; underscore tile id
.placeUnderscoreLoop
    ld [hli], a
    dec b
    jr nz, .placeUnderscoreLoop
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .codeinput2
    ld a, [wNamingScreenType]
    cp NAME_MON_SCREEN
    ld a, [wNamingScreenNameLength]
    jr nc, .pokemon2
    cp 7 ; player or rival max name length
    jr .playerOrRival2
.codeinput2
    cp 20 ; code max input
    jr .playerOrRival2
.pokemon2
    cp 10 ; pokemon max name length
.playerOrRival2
    jr nz, .emptySpacesRemaining
    ; when all spaces are filled, force the cursor onto the ED tile
    call EraseMenuCursor
    ld a, $11 ; "ED" x coord
    ld [wTopMenuItemX], a
    ld a, $5 ; "ED" y coord
    ld [wCurrentMenuItem], a
    ld a, [wNamingScreenType]
    cp NAME_MON_SCREEN
    ld a, 9 ; keep the last underscore raised
    jr nc, .pokemon3
    ld a, 6 ; keep the last underscore raised
.pokemon3
.emptySpacesRemaining
    ld c, a
    ld b, $0
    hlcoord 0, 3
    add hl, bc
    ret

; calculates the length of the string at wcf4b and stores it in c
CalcStringLength:
	ld hl, wcf4b
	ld c, $0
.loop
	ld a, [hl]
	cp "@"
	ret z
	inc hl
	inc c
	jr .loop

PrintNamingText:
	hlcoord 0, 1
    ld a, [wNamingScreenType]
    cp NAME_CODE_SCREEN
    jr z, .codeString
	ld a, [wNamingScreenType]
	ld de, YourTextString
	and a
	jr z, .notNickname
	ld de, RivalsTextString
	dec a
	jr z, .notNickname
	ld a, [wcf91]
	ld [wMonPartySpriteSpecies], a
	push af
	farcall WriteMonPartySpriteOAMBySpecies
	pop af
	ld [wd11e], a
	call GetMonName
	hlcoord 4, 1
	call PlaceString
	hlcoord 1, 3
	ld de, YourTextString
	jr .placeString
.notNickname
	call PlaceString
	ld l, c
	ld h, b
	ld de, NameTextString
.placeString
	jp PlaceString
.codeString
    hlcoord 2, 0
    ld de, CodeTextString
    call PlaceString
    hlcoord 1, 16
    ld de, VersionString
    call PlaceString
    hlcoord 8, 16
    ld de, AuthorString
    jp PlaceString


YourTextString:
	db "YOUR @"

RivalsTextString:
	db "RIVAL's @"

NameTextString:
	db "NAME?@"

CodeTextString:
	db "Regulation Code@"

AuthorString:
    db "By Rubicate@"

VersionString:
    db "v5@"

CodeAcceptedGiveNextPart:
    text_far _CodeAcceptedGiveNextPart
    text_end

InvalidRegulationCode:
    text_far _InvalidRegulationCode
    text_end

