farcall: MACRO
	ld b, BANK(\1)
	ld hl, \1
	call Bankswitch
ENDM

callfar: MACRO
	ld hl, \1
	ld b, BANK(\1)
	call Bankswitch
ENDM

farjp: MACRO
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
ENDM

jpfar: MACRO
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
ENDM

homecall: MACRO
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call \1
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
ENDM

homecall_sf: MACRO ; homecall but save flags by popping into bc instead of af
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call \1
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
ENDM

safecall: MACRO
    ;push af
    ;push hl

    ;ld [wSafeBankBackup], a     ; save a
    ;ld a, b
    ;ld [wSafeBankBackup+1], a   ; save b
    ;ld a, h
    ;ld [wSafeBankBackup+2], a   ; save h
    ;ld a, l
    ;ld [wSafeBankBackup+3], a   ; save l
    ld f, BANK(\1)
    ld hl, \1
    call SafeBankswitch
ENDM
