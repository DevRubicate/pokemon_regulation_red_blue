LoadWildData::
	ld hl, WildDataPointers
	ld a, [wCurMap]

	; get wild data for current map
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	ld a, [hli]
	ld [wGrassRate], a
	and a
	jr z, .NoGrassData ; if no grass data, skip to surfing data

    ld a, 0
    ld [wGrassGlitchActive], a
    ld a, [wGrassRate]

	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, $14
	call CopyData
	pop hl
	ld bc, $14
	add hl, bc
.continue
	ld a, [hli]
	ld [wWaterRate], a
	and a
	ret z        ; if no water data, we're done
	ld de, wWaterMons  ; otherwise, load surfing data
	ld bc, $14
	jp CopyData


.NoGrassData
    ld a, 1
    ld [wGrassGlitchActive], a
    ld a, [wGrassRate]
    jr .continue

INCLUDE "data/wild/grass_water.asm"
