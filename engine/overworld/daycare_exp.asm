IncrementDayCareMonExp:
	ld a, [wDayCareInUse]
	and a
	ret z
    call IncrementwRegulationTotalExp
	ld hl, wDayCareMonExp + 2
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	ret c
	ld a, $50
	ld [hl], a
	ret

IncrementwRegulationTotalExp:
    ld hl, wRegulationTotalExp + 2
    inc [hl]
    ret nz
    dec hl
    inc [hl]
    ret nz
    dec hl
    inc [hl]
    ret
