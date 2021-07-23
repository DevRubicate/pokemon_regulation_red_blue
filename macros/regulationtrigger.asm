
RegulationTrigger: MACRO
    ld a, [\1]
    or a
    jr z, .noTrigger\@

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
    IF DEF(\2)
        ld [wVariableA], a
    ENDC
    IF DEF(\3)
        ld [wVariableA+1], a
    ENDC
    IF DEF(\4)
        ld [wVariableB], a
    ENDC
    IF DEF(\5)
        ld [wVariableB+1], a
    ENDC
    IF DEF(\6)
        ld [wVariableC], a
    ENDC
    IF DEF(\7)
        ld [wVariableC+1], a
    ENDC
    IF DEF(\8)
        ld [wVariableD], a
    ENDC
    IF DEF(\9)
        ld [wVariableD+1], a
    ENDC

    push bc
    push de
    push hl
    ld [WRegulationCustomLogicProgramCounter], a ; Load the current program counter
    farcall CustomLogicInterpreter
    pop hl
    pop de
    pop bc

    ; Save Variable A
    IF DEF(\2)
        ld [wVariableA], a
        ld a, [\2]
    ENDC
    IF DEF(\3)
        ld [wVariableA+1], a
        ld a, [\3]
    ENDC

    ; Save Variable B
    IF DEF(\4)
        ld [wVariableB], a
        ld a, [\4]
    ENDC
    IF DEF(\5)
        ld [wVariableB+1], a
        ld a, [\5]
    ENDC

    ; Save Variable C
    IF DEF(\6)
        ld [wVariableC], a
        ld a, [\6]
    ENDC
    IF DEF(\7)
        ld [wVariableC+1], a
        ld a, [\7]
    ENDC

    ; Save Variable D
    IF DEF(\8)
        ld [wVariableD], a
        ld a, [\8]
    ENDC
    IF DEF(\9)
        ld [wVariableD+1], a
        ld a, [\9]
    ENDC


.noTrigger\@
ENDM
