BankswitchHome::
; switches to bank # in a
; Only use this when in the home bank!
	ld [wBankswitchHomeTemp], a
	ldh a, [hLoadedROMBank]
	ld [wBankswitchHomeSavedROMBank], a
	ld a, [wBankswitchHomeTemp]
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret

BankswitchBack::
; returns from BankswitchHome
	ld a, [wBankswitchHomeSavedROMBank]
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret

Bankswitch::
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ld bc, .Return
	push bc
	jp hl
.Return
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret

SafeBankswitch::
    ldh [hLoadedROMBank], a     ; save the bank we are jumping into
    ld [MBC1RomBank], a         ; switch banks
    push hl                     ; push the address will be jumping to
    ld a, [wSafeBankBackup+2]   ; load l
    ld l, a
    ld a, [wSafeBankBackup+1]   ; load h
    ld h, a
    ld a, [wSafeBankBackup]     ; load a
    ret                         ; reverse-jump to the address pushed by hl earlier

SafeBankswitchReturn::
    ld [wSafeBankBackup], a     ; save a
    ld a, h
    ld [wSafeBankBackup+1], a   ; save h
    ld a, l
    ld [wSafeBankBackup+2], a   ; save l
    pop hl                      ; load what bank we want to return to
    ld a, h
    ldh [hLoadedROMBank], a     ; save the bank we are jumping back to
    ld [MBC1RomBank], a         ; switch banks
    ld a, [wSafeBankBackup+2]   ; load l
    ld l, a
    ld a, [wSafeBankBackup+1]   ; load h
    ld h, a
    ld a, [wSafeBankBackup]     ; load a
    ret                         ; return to orginal caller
