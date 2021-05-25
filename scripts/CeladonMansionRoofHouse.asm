CeladonMansionRoofHouse_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansionRoofHouse_TextPointers:
	dw CeladonMansion5Text1
	dw CeladonMansion5Text2

CeladonMansion5Text1:
	text_far _CeladonMansion5Text1
	text_end

CeladonMansion5Text2:
    text_asm
    ld a, [wCustomPokemonCode+2]    ; load out the gift pokemon rule
    and $40                         ; only look at bit 6
    jr z, .continue
    ld hl, .noEevee
    call PrintText
    jp TextScriptEnd
.continue

	lb bc, EEVEE, 25
	call GivePokemon
	jr nc, .party_full
	ld a, HS_CELADON_MANSION_EEVEE_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
.party_full
	jp TextScriptEnd


.noEevee
    text_far _CeladonMansionNoEevee
    text_end

