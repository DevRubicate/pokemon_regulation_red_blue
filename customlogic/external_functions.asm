bankpointer: MACRO
    dw \1
    db BANK(\1)
ENDM

ExternalFunctions::
    bankpointer AIUseFullRestore                ; 0
    bankpointer AIUsePotion                     ; 1
    bankpointer AIUseSuperPotion                ; 2
    bankpointer AIUseHyperPotion                ; 3
    bankpointer AIUseFullHeal                   ; 4
    bankpointer AIUseXAccuracy                  ; 5
    bankpointer AIUseGuardSpec                  ; 6
    bankpointer AIUseDireHit                    ; 7
    bankpointer AIUseXAttack                    ; 8
    bankpointer AIUseXDefend                    ; 9
    bankpointer AIUseXSpeed                     ; 10
    bankpointer AIUseXSpecial                   ; 11
    bankpointer RegulationHideObject            ; 12
    bankpointer RegulationShowObject            ; 13

RegulationHideObject::
    ld hl, wMissableObjectFlags
    ld a, [wRegulationCustomLogicVariableA+1]
    ld c, a
    ld b, FLAG_SET
    safecall FlagAction
    safecall UpdateSprites
    ret

RegulationShowObject::
    ld hl, wMissableObjectFlags
    ld a, [wRegulationCustomLogicVariableA+1]
    ld c, a
    ld b, FLAG_RESET
    safecall FlagAction
    safecall UpdateSprites
    ret
