ApplyOutOfBattlePoisonDamage:
	ld a, [wd730]
	add a
	jp c, .noBlackOut ; no black out if joypad states are being simulated
	ld a, [wPartyCount]
	and a
	jp z, .noBlackOut
	call IncrementDayCareMonExp
	ld a, [wStepCounter]
	and $3 ; is the counter a multiple of 4?
	jp nz, .noBlackOut ; only apply poison damage every fourth step
	ld [wWhichPokemon], a
	ld hl, wPartyMon1Status
	ld de, wPartySpecies
.applyDamageLoop
	ld a, [hl]
	and (1 << PSN)
	jr z, .nextMon2 ; not poisoned
	dec hl
	dec hl
	ld a, [hld]
	ld b, a
	ld a, [hli]
	or b
	jr z, .nextMon ; already fainted
; subtract 1 from HP
    call RecordPoisonDamage
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
; borrow 1 from upper byte of HP
	dec [hl]
	inc hl
	jr .nextMon
.noBorrow
	ld a, [hli]
	or [hl]
	jr nz, .nextMon ; didn't faint from damage
; the mon fainted from the damage
	push hl
	inc hl
	inc hl
	ld [hl], a
	ld a, [de]
	ld [wd11e], a
	push de
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	xor a
	ld [wJoyIgnore], a
	call EnableAutoTextBoxDrawing
	ld a, TEXT_MON_FAINTED
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	pop de
	pop hl
.nextMon
	inc hl
	inc hl
.nextMon2
	inc de
	ld a, [de]
	inc a
	jr z, .applyDamageLoopDone
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	push hl
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	jr .applyDamageLoop
.applyDamageLoopDone
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
.countPoisonedLoop
	ld a, [hl]
	and (1 << PSN)
	or e
	ld e, a
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	dec d
	jr nz, .countPoisonedLoop
	ld a, e
	and a ; are any party members poisoned?
	jr z, .skipPoisonEffectAndSound
	ld b, $2
	predef ChangeBGPalColor0_4Frames ; change BG white to dark grey for 4 frames
	ld a, SFX_POISONED
	call PlaySound
.skipPoisonEffectAndSound
	predef AnyPartyAlive
	ld a, d
	and a
	jr nz, .noBlackOut
	call EnableAutoTextBoxDrawing
	ld a, TEXT_BLACKED_OUT
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wd72e
	set 5, [hl]
	ld a, $ff
	ld [wOutOfBattleBlackout], a
    CheckEventHL EVENT_IN_SAFARI_ZONE ; check if we are in the safari zone
    jr z, .noSafari
    ; Record that this glitch was used
    ld a, [wRegulationGlitch]
    set 1, a
    ld [wRegulationGlitch], a
.noSafari
	ret

.noBlackOut
    xor a
    ld [wOutOfBattleBlackout], a
    ret

RecordPoisonDamage:
    push hl



    ; Add the damage gained to the total damage recorded
    ld a, 1
    ld hl, wRegulationTotalDamageTaken+2
    add a, [hl]
    ld [wRegulationTotalDamageTaken+2], a
    ld a, 0
    ld hl, wRegulationTotalDamageTaken+1
    adc a, [hl]
    ld [wRegulationTotalDamageTaken+1], a
    ld a, 0
    ld hl, wRegulationTotalDamageTaken
    adc a, [hl]
    ld [wRegulationTotalDamageTaken], a

    jr nc, .noOverflow

    ld a, $FF
    ld [wRegulationTotalDamageTaken+2], a
    ld [wRegulationTotalDamageTaken+1], a
    ld [wRegulationTotalDamageTaken], a

.noOverflow


    pop hl
    ret
