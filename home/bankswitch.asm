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
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
    ldh a, [hLoadedROMBank]     ; load what bank we are currently in
    push af                     ; save it for later
    ld a, f
    ldh [hLoadedROMBank], a     ; save the bank we are jumping into
    ld [MBC1RomBank], a         ; switch banks
    ld bc, .return              ; load address we will return to once this safecall is done
    push bc                     ; push the address we will return to
    push hl                     ; push the address we will jump to right now



    ;ld a, [wSafeBankBackup+3]   ; load l
    ;ld l, a
    ;ld a, [wSafeBankBackup+2]   ; load h
    ;ld h, a
    ;ld a, [wSafeBankBackup+1]   ; load b
    ;ld b, a
    ;ld a, [wSafeBankBackup]     ; load a
    ret                         ; jump to the address given by hl
.return



    pop bc
    ld a, b
    ldh [hLoadedROMBank], a
    ld [MBC1RomBank], a
    ret
