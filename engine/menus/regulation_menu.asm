NewGameRegulationMenu::
    ld a, 0
    ld [wVariableA], a
    ld [wVariableB], a
    ld [wVariableE], a

    call ClearScreen
    call RunDefaultPaletteCommand
    call LoadTextBoxTilePatterns
    call LoadFontTilePatterns

.loop
    call ClearScreen
    hlcoord 0, 0
    ld b, 16
    ld c, 18
    call TextBoxBorder

    ; Start at the beginning of the index
    ld hl, NewGameRegulationMenuPage_Text_Index

    ; Set de to be our page
    ld d, 0
    ld a, [wVariableE]
    ld e, a

    ; Add our page offset twice (since each page index entry is a word)
    add hl, de
    add hl, de

    ; Load out the address that this index pointed to
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld d, a

    hlcoord 2, 2
    call PlaceString
    call UpdateSprites
    xor a
    ld [wCurrentMenuItem], a
    ld [wLastMenuItem], a
    ld [wMenuJoypadPollCount], a
    inc a
    ld [wTopMenuItemX], a
    inc a
    ld [wTopMenuItemY], a
    ld a, A_BUTTON | B_BUTTON | START
    ld [wMenuWatchedKeys], a

    ; Start at the beginning of the table
    ld hl, NewGameRegulationMenuTextPageLength

    ; set de to our page
    ld d, 0
    ld a, [wVariableE]
    ld e, a

    ; Add our page offset
    add hl, de

    ; Load out the length from the table
    ld a, [hl]

    ld [wMaxMenuItem], a
    call HandleMenuInput
    bit 1, a ; pressed B?
    jp nz, .back

    ld a, [wCurrentMenuItem]
    and a
    cp 7
    jp z, .nextPage
    jp .select
.back

    ld hl, NewGameRegulationMenu_BackTable
    ld d, 0
    ld a, [wVariableE]
    ld e, a

    add hl, de

    ld a, [hl]

    cp $FF
    jp z, .exit
    ld [wVariableE], a
    jp .loop
.nextPage
    ld a, [wVariableE]
    inc a
    ld [wVariableE], a
    jp .loop
.select

    ; Start at the beginning of the table
    ld hl, NewGameRegulationMenuPage_Action_Index

    ; set de to our page
    ld d, 0
    ld a, [wVariableE]
    ld e, a

    ; Add our page offset twice (since each page index entry is a word)
    add hl, de
    add hl, de


    ; Load out the address that this index pointed to
    ld a, [hli]
    ld e, a
    ld a, [hl]
    ld h, a
    ld l, e



    ; Load out the current menu choice
    ld d, 0
    ld a, [wCurrentMenuItem]
    ld e, a

    ; Add menu choice offset
    add hl, de
    add hl, de
    add hl, de

    ; Load out the action
    ld a, [hli]
    ld b, a
    ld a, [hli]
    ld d, a
    ld a, [hl]
    ld e, a




    ld a, b
    cp 0
    jr nz, .notVanilla
    ld a, 0
    ld [wVariableE], a
    jpfar StartNewGame
.notVanilla

    cp 1
    jr nz, .notCustom
    ld a, 1
    ld [wVariableE], a
    jpfar StartNewGame
.notCustom

    cp 2
    jr nz, .notLoadCode
    ld a, 2
    ld [wVariableE], a

    ld a, e
    ld [wVariableD], a
    ld a, d
    ld [wVariableD+1], a
    jpfar StartNewGame
.notLoadCode

    cp 3
    jr nz, .notChangePage
    ld a, d
    ld [wVariableE], a
    jp .loop
.notChangePage



.exit
    farjp DisplayTitleScreen

LoadRegulationCode:
    ld a, [wVariableD]
    ld h, a
    ld a, [wVariableD+1]
    ld l, a

    .loop

    call ProcessCodeLine

    jr z, .break

    ld a, [wVariableB]
    or a
    jr nz, .noRewind

    farcall RewindWaste

    .noRewind

    ; Advance our LoadRegulationCode pointer by 10

    ld a, [wVariableD]
    ld h, a
    ld a, [wVariableD+1]
    ld l, a

    ld de, 10
    add hl, de

    ld a, h
    ld [wVariableD], a
    ld a, l
    ld [wVariableD+1], a

    jr .loop

    .break

    ret


ProcessCodeLine:
    ld de, wcf4b

    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte
    call ProcessCodeLineByte

    ; VariableB keeps track of how many multi-lines there are left. This is used by events that have code
    ; that runs longer than one "line" of code.
    ld a, [wVariableB]
    or a

    ; Check if we have any multi-line stuff left to parse
    jr z, .normalParsing

    ; Yes we do! That means, we will now parse another line. We subtract one from VariableB since we are dealing
    ; with one of the lines now.
    dec a
    ld [wVariableB], a

    ; Call the multi-line parsing code. The difference is that this ones knows not to expect any events in the start
    farcall CopyContinuedCustomLogicCode

    ld a, 1
    or a

    ret     ; Ask for more codes


.normalParsing    ; Normal parsing, meaning this is a brand new line with the potential to be anything
    ld hl, wcf4b
    ld a, [hl]
    cp 152                          ; Is the first number above 151 (Mew)?
    jr c, .notNewCustomLogicCode    ; Nope, so player picked a pokemon

    ; The player picked custom logic, so we setup a multi-line parsing situation. The amount of multi-lines is equal to
    ; the value provided minus 152, meaning that 152 means 0 multi-lines, 153 means 1 multi-lines, etc. This is saved into
    ; variable B for later.
    sub 152
    ld [wVariableB], a

    farcall CopyNewCustomLogicCode

    ld a, 1
    or a

    ret     ; Ask for more codes

.notNewCustomLogicCode  ; It's not custom logic, that means this is the option/attribute line, the very last line allowed
    ld hl, wcf4b
    ld de, wRegulationCode
    ld bc, 10
    call CopyData

    ld a, [wRegulationCode]
    or a
    jr z, .skip

    ld [wRegulationCustomLogicVariableA+1], a
    safecall RegulationPokemonNoToIndex
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCode], a
.skip
    ld a, 0
    or a

    ret     ; Do not ask for more codes


ProcessCodeLineByte:
    ld a, [hli]
    ld [de], a
    inc de

    ld c, a

    ; Checksum calculations

    ; Load the first byte of the checksum
    ; Add the input byte
    ; Store it back into the first byte of the checksum
    ld a, [wRegulationChecksum+0]
    adc c
    ld [wRegulationChecksum+0], a

    ; Load the second byte of the checksum
    ; Subtract the first byte of the checksum
    ; Xor the input byte
    ; Store it back into the second byte of the checksum
    ld b, a
    ld a, [wRegulationChecksum+1]
    sub b
    xor c
    ld [wRegulationChecksum+1], a

    ; Load the third byte of the checksum
    ; Increment by one
    ; Store it back into the third byte of the checksum
    ld a, [wRegulationChecksum+2]
    inc a
    ld [wRegulationChecksum+2], a

    ld a, 1
    or a

    ret






NewGameRegulationMenuTextPageLength:
    db 6
    db 7
    db 7
    db 0
    db 7
    db 0
    db 4

NewGameRegulationMenu_BackTable:
    db $FF
    db 0
    db 1
    db 0
    db 0
    db 4
    db 0
    db 0

NewGameRegulationMenuPage_Text_Index:
    dw NewGameRegulationMenuPage0_Text
    dw NewGameRegulationMenuPage1_Text
    dw NewGameRegulationMenuPage2_Text
    dw NewGameRegulationMenuPage3_Text
    dw NewGameRegulationMenuPage4_Text
    dw NewGameRegulationMenuPage5_Text
    dw NewGameRegulationMenuPage6_Text
    dw NewGameRegulationMenuPage7_Text

NewGameRegulationMenuPage_Action_Index:
    dw NewGameRegulationMenuPage0_Action
    dw NewGameRegulationMenuPage1_Action
    dw NewGameRegulationMenuPage2_Action
    dw NewGameRegulationMenuPage3_Action
    dw NewGameRegulationMenuPage4_Action
    dw NewGameRegulationMenuPage5_Action
    dw NewGameRegulationMenuPage6_Action
    dw NewGameRegulationMenuPage7_Action

NewGameRegulationMenuPage0_Text:
    db "VANILLA GAME"
    next "CUSTOM CODE"
    next "MONOTYPE"
    next "RANDOMIZED"
    next "CHALLENGE"
    next "PUZZLE"
    next "NIGHTMARE@"

NewGameRegulationMenuPage0_Action:
    db 0
    dw 0

    db 1
    dw 0

    db 3
    dw 1

    db 3
    dw 3

    db 3
    dw 4

    db 3
    dw 6

    db 3
    dw 7


NewGameRegulationMenuPage1_Text:
    db "NORMAL"
    next "FIGHTING"
    next "FLYING"
    next "POISON"
    next "GROUND"
    next "ROCK"
    next "BUG"
    next "NEXT PAGE@"

NewGameRegulationMenuPage1_Action:
    db 2
    dw NewGameRegulationMenuMonoNormal
    db 2
    dw NewGameRegulationMenuMonoFighting
    db 2
    dw NewGameRegulationMenuMonoFlying
    db 2
    dw NewGameRegulationMenuMonoPoison
    db 2
    dw NewGameRegulationMenuMonoGround
    db 2
    dw NewGameRegulationMenuMonoRock
    db 2
    dw NewGameRegulationMenuMonoBug
    db 3
    dw 2


NewGameRegulationMenuPage2_Text:
    db "GHOST"
    next "FIRE"
    next "WATER"
    next "GRASS"
    next "ELECTRIC"
    next "PSYCHIC"
    next "ICE"
    next "DRAGON@"

NewGameRegulationMenuPage2_Action:
    db 2
    dw NewGameRegulationMenuMonoGhost
    db 2
    dw NewGameRegulationMenuMonoFire
    db 2
    dw NewGameRegulationMenuMonoWater
    db 2
    dw NewGameRegulationMenuMonoGrass
    db 2
    dw NewGameRegulationMenuMonoElectric
    db 2
    dw NewGameRegulationMenuMonoPsychic
    db 2
    dw NewGameRegulationMenuMonoIce
    db 2
    dw NewGameRegulationMenuMonoDragon

NewGameRegulationMenuPage3_Text:
    db "RANDOM #MON@"



NewGameRegulationMenuPage3_Action:
    db 2
    dw NewGameRegulationMenuRandomPokemon
    db 2
    dw NewGameRegulationMenuRandomPokemon


NewGameRegulationMenuPage4_Text:
    db "DISCOUNT DITTO"
    next "TEAM ROCKET"
    next "NO EXP"
    next "ROGUELIKE"
    next "WONDERGUARD"
    next "NUZLOCKE"
    next "THE OUTCAST"
    next "NEXT PAGE@"

NewGameRegulationMenuPage4_Action:
    db 2
    dw NewGameRegulationMenuDiscountDitto
    db 2
    dw NewGameRegulationMenuTeamRocket
    db 2
    dw NewGameRegulationMenuNoExp
    db 2
    dw NewGameRegulationMenuRoguelike
    db 2
    dw NewGameRegulationMenuWonderguard
    db 2
    dw NewGameRegulationMenuNuzlocke
    db 2
    dw NewGameRegulationMenuTheOutcast
    db 3
    dw 4

NewGameRegulationMenuPage5_Text:
    db "TECHNIQUE FATIGUE@"

NewGameRegulationMenuPage5_Action:
    db 2
    dw NewGameRegulationMenuTechniqueFatigue


NewGameRegulationMenuPage6_Text:
    db "CREEPYPASTA"
    next "CLIPPED WINGS"
    next "THUNDERFISH"
    next "PAY2WIN"
    next "SNAKES N'LADDERS@"

NewGameRegulationMenuPage6_Action:
    db 2
    dw NewGameRegulationMenuCreepypasta
    db 2
    dw NewGameRegulationMenuClippedWings
    db 2
    dw NewGameRegulationMenuThunderfish
    db 2
    dw NewGameRegulationMenuPay2Win
    db 2
    dw NewGameRegulationMenuSnakesNLadders


NewGameRegulationMenuPage7_Text:
    db "RIP AND TEAR"
    next "BALLS OF STEEL@"


NewGameRegulationMenuPage7_Action:
    db 2
    dw NewGameRegulationMenuRipAndTear
    db 2
    dw NewGameRegulationMenuBallsOfSteel







PUSHC
SETCHARMAP RegulationCode

NewGameRegulationMenuMonoNormal:
    db "13010010100000000000"

NewGameRegulationMenuMonoFighting:
    db "42020010100000000000"

NewGameRegulationMenuMonoFlying:
    db "10030010100000000000"

NewGameRegulationMenuMonoPoison:
    db "6D040010100000000000"

NewGameRegulationMenuMonoGround:
    db "32050010100000000000"

NewGameRegulationMenuMonoRock:
    db "4A060010100000000000"

NewGameRegulationMenuMonoBug:
    db "0A070010100000000000"

NewGameRegulationMenuMonoGhost:
    db "5C080010100000000000"

NewGameRegulationMenuMonoFire:
    db "04090010100000000000"

NewGameRegulationMenuMonoWater:
    db "070A0010100000000000"

NewGameRegulationMenuMonoGrass:
    db "010B0010100000000000"

NewGameRegulationMenuMonoElectric:
    db "640C0010100000000000"

NewGameRegulationMenuMonoPsychic:
    db "600D0010100000000000"

NewGameRegulationMenuMonoIce:
    db "830E0010100000000000"

NewGameRegulationMenuMonoDragon:
    db "930F0010100000000000"

NewGameRegulationMenuRandomPokemon: ; Checksum 792B46
    db "9901AC10149D1F171495958D01AC0ED7D701FF00980F00000000000000009815000000000000000099064B9A1F4E171495958D01AC0E27FF0000000000000000000000000000"

NewGameRegulationMenuDiscountDitto:
    db "84000010026666666600"

NewGameRegulationMenuTeamRocket:
    db "3400D000010000060000"

NewGameRegulationMenuNoExp:
    db "00000680000000000000"

NewGameRegulationMenuRoguelike:
    db "001000810C0000000000"

NewGameRegulationMenuRipAndTear:
    db "81C02090307800000000"

NewGameRegulationMenuNuzlocke:
    db "8400401514210000001"

NewGameRegulationMenuTheOutcast:
    db "0000000800000000000E"

NewGameRegulationMenuWonderguard:
    db "00000000400000000020"

NewGameRegulationMenuTechniqueFatigue:
    db "00002070000000000000"

NewGameRegulationMenuBallsOfSteel:
    db "AF1DB108BA079F2827FF21012201230124012501260127011C032B0120012D012E012A022A012A030000374553616F7D8B99A7B5C3D1DFDFDFFF0CA90E2214271E312862325A00FF121B1598148A1E6F289B328000FF1506125418551E352868323600FF1DBE181E1DBB280A322E3C9A00FF253727882537308F32823C0E00"
    db "FF2626252A26772B9532813C1500FF2A2128A32AA42F1432673C5300FF2D122A762C102D0732013C6100FF3678358B3608384838133C4A00FF3522372C372B38223A7E467500FF380E388237933A2D3C0E469100FF3A16385938593CAB3E4250B400FF3D973B953D01509A501C50B4000084A00080907600000041"

NewGameRegulationMenuCreepypasta:
    db "5C000840040C78FF0000"

NewGameRegulationMenuClippedWings:
    db "1000060900A5FF000000"

NewGameRegulationMenuThunderfish:
    db "810A0000015499000000"

NewGameRegulationMenuPay2Win:
    db "89000440060606060600"

NewGameRegulationMenuSnakesNLadders: ; Checksum 5D7778
    db "98017F09AC0CFF0000009814AC05FF0000000000991B7F01D9CFFABF012CD9CFF6D9CFF4D9CFE6FF98100000000000000000981100000000000000009812000000000000000098137F9929FF000000009A1DDD2101BA267F2727FFFF64226422642264226422642200000000000017000608000F00000001"

POPC


