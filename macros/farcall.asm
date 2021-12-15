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
    jr :++                      ; jump to the end of safecall so that's where we end up once it's over
:
    ld [wSafeBankBackup], a     ; save a
    ld a, h
    ld [wSafeBankBackup+1], a   ; save h
    ld a, l
    ld [wSafeBankBackup+2], a   ; save l

    ldh a, [hLoadedROMBank]     ; load what bank we are currently in
    push af                     ; save bank for later

    ld hl, SafeBankswitchReturn ; load address we will return to once this safecall is done
    push hl                     ; push the address we will return to

    ld a, BANK(\1)              ; load the bank we wanna go to
    ld hl, \1                   ; load the address we wanna go to
    jp SafeBankswitch           ; jump to SafeBankSwitch which isn't stored in a bank itself
:
    call :--                     ; use a call to ensure this is where we return once we are done
ENDM
