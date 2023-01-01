RegulationTriggerStart: MACRO
    ld a, [\1]
    or a
    jp z, :+

    push bc
    push de
    push hl

    ; Load Variable A
    IF DEF(\2)
        ld a, [\2]
        ld [wVariableA], a
    ENDC
    IF DEF(\3)
        ld a, [\3]
        ld [wVariableA+1], a
    ENDC

    ; Load Variable B
    IF DEF(\4)
        ld a, [\4]
        ld [wVariableB], a
    ENDC
    IF DEF(\5)
        ld a, [\5]
        ld [wVariableB+1], a
    ENDC

    ; Load Variable C
    IF DEF(\6)
        ld a, [\6]
        ld [wVariableC], a
    ENDC
    IF DEF(\7)
        ld a, [\7]
        ld [wVariableC+1], a
    ENDC

    ; Load Variable D
    IF DEF(\8)
        ld a, [\8]
        ld [wVariableD], a
    ENDC
    IF DEF(\9)
        ld a, [\9]
        ld [wVariableD+1], a
    ENDC

    ; Zero the variable parts that are unused
    IF !(DEF(\2) && DEF(\3) && DEF(\4) && DEF(\5) && DEF(\6) && DEF(\7) && DEF(\8) && DEF(\9))
        ld a, 0
    ENDC
    IF !DEF(\2)
        ld [wVariableA], a
    ENDC
    IF !DEF(\3)
        ld [wVariableA+1], a
    ENDC
    IF !DEF(\4)
        ld [wVariableB], a
    ENDC
    IF !DEF(\5)
        ld [wVariableB+1], a
    ENDC
    IF !DEF(\6)
        ld [wVariableC], a
    ENDC
    IF !DEF(\7)
        ld [wVariableC+1], a
    ENDC
    IF !DEF(\8)
        ld [wVariableD], a
    ENDC
    IF !DEF(\9)
        ld [wVariableD+1], a
    ENDC
ENDM

RegulationTriggerExecute: MACRO
    ld a, [\1]
    dec a                                           ; Decrement the program counter value by 1 as all triggers treat 0 as void
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the current program counter to be where this trigger points in the custom logic instructions
    farcall CustomLogicInterpreter
ENDM

RegulationTriggerEnd: MACRO

    ; Save Variable A
    IF DEF(\2)
        ld a, [wVariableA]
        ld [\2], a
    ENDC
    IF DEF(\3)
        ld a, [wVariableA+1]
        ld [\3], a
    ENDC

    ; Save Variable B
    IF DEF(\4)
        ld a, [wVariableB]
        ld [\4], a
    ENDC
    IF DEF(\5)
        ld a, [wVariableB+1]
        ld [\5], a
    ENDC

    ; Save Variable C
    IF DEF(\6)
        ld a, [wVariableC]
        ld [\6], a
    ENDC
    IF DEF(\7)
        ld a, [wVariableC+1]
        ld [\7], a
    ENDC

    ; Save Variable D
    IF DEF(\8)
        ld a, [wVariableD]
        ld [\8], a
    ENDC
    IF DEF(\9)
        ld a, [wVariableD+1]
        ld [\9], a
    ENDC

    pop hl
    pop de
    pop bc
:

ENDM
