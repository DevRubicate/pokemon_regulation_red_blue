
CustomLogicInterpreter:
InstructionEnd:
    ld a, 0
    ld b, a                                     ; Make sure b is 0
    ld a, [WRegulationCustomCodeProgramCounter] ; Load the current program counter
    ld c, a                                     ; Set program counter in c
    inc a                                       ; Increment by 1
    ld [WRegulationCustomCodeProgramCounter], a ; Save the incremented program counter
    ld hl, wRegulationCustomLogic-1             ; Load the start of the custom logic instructions, minus 1 to account for 0 being "no trigger"
    add hl, bc                                  ; Add the current program counter offset
    ld a, [hli]                                 ; Load the custom code instruction index
    or a
    ret z                                       ; exit if the custom code is $00
    ld c, a                                     ; Set custom code instruction index in c

    ld a, [hli]                                 ; Load the next value after the instruction (precaching)
    ld d, a
    ld a, [hl]                                  ; Load the next next value after the instruction (precaching)
    ld e, a

    ld hl, InstructionPointerTable              ; Load the start of the instruction pointer table
    add hl, bc                                  ; Add the custom code instruction index saved in c
    add hl, bc                                  ; Do it twice because pointers are 2 bytes wide
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl                                       ; Jump to custom code instruction


InstructionPointerTable:
    dw Instruction_NOP                  ; 0x00
    dw Instruction_SET_A_8VALUE         ; 0x01
    dw Instruction_SET_B_8VALUE         ; 0x02
    dw Instruction_SET_C_8VALUE         ; 0x03
    dw Instruction_SET_D_8VALUE         ; 0x04
    dw Instruction_SET_A_16VALUE        ; 0x05
    dw Instruction_SET_B_16VALUE        ; 0x06
    dw Instruction_SET_C_16VALUE        ; 0x07
    dw Instruction_SET_D_16VALUE        ; 0x08
    dw Instruction_SET_A_B              ; 0x09
    dw Instruction_SET_A_C              ; 0x0A
    dw Instruction_SET_A_D              ; 0x0B
    dw Instruction_SET_B_A              ; 0x0C
    dw Instruction_SET_B_C              ; 0x0D
    dw Instruction_SET_B_D              ; 0x0E
    dw Instruction_SET_C_A              ; 0x0F
    dw Instruction_SET_C_B              ; 0x10
    dw Instruction_SET_C_D              ; 0x11
    dw Instruction_SET_D_A              ; 0x12
    dw Instruction_SET_D_B              ; 0x13
    dw Instruction_SET_D_C              ; 0x14
    dw Instruction_SET_A_RANDOM         ; 0x15
    dw Instruction_SET_B_RANDOM         ; 0x16
    dw Instruction_SET_C_RANDOM         ; 0x17
    dw Instruction_SET_D_RANDOM         ; 0x18
    dw Instruction_LOAD8_16VALUE        ; 0x19
    dw Instruction_LOAD16_16VALUE       ; 0x1A
    dw Instruction_LOAD8_C_D            ; 0x1B
    dw Instruction_LOAD16_C_D           ; 0x1C
    dw Instruction_SAVE8_16VALUE        ; 0x1D
    dw Instruction_SAVE16_16VALUE       ; 0x1E
    dw Instruction_SAVE8_C_D            ; 0x1F
    dw Instruction_SAVE16_C_D           ; 0x20
    dw Instruction_AND_A_8VALUE         ;
    dw Instruction_AND_A_16VALUE        ;
    dw Instruction_AND_A_B              ;
    dw Instruction_AND_A_C              ;
    dw Instruction_AND_A_D              ;
    dw Instruction_OR_A_8VALUE          ;
    dw Instruction_OR_A_16VALUE         ;
    dw Instruction_OR_A_B               ;
    dw Instruction_OR_A_C               ;
    dw Instruction_OR_A_D               ;
    dw Instruction_XOR_A_8VALUE         ;
    dw Instruction_XOR_A_16VALUE        ;
    dw Instruction_XOR_A_B              ;
    dw Instruction_XOR_A_C              ;
    dw Instruction_XOR_A_D              ;
    dw Instruction_RSHIFT_A_8VALUE      ;
    dw Instruction_RSHIFT_A_16VALUE     ;
    dw Instruction_RSHIFT_A_B           ;
    dw Instruction_RSHIFT_A_C           ;
    dw Instruction_RSHIFT_A_D           ;
    dw Instruction_LSHIFT_A_8VALUE      ;
    dw Instruction_LSHIFT_A_16VALUE     ;
    dw Instruction_LSHIFT_A_B           ;
    dw Instruction_LSHIFT_A_C           ;
    dw Instruction_LSHIFT_A_D           ;
    dw Instruction_ADD_A_8VALUE         ;
    dw Instruction_ADD_A_16VALUE        ;
    dw Instruction_ADD_A_B              ;
    dw Instruction_ADD_A_C              ;
    dw Instruction_ADD_A_D              ;
    dw Instruction_ADD_B_8VALUE         ;
    dw Instruction_ADD_B_16VALUE        ;
    dw Instruction_ADD_B_A              ;
    dw Instruction_ADD_B_C              ;
    dw Instruction_ADD_B_D              ;
    dw Instruction_ADD_C_8VALUE         ;
    dw Instruction_ADD_C_16VALUE        ;
    dw Instruction_ADD_C_A              ;
    dw Instruction_ADD_C_B              ;
    dw Instruction_ADD_C_D              ;
    dw Instruction_ADD_D_8VALUE         ;
    dw Instruction_ADD_D_16VALUE        ;
    dw Instruction_ADD_D_A              ;
    dw Instruction_ADD_D_B              ;
    dw Instruction_ADD_D_C              ;
    dw Instruction_SUB_A_8VALUE         ;
    dw Instruction_SUB_A_16VALUE        ;
    dw Instruction_SUB_A_B              ;
    dw Instruction_SUB_A_C              ;
    dw Instruction_SUB_A_D              ;
    dw Instruction_SUB_B_8VALUE         ;
    dw Instruction_SUB_B_16VALUE        ;
    dw Instruction_SUB_B_A              ;
    dw Instruction_SUB_B_C              ;
    dw Instruction_SUB_B_D              ;
    dw Instruction_SUB_C_8VALUE         ;
    dw Instruction_SUB_C_16VALUE        ;
    dw Instruction_SUB_C_A              ;
    dw Instruction_SUB_C_B              ;
    dw Instruction_SUB_C_D              ;
    dw Instruction_SUB_D_8VALUE         ;
    dw Instruction_SUB_D_16VALUE        ;
    dw Instruction_SUB_D_A              ;
    dw Instruction_SUB_D_B              ;
    dw Instruction_SUB_D_C              ;
    dw Instruction_MULTI_A_8VALUE       ;
    dw Instruction_MULTI_A_16VALUE      ;
    dw Instruction_MULTI_A_B            ;
    dw Instruction_MULTI_A_C            ;
    dw Instruction_MULTI_A_D            ;
    dw Instruction_DIV_A_8VALUE         ;
    dw Instruction_DIV_A_16VALUE        ;
    dw Instruction_DIV_A_B              ;
    dw Instruction_DIV_A_C              ;
    dw Instruction_DIV_A_D              ;
    dw Instruction_GOTO_8VALUE          ;
    dw Instruction_GOTO_A               ;
    dw Instruction_GOTO_B               ;
    dw Instruction_GOTO_C               ;
    dw Instruction_GOTO_D               ;
    dw Instruction_IF_A_EQUAL_8VALUE    ;
    dw Instruction_IF_A_EQUAL_16VALUE   ;
    dw Instruction_IF_A_EQUAL_B         ;
    dw Instruction_IF_A_EQUAL_C         ;
    dw Instruction_IF_A_EQUAL_D         ;
    dw Instruction_IF_B_EQUAL_8VALUE    ;
    dw Instruction_IF_B_EQUAL_16VALUE   ;
    dw Instruction_IF_B_EQUAL_A         ;
    dw Instruction_IF_B_EQUAL_C         ;
    dw Instruction_IF_B_EQUAL_D         ;
    dw Instruction_IF_C_EQUAL_8VALUE    ;
    dw Instruction_IF_C_EQUAL_16VALUE   ;
    dw Instruction_IF_C_EQUAL_B         ;
    dw Instruction_IF_C_EQUAL_C         ;
    dw Instruction_IF_C_EQUAL_D         ;
    dw Instruction_IF_D_EQUAL_8VALUE    ;
    dw Instruction_IF_D_EQUAL_16VALUE   ;
    dw Instruction_IF_D_EQUAL_A         ;
    dw Instruction_IF_D_EQUAL_B         ;
    dw Instruction_IF_D_EQUAL_C         ;
    dw Instruction_IF_A_NOTEQUAL_8VALUE ;
    dw Instruction_IF_A_NOTEQUAL_16VALUE;
    dw Instruction_IF_A_NOTEQUAL_B      ;
    dw Instruction_IF_A_NOTEQUAL_C      ;
    dw Instruction_IF_A_NOTEQUAL_D      ;
    dw Instruction_IF_B_NOTEQUAL_8VALUE ;
    dw Instruction_IF_B_NOTEQUAL_16VALUE;
    dw Instruction_IF_B_NOTEQUAL_A      ;
    dw Instruction_IF_B_NOTEQUAL_C      ;
    dw Instruction_IF_B_NOTEQUAL_D      ;
    dw Instruction_IF_C_NOTEQUAL_8VALUE ;
    dw Instruction_IF_C_NOTEQUAL_16VALUE;
    dw Instruction_IF_C_NOTEQUAL_B      ;
    dw Instruction_IF_C_NOTEQUAL_C      ;
    dw Instruction_IF_C_NOTEQUAL_D      ;
    dw Instruction_IF_D_NOTEQUAL_8VALUE ;
    dw Instruction_IF_D_NOTEQUAL_16VALUE;
    dw Instruction_IF_D_NOTEQUAL_A      ;
    dw Instruction_IF_D_NOTEQUAL_B      ;
    dw Instruction_IF_D_NOTEQUAL_C      ;
    dw Instruction_IF_A_GREATER_8VALUE  ;
    dw Instruction_IF_A_GREATER_16VALUE ;
    dw Instruction_IF_A_GREATER_B       ;
    dw Instruction_IF_A_GREATER_C       ;
    dw Instruction_IF_A_GREATER_D       ;
    dw Instruction_IF_B_GREATER_8VALUE  ;
    dw Instruction_IF_B_GREATER_16VALUE ;
    dw Instruction_IF_B_GREATER_A       ;
    dw Instruction_IF_B_GREATER_C       ;
    dw Instruction_IF_B_GREATER_D       ;
    dw Instruction_IF_C_GREATER_8VALUE  ;
    dw Instruction_IF_C_GREATER_16VALUE ;
    dw Instruction_IF_C_GREATER_B       ;
    dw Instruction_IF_C_GREATER_C       ;
    dw Instruction_IF_C_GREATER_D       ;
    dw Instruction_IF_D_GREATER_8VALUE  ;
    dw Instruction_IF_D_GREATER_16VALUE ;
    dw Instruction_IF_D_GREATER_A       ;
    dw Instruction_IF_D_GREATER_B       ;
    dw Instruction_IF_D_GREATER_C       ;
    dw Instruction_IF_A_LESSER_8VALUE   ;
    dw Instruction_IF_A_LESSER_16VALUE  ;
    dw Instruction_IF_A_LESSER_B        ;
    dw Instruction_IF_A_LESSER_C        ;
    dw Instruction_IF_A_LESSER_D        ;
    dw Instruction_IF_B_LESSER_8VALUE   ;
    dw Instruction_IF_B_LESSER_16VALUE  ;
    dw Instruction_IF_B_LESSER_a        ;
    dw Instruction_IF_B_LESSER_C        ;
    dw Instruction_IF_B_LESSER_D        ;
    dw Instruction_IF_C_LESSER_8VALUE   ;
    dw Instruction_IF_C_LESSER_16VALUE  ;
    dw Instruction_IF_C_LESSER_B        ;
    dw Instruction_IF_C_LESSER_C        ;
    dw Instruction_IF_C_LESSER_D        ;
    dw Instruction_IF_D_LESSER_8VALUE   ;
    dw Instruction_IF_D_LESSER_16VALUE  ;
    dw Instruction_IF_D_LESSER_A        ;
    dw Instruction_IF_D_LESSER_B        ;
    dw Instruction_IF_D_LESSER_C        ;



Instruction_NOP:
    jp InstructionEnd

Instruction_SET_A_8VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 1
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, 0
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableA], a
    ; done
    jp InstructionEnd

Instruction_SET_B_8VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 1
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, 0
    ld [wRegulationCustomCodeVariableB+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableB], a
    ; done
    jp InstructionEnd

Instruction_SET_C_8VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 1
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, 0
    ld [wRegulationCustomCodeVariableC+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableC], a
    ; done
    jp InstructionEnd

Instruction_SET_D_8VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 1
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, 0
    ld [wRegulationCustomCodeVariableD+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableD], a
    ; done
    jp InstructionEnd

Instruction_SET_A_16VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 2
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, d
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableA], a
    ; done
    jp InstructionEnd

Instruction_SET_B_16VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 2
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, d
    ld [wRegulationCustomCodeVariableB+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableB], a
    ; done
    jp InstructionEnd

Instruction_SET_C_16VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 2
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, d
    ld [wRegulationCustomCodeVariableC+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableC], a
    ; done
    jp InstructionEnd

Instruction_SET_D_16VALUE:
     ; Increment program counter by 2
    ld a, [WRegulationCustomCodeProgramCounter]
    add 2
    ld [WRegulationCustomCodeProgramCounter], a
    ; Save the static value into variable A
    ld a, d
    ld [wRegulationCustomCodeVariableD+1], a
    ld a, e
    ld [wRegulationCustomCodeVariableD], a
    ; done
    jp InstructionEnd

Instruction_SET_A_B:
    ; Override A with B
    ld a, [wRegulationCustomCodeVariableB+1]
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [wRegulationCustomCodeVariableB]
    ld [wRegulationCustomCodeVariableA], a
    ; done
    jp InstructionEnd

Instruction_SET_A_C:
    ; Override A with C
    ld a, [wRegulationCustomCodeVariableC+1]
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [wRegulationCustomCodeVariableC]
    ld [wRegulationCustomCodeVariableA], a
    ; done
    jp InstructionEnd

Instruction_SET_A_D:
    ; Override A with D
    ld a, [wRegulationCustomCodeVariableD+1]
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [wRegulationCustomCodeVariableD]
    ld [wRegulationCustomCodeVariableA], a
    ; done
    jp InstructionEnd

Instruction_SET_B_A:
    ; Override B with A
    ld a, [wRegulationCustomCodeVariableA+1]
    ld [wRegulationCustomCodeVariableB+1], a
    ld a, [wRegulationCustomCodeVariableA]
    ld [wRegulationCustomCodeVariableB], a
    ; done
    jp InstructionEnd

Instruction_SET_B_C:
    ; Override B with C
    ld a, [wRegulationCustomCodeVariableC+1]
    ld [wRegulationCustomCodeVariableB+1], a
    ld a, [wRegulationCustomCodeVariableC]
    ld [wRegulationCustomCodeVariableB], a
    ; done
    jp InstructionEnd

Instruction_SET_B_D:
    ; Override B with D
    ld a, [wRegulationCustomCodeVariableD+1]
    ld [wRegulationCustomCodeVariableB+1], a
    ld a, [wRegulationCustomCodeVariableD]
    ld [wRegulationCustomCodeVariableB], a
    ; done
    jp InstructionEnd

Instruction_SET_C_A:
    ; Override C with A
    ld a, [wRegulationCustomCodeVariableA+1]
    ld [wRegulationCustomCodeVariableC+1], a
    ld a, [wRegulationCustomCodeVariableA]
    ld [wRegulationCustomCodeVariableC], a
    ; done
    jp InstructionEnd

Instruction_SET_C_B:
    ; Override C with B
    ld a, [wRegulationCustomCodeVariableB+1]
    ld [wRegulationCustomCodeVariableC+1], a
    ld a, [wRegulationCustomCodeVariableB]
    ld [wRegulationCustomCodeVariableC], a
    ; done
    jp InstructionEnd

Instruction_SET_C_D:
    ; Override C with D
    ld a, [wRegulationCustomCodeVariableD+1]
    ld [wRegulationCustomCodeVariableC+1], a
    ld a, [wRegulationCustomCodeVariableD]
    ld [wRegulationCustomCodeVariableC], a
    ; done
    jp InstructionEnd

Instruction_SET_D_A:
    ; Override D with A
    ld a, [wRegulationCustomCodeVariableA+1]
    ld [wRegulationCustomCodeVariableD+1], a
    ld a, [wRegulationCustomCodeVariableA]
    ld [wRegulationCustomCodeVariableD], a
    ; done
    jp InstructionEnd

Instruction_SET_D_B:
    ; Override D with B
    ld a, [wRegulationCustomCodeVariableB+1]
    ld [wRegulationCustomCodeVariableD+1], a
    ld a, [wRegulationCustomCodeVariableB]
    ld [wRegulationCustomCodeVariableD], a
    ; done
    jp InstructionEnd

Instruction_SET_D_C:
    ; Override D with C
    ld a, [wRegulationCustomCodeVariableC+1]
    ld [wRegulationCustomCodeVariableD+1], a
    ld a, [wRegulationCustomCodeVariableC]
    ld [wRegulationCustomCodeVariableD], a
    ; done
    jp InstructionEnd

Instruction_SET_A_RANDOM:
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableA+1], a
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableA], a
    jp InstructionEnd

Instruction_SET_B_RANDOM:
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableB+1], a
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableB], a
    jp InstructionEnd

Instruction_SET_C_RANDOM:
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableC+1], a
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableC], a
    jp InstructionEnd

Instruction_SET_D_RANDOM:
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableD+1], a
    call RegulationRandomNumber
    ld [wRegulationCustomCodeVariableD], a
    jp InstructionEnd

Instruction_LOAD8_16VALUE:
    ld h, d
    ld l, e
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [hl]
    ld [wRegulationCustomCodeVariableA], a
    jp InstructionEnd

Instruction_LOAD16_16VALUE:
    ld h, d
    ld l, e
    ld a, [hli]
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [hl]
    ld [wRegulationCustomCodeVariableA], a
    jp InstructionEnd

Instruction_LOAD8_C_D:
    ld a, [wRegulationCustomCodeVariableC]
    ld h, a
    ld a, [wRegulationCustomCodeVariableD]
    ld l, a
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [hl]
    ld [wRegulationCustomCodeVariableA], a
    jp InstructionEnd

Instruction_LOAD16_C_D:
    ld a, [wRegulationCustomCodeVariableC]
    ld h, a
    ld a, [wRegulationCustomCodeVariableD]
    ld l, a
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomCodeVariableA+1], a
    ld a, [hl]
    ld [wRegulationCustomCodeVariableA], a
    jp InstructionEnd

Instruction_SAVE8_16VALUE:
    ld h, d
    ld l, e
    ld [wRegulationCustomCodeVariableA], a
    ld [hl], a
    jp InstructionEnd

Instruction_SAVE16_16VALUE:
    ld h, d
    ld l, e
    ld [wRegulationCustomCodeVariableA], a
    ld [hli], a
    ld [wRegulationCustomCodeVariableA+1], a
    ld [hl], a
    jp InstructionEnd

Instruction_SAVE8_C_D:
    ; done
    jp InstructionEnd

Instruction_SAVE16_C_D:
    ; done
    jp InstructionEnd

Instruction_AND_A_8VALUE:

    jp InstructionEnd

Instruction_AND_A_16VALUE:

    jp InstructionEnd

Instruction_AND_A_B:

    jp InstructionEnd

Instruction_AND_A_C:

    jp InstructionEnd

Instruction_AND_A_D:

    jp InstructionEnd

Instruction_OR_A_8VALUE:

    jp InstructionEnd

Instruction_OR_A_16VALUE:

    jp InstructionEnd

Instruction_OR_A_B:

    jp InstructionEnd

Instruction_OR_A_C:

    jp InstructionEnd

Instruction_OR_A_D:

    jp InstructionEnd

Instruction_XOR_A_8VALUE:

    jp InstructionEnd

Instruction_XOR_A_16VALUE:

    jp InstructionEnd

Instruction_XOR_A_B:

    jp InstructionEnd

Instruction_XOR_A_C:

    jp InstructionEnd

Instruction_XOR_A_D:

    jp InstructionEnd

Instruction_RSHIFT_A_8VALUE:

    jp InstructionEnd

Instruction_RSHIFT_A_16VALUE:

    jp InstructionEnd

Instruction_RSHIFT_A_B:

    jp InstructionEnd

Instruction_RSHIFT_A_C:

    jp InstructionEnd

Instruction_RSHIFT_A_D:

    jp InstructionEnd

Instruction_LSHIFT_A_8VALUE:

    jp InstructionEnd

Instruction_LSHIFT_A_16VALUE:

    jp InstructionEnd

Instruction_LSHIFT_A_B:

    jp InstructionEnd

Instruction_LSHIFT_A_C:

    jp InstructionEnd

Instruction_LSHIFT_A_D:

    jp InstructionEnd

Instruction_ADD_A_8VALUE:

    jp InstructionEnd

Instruction_ADD_A_16VALUE:

    jp InstructionEnd

Instruction_ADD_A_B:

    jp InstructionEnd

Instruction_ADD_A_C:

    jp InstructionEnd

Instruction_ADD_A_D:

    jp InstructionEnd

Instruction_ADD_B_8VALUE:

    jp InstructionEnd

Instruction_ADD_B_16VALUE:

    jp InstructionEnd

Instruction_ADD_B_A:

    jp InstructionEnd

Instruction_ADD_B_C:

    jp InstructionEnd

Instruction_ADD_B_D:

    jp InstructionEnd

Instruction_ADD_C_8VALUE:

    jp InstructionEnd

Instruction_ADD_C_16VALUE:

    jp InstructionEnd

Instruction_ADD_C_A:

    jp InstructionEnd

Instruction_ADD_C_B:

    jp InstructionEnd

Instruction_ADD_C_D:

    jp InstructionEnd

Instruction_ADD_D_8VALUE:

    jp InstructionEnd

Instruction_ADD_D_16VALUE:

    jp InstructionEnd

Instruction_ADD_D_A:

    jp InstructionEnd

Instruction_ADD_D_B:

    jp InstructionEnd

Instruction_ADD_D_C:

    jp InstructionEnd

Instruction_SUB_A_8VALUE:

    jp InstructionEnd

Instruction_SUB_A_16VALUE:

    jp InstructionEnd

Instruction_SUB_A_B:

    jp InstructionEnd

Instruction_SUB_A_C:

    jp InstructionEnd

Instruction_SUB_A_D:

    jp InstructionEnd

Instruction_SUB_B_8VALUE:

    jp InstructionEnd

Instruction_SUB_B_16VALUE:

    jp InstructionEnd

Instruction_SUB_B_A:

    jp InstructionEnd

Instruction_SUB_B_C:

    jp InstructionEnd

Instruction_SUB_B_D:

    jp InstructionEnd

Instruction_SUB_C_8VALUE:

    jp InstructionEnd

Instruction_SUB_C_16VALUE:

    jp InstructionEnd

Instruction_SUB_C_A:

    jp InstructionEnd

Instruction_SUB_C_B:

    jp InstructionEnd

Instruction_SUB_C_D:

    jp InstructionEnd

Instruction_SUB_D_8VALUE:

    jp InstructionEnd

Instruction_SUB_D_16VALUE:

    jp InstructionEnd

Instruction_SUB_D_A:

    jp InstructionEnd

Instruction_SUB_D_B:

    jp InstructionEnd

Instruction_SUB_D_C:

    jp InstructionEnd

Instruction_MULTI_A_8VALUE:

    jp InstructionEnd

Instruction_MULTI_A_16VALUE:

    jp InstructionEnd

Instruction_MULTI_A_B:

    jp InstructionEnd

Instruction_MULTI_A_C:

    jp InstructionEnd

Instruction_MULTI_A_D:

    jp InstructionEnd

Instruction_DIV_A_8VALUE:

    jp InstructionEnd

Instruction_DIV_A_16VALUE:

    jp InstructionEnd

Instruction_DIV_A_B:

    jp InstructionEnd

Instruction_DIV_A_C:

    jp InstructionEnd

Instruction_DIV_A_D:

    jp InstructionEnd

Instruction_GOTO_8VALUE:

    jp InstructionEnd

Instruction_GOTO_A:

    jp InstructionEnd

Instruction_GOTO_B:

    jp InstructionEnd

Instruction_GOTO_C:

    jp InstructionEnd

Instruction_GOTO_D:

    jp InstructionEnd

Instruction_IF_A_EQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_A_EQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_A_EQUAL_B:

    jp InstructionEnd

Instruction_IF_A_EQUAL_C:

    jp InstructionEnd

Instruction_IF_A_EQUAL_D:

    jp InstructionEnd

Instruction_IF_B_EQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_B_EQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_B_EQUAL_A:

    jp InstructionEnd

Instruction_IF_B_EQUAL_C:

    jp InstructionEnd

Instruction_IF_B_EQUAL_D:

    jp InstructionEnd

Instruction_IF_C_EQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_C_EQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_C_EQUAL_B:

    jp InstructionEnd

Instruction_IF_C_EQUAL_C:

    jp InstructionEnd

Instruction_IF_C_EQUAL_D:

    jp InstructionEnd

Instruction_IF_D_EQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_D_EQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_D_EQUAL_A:

    jp InstructionEnd

Instruction_IF_D_EQUAL_B:

    jp InstructionEnd

Instruction_IF_D_EQUAL_C:

    jp InstructionEnd

Instruction_IF_A_NOTEQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_A_NOTEQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_A_NOTEQUAL_B:

    jp InstructionEnd

Instruction_IF_A_NOTEQUAL_C:

    jp InstructionEnd

Instruction_IF_A_NOTEQUAL_D:

    jp InstructionEnd

Instruction_IF_B_NOTEQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_B_NOTEQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_B_NOTEQUAL_A:

    jp InstructionEnd

Instruction_IF_B_NOTEQUAL_C:

    jp InstructionEnd

Instruction_IF_B_NOTEQUAL_D:

    jp InstructionEnd

Instruction_IF_C_NOTEQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_C_NOTEQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_C_NOTEQUAL_B:

    jp InstructionEnd

Instruction_IF_C_NOTEQUAL_C:

    jp InstructionEnd

Instruction_IF_C_NOTEQUAL_D:

    jp InstructionEnd

Instruction_IF_D_NOTEQUAL_8VALUE:

    jp InstructionEnd

Instruction_IF_D_NOTEQUAL_16VALUE:

    jp InstructionEnd

Instruction_IF_D_NOTEQUAL_A:

    jp InstructionEnd

Instruction_IF_D_NOTEQUAL_B:

    jp InstructionEnd

Instruction_IF_D_NOTEQUAL_C:

    jp InstructionEnd

Instruction_IF_A_GREATER_8VALUE:

    jp InstructionEnd

Instruction_IF_A_GREATER_16VALUE:

    jp InstructionEnd

Instruction_IF_A_GREATER_B:

    jp InstructionEnd

Instruction_IF_A_GREATER_C:

    jp InstructionEnd

Instruction_IF_A_GREATER_D:

    jp InstructionEnd

Instruction_IF_B_GREATER_8VALUE:

    jp InstructionEnd

Instruction_IF_B_GREATER_16VALUE:

    jp InstructionEnd

Instruction_IF_B_GREATER_A:

    jp InstructionEnd

Instruction_IF_B_GREATER_C:

    jp InstructionEnd

Instruction_IF_B_GREATER_D:

    jp InstructionEnd

Instruction_IF_C_GREATER_8VALUE:

    jp InstructionEnd

Instruction_IF_C_GREATER_16VALUE:

    jp InstructionEnd

Instruction_IF_C_GREATER_B:

    jp InstructionEnd

Instruction_IF_C_GREATER_C:

    jp InstructionEnd

Instruction_IF_C_GREATER_D:

    jp InstructionEnd

Instruction_IF_D_GREATER_8VALUE:

    jp InstructionEnd

Instruction_IF_D_GREATER_16VALUE:

    jp InstructionEnd

Instruction_IF_D_GREATER_A:

    jp InstructionEnd

Instruction_IF_D_GREATER_B:

    jp InstructionEnd

Instruction_IF_D_GREATER_C:

    jp InstructionEnd

Instruction_IF_A_LESSER_8VALUE:

    jp InstructionEnd

Instruction_IF_A_LESSER_16VALUE:

    jp InstructionEnd

Instruction_IF_A_LESSER_B:

    jp InstructionEnd

Instruction_IF_A_LESSER_C:

    jp InstructionEnd

Instruction_IF_A_LESSER_D:

    jp InstructionEnd

Instruction_IF_B_LESSER_8VALUE:

    jp InstructionEnd

Instruction_IF_B_LESSER_16VALUE:

    jp InstructionEnd

Instruction_IF_B_LESSER_a:

    jp InstructionEnd

Instruction_IF_B_LESSER_C:

    jp InstructionEnd

Instruction_IF_B_LESSER_D:

    jp InstructionEnd

Instruction_IF_C_LESSER_8VALUE:

    jp InstructionEnd

Instruction_IF_C_LESSER_16VALUE:

    jp InstructionEnd

Instruction_IF_C_LESSER_B:

    jp InstructionEnd

Instruction_IF_C_LESSER_C:

    jp InstructionEnd

Instruction_IF_C_LESSER_D:

    jp InstructionEnd

Instruction_IF_D_LESSER_8VALUE:

    jp InstructionEnd

Instruction_IF_D_LESSER_16VALUE:

    jp InstructionEnd

Instruction_IF_D_LESSER_A:

    jp InstructionEnd

Instruction_IF_D_LESSER_B:

    jp InstructionEnd

Instruction_IF_D_LESSER_C:

    jp InstructionEnd
