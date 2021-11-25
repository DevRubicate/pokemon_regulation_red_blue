
CustomLogicInterpreter:

    ld a, [wVariableA]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableA+1]
    ld [wRegulationCustomLogicVariableA+1], a

    ld a, [wVariableB]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wVariableB+1]
    ld [wRegulationCustomLogicVariableB+1], a

    ld a, [wVariableC]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wVariableC+1]
    ld [wRegulationCustomLogicVariableC+1], a

    ld a, [wVariableD]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wVariableD+1]
    ld [wRegulationCustomLogicVariableD+1], a

InstructionEnd:
    ld a, 0
    ld b, a                                     ; Make sure b is 0
    ld a, [WRegulationCustomLogicProgramCounter]; Load the current program counter
    ld c, a                                     ; Set program counter in c
    ld hl, wRegulationCustomLogic-1             ; Load the start of the custom logic instructions, minus 1 to account for 0 being "no trigger"
    add hl, bc                                  ; Add the current program counter offset
    ld a, [hli]                                 ; Load the custom code instruction index
    or a
    ret z                                       ; exit if the custom code is $00
    ld c, a                                     ; Set custom code instruction in c

    cp ((InstructionPointerTable_TwoByte - InstructionPointerTable) / 2)
    jr c, .oneByteInstruction
    cp ((InstructionPointerTable_ThreeByte - InstructionPointerTable) / 2)
    jr c, .twoByteInstruction

.threeByteInstruction
    ld a, [hli]                                 ; Load the next value after the instruction (precaching)
    ld d, a
    ld a, [hl]                                  ; Load the next value after the instruction (precaching)
    ld e, a
    ld a, [WRegulationCustomLogicProgramCounter]
    add 3
    ld [WRegulationCustomLogicProgramCounter], a
    jr .continue

.twoByteInstruction
    ld a, 0
    ld d, a
    ld a, [hl]                                  ; Load the next next value after the instruction (precaching)
    ld e, a
    ld a, [WRegulationCustomLogicProgramCounter]
    add 2
    ld [WRegulationCustomLogicProgramCounter], a
    jr .continue

.oneByteInstruction
    ld a, [WRegulationCustomLogicProgramCounter]
    add 1
    ld [WRegulationCustomLogicProgramCounter], a

.continue
    ld hl, InstructionPointerTable              ; Load the start of the instruction pointer table
    add hl, bc                                  ; Add the custom code instruction saved in c
    add hl, bc                                  ; Do it twice because pointers are 2 bytes wide
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl                                       ; Jump to custom code instruction


InstructionPointerTable:
    dw Instruction_RET                  ; 0x00, 1 byte
    dw Instruction_SET_A_B              ; 0x01, 1 byte
    dw Instruction_SET_A_C              ; 0x02, 1 byte
    dw Instruction_SET_A_D              ; 0x03, 1 byte
    dw Instruction_SET_B_A              ; 0x04, 1 byte
    dw Instruction_SET_B_C              ; 0x05, 1 byte
    dw Instruction_SET_B_D              ; 0x06, 1 byte
    dw Instruction_SET_C_A              ; 0x07, 1 byte
    dw Instruction_SET_C_B              ; 0x08, 1 byte
    dw Instruction_SET_C_D              ; 0x09, 1 byte
    dw Instruction_SET_D_A              ; 0x0A, 1 byte
    dw Instruction_SET_D_B              ; 0x0B, 1 byte
    dw Instruction_SET_D_C              ; 0x0C, 1 byte
    dw Instruction_SET_A_RANDOM         ; 0x0D, 1 byte
    dw Instruction_SET_B_RANDOM         ; 0x0E, 1 byte
    dw Instruction_SET_C_RANDOM         ; 0x0F, 1 byte
    dw Instruction_SET_D_RANDOM         ; 0x10, 1 byte
    dw Instruction_SET_RANDOM_A         ; 0x11, 1 byte
    dw Instruction_SET_RANDOM_B         ; 0x12, 1 byte
    dw Instruction_SET_RANDOM_C         ; 0x13, 1 byte
    dw Instruction_SET_RANDOM_D         ; 0x14, 1 byte
    dw Instruction_SET_RANDOM_RANDOM    ; 0x15, 1 byte
    dw Instruction_SET_ARGA_A           ; 0x16, 1 byte
    dw Instruction_SET_ARGB_B           ; 0x17, 1 byte
    dw Instruction_SET_ARGC_C           ; 0x18, 1 byte
    dw Instruction_SET_ARGD_D           ; 0x19, 1 byte
    dw Instruction_SET_A_ARGA           ; 0x1A, 1 byte
    dw Instruction_SET_B_ARGB           ; 0x1B, 1 byte
    dw Instruction_SET_C_ARGC           ; 0x1C, 1 byte
    dw Instruction_SET_D_ARGD           ; 0x1D, 1 byte
    dw Instruction_SET_ARGB_A           ; 0x1E, 1 byte
    dw Instruction_SET_ARGC_A           ; 0x1F, 1 byte
    dw Instruction_SET_ARGD_A           ; 0x20, 1 byte
    dw Instruction_SET_A_ARGB           ; 0x21, 1 byte
    dw Instruction_SET_A_ARGC           ; 0x22, 1 byte
    dw Instruction_SET_A_ARGD           ; 0x23, 1 byte
    dw Instruction_LOAD8_B              ; 0x24, 1 byte
    dw Instruction_LOAD16_B             ; 0x25, 1 byte
    dw Instruction_SAVE8_B              ; 0x26, 1 byte
    dw Instruction_SAVE16_B             ; 0x27, 1 byte
    dw Instruction_AND_B                ; 0x28, 1 byte
    dw Instruction_AND_C                ; 0x29, 1 byte
    dw Instruction_AND_D                ; 0x2A, 1 byte
    dw Instruction_OR_B                 ; 0x2B, 1 byte
    dw Instruction_OR_C                 ; 0x2C, 1 byte
    dw Instruction_OR_D                 ; 0x2D, 1 byte
    dw Instruction_XOR_B                ; 0x2E, 1 byte
    dw Instruction_XOR_C                ; 0x2F, 1 byte
    dw Instruction_XOR_D                ; 0x30, 1 byte
    dw Instruction_RSHIFT_B             ; 0x31, 1 byte
    dw Instruction_RSHIFT_C             ; 0x32, 1 byte
    dw Instruction_RSHIFT_D             ; 0x33, 1 byte
    dw Instruction_LSHIFT_B             ; 0x34, 1 byte
    dw Instruction_LSHIFT_C             ; 0x35, 1 byte
    dw Instruction_LSHIFT_D             ; 0x36, 1 byte
    dw Instruction_ADD_A_B              ; 0x37, 1 byte
    dw Instruction_ADD_A_C              ; 0x38, 1 byte
    dw Instruction_ADD_A_D              ; 0x39, 1 byte
    dw Instruction_ADD_B_A              ; 0x3A, 1 byte
    dw Instruction_ADD_B_C              ; 0x3B, 1 byte
    dw Instruction_ADD_B_D              ; 0x3C, 1 byte
    dw Instruction_ADD_C_A              ; 0x3D, 1 byte
    dw Instruction_ADD_C_B              ; 0x3E, 1 byte
    dw Instruction_ADD_C_D              ; 0x3F, 1 byte
    dw Instruction_ADD_D_A              ; 0x40, 1 byte
    dw Instruction_ADD_D_B              ; 0x41, 1 byte
    dw Instruction_ADD_D_C              ; 0x42, 1 byte
    dw Instruction_ADD_A_RANDOM         ; 0x43, 1 byte
    dw Instruction_ADD_B_RANDOM         ; 0x44, 1 byte
    dw Instruction_ADD_C_RANDOM         ; 0x45, 1 byte
    dw Instruction_ADD_D_RANDOM         ; 0x46, 1 byte
    dw Instruction_SUB_A_B              ; 0x47, 1 byte
    dw Instruction_SUB_A_C              ; 0x48, 1 byte
    dw Instruction_SUB_A_D              ; 0x49, 1 byte
    dw Instruction_SUB_B_A              ; 0x4A, 1 byte
    dw Instruction_SUB_B_C              ; 0x4B, 1 byte
    dw Instruction_SUB_B_D              ; 0x4C, 1 byte
    dw Instruction_SUB_C_A              ; 0x4D, 1 byte
    dw Instruction_SUB_C_B              ; 0x4E, 1 byte
    dw Instruction_SUB_C_D              ; 0x4F, 1 byte
    dw Instruction_SUB_D_A              ; 0x50, 1 byte
    dw Instruction_SUB_D_B              ; 0x51, 1 byte
    dw Instruction_SUB_D_C              ; 0x52, 1 byte
    dw Instruction_SUB_A_RANDOM         ; 0x53, 1 byte
    dw Instruction_SUB_B_RANDOM         ; 0x54, 1 byte
    dw Instruction_SUB_C_RANDOM         ; 0x55, 1 byte
    dw Instruction_SUB_D_RANDOM         ; 0x56, 1 byte
    dw Instruction_MUL_B                ; 0x57, 1 byte
    dw Instruction_MUL_C                ; 0x58, 1 byte
    dw Instruction_MUL_D                ; 0x59, 1 byte
    dw Instruction_DIV_B                ; 0x5A, 1 byte
    dw Instruction_DIV_C                ; 0x5B, 1 byte
    dw Instruction_DIV_D                ; 0x5C, 1 byte
    dw Instruction_MOD_B                ; 0x5D, 1 byte
    dw Instruction_MOD_C                ; 0x5E, 1 byte
    dw Instruction_MOD_D                ; 0x5F, 1 byte
    dw Instruction_GOTO_A               ; 0x60, 1 byte
    dw Instruction_GOTO_B               ; 0x61, 1 byte
    dw Instruction_GOTO_C               ; 0x62, 1 byte
    dw Instruction_GOTO_D               ; 0x63, 1 byte
    dw Instruction_IF_A_EQUAL_B         ; 0x64, 1 byte
    dw Instruction_IF_A_EQUAL_C         ; 0x65, 1 byte
    dw Instruction_IF_A_EQUAL_D         ; 0x66, 1 byte
    dw Instruction_IF_B_EQUAL_A         ; 0x67, 1 byte
    dw Instruction_IF_B_EQUAL_C         ; 0x68, 1 byte
    dw Instruction_IF_B_EQUAL_D         ; 0x69, 1 byte
    dw Instruction_IF_C_EQUAL_B         ; 0x6A, 1 byte
    dw Instruction_IF_C_EQUAL_C         ; 0x6B, 1 byte
    dw Instruction_IF_C_EQUAL_D         ; 0x6C, 1 byte
    dw Instruction_IF_D_EQUAL_A         ; 0x6D, 1 byte
    dw Instruction_IF_D_EQUAL_B         ; 0x6E, 1 byte
    dw Instruction_IF_D_EQUAL_C         ; 0x6F, 1 byte
    dw Instruction_IF_A_NOTEQUAL_B      ; 0x70, 1 byte
    dw Instruction_IF_A_NOTEQUAL_C      ; 0x71, 1 byte
    dw Instruction_IF_A_NOTEQUAL_D      ; 0x72, 1 byte
    dw Instruction_IF_B_NOTEQUAL_A      ; 0x73, 1 byte
    dw Instruction_IF_B_NOTEQUAL_C      ; 0x74, 1 byte
    dw Instruction_IF_B_NOTEQUAL_D      ; 0x75, 1 byte
    dw Instruction_IF_C_NOTEQUAL_B      ; 0x76, 1 byte
    dw Instruction_IF_C_NOTEQUAL_C      ; 0x77, 1 byte
    dw Instruction_IF_C_NOTEQUAL_D      ; 0x78, 1 byte
    dw Instruction_IF_D_NOTEQUAL_A      ; 0x79, 1 byte
    dw Instruction_IF_D_NOTEQUAL_B      ; 0x7A, 1 byte
    dw Instruction_IF_D_NOTEQUAL_C      ; 0x7B, 1 byte
    dw Instruction_IF_A_GREATER_B       ; 0x7C, 1 byte
    dw Instruction_IF_A_GREATER_C       ; 0x7D, 1 byte
    dw Instruction_IF_A_GREATER_D       ; 0x7E, 1 byte
    dw Instruction_IF_B_GREATER_A       ; 0x7F, 1 byte
    dw Instruction_IF_B_GREATER_C       ; 0x80, 1 byte
    dw Instruction_IF_B_GREATER_D       ; 0x81, 1 byte
    dw Instruction_IF_C_GREATER_B       ; 0x82, 1 byte
    dw Instruction_IF_C_GREATER_C       ; 0x83, 1 byte
    dw Instruction_IF_C_GREATER_D       ; 0x84, 1 byte
    dw Instruction_IF_D_GREATER_A       ; 0x85, 1 byte
    dw Instruction_IF_D_GREATER_B       ; 0x86, 1 byte
    dw Instruction_IF_D_GREATER_C       ; 0x87, 1 byte
    dw Instruction_IF_A_LESSER_B        ; 0x88, 1 byte
    dw Instruction_IF_A_LESSER_C        ; 0x89, 1 byte
    dw Instruction_IF_A_LESSER_D        ; 0x8A, 1 byte
    dw Instruction_IF_B_LESSER_a        ; 0x8B, 1 byte
    dw Instruction_IF_B_LESSER_C        ; 0x8C, 1 byte
    dw Instruction_IF_B_LESSER_D        ; 0x8D, 1 byte
    dw Instruction_IF_C_LESSER_B        ; 0x8E, 1 byte
    dw Instruction_IF_C_LESSER_C        ; 0x8F, 1 byte
    dw Instruction_IF_C_LESSER_D        ; 0x90, 1 byte
    dw Instruction_IF_D_LESSER_A        ; 0x91, 1 byte
    dw Instruction_IF_D_LESSER_B        ; 0x92, 1 byte
    dw Instruction_IF_D_LESSER_C        ; 0x93, 1 byte
InstructionPointerTable_TwoByte:        ;              ;
    dw Instruction_SET_A_8VALUE         ; 0x94, 2 byte
    dw Instruction_SET_B_8VALUE         ; 0x95, 2 byte
    dw Instruction_SET_C_8VALUE         ; 0x96, 2 byte
    dw Instruction_SET_D_8VALUE         ; 0x97, 2 byte
    dw Instruction_LOAD8_8VALUE         ; 0x98, 2 byte
    dw Instruction_LOAD16_8VALUE        ; 0x99, 2 byte
    dw Instruction_SAVE8_8VALUE         ; 0x9A, 2 byte
    dw Instruction_SAVE16_8VALUE        ; 0x9B, 2 byte
    dw Instruction_AND_8VALUE           ; 0x9C, 2 byte
    dw Instruction_OR_8VALUE            ; 0x9D, 2 byte
    dw Instruction_XOR_8VALUE           ; 0x9E, 2 byte
    dw Instruction_RSHIFT_8VALUE        ; 0x9F, 2 byte
    dw Instruction_LSHIFT_8VALUE        ; 0xA0, 2 byte
    dw Instruction_ADD_A_8VALUE         ; 0xA1, 2 byte
    dw Instruction_ADD_B_8VALUE         ; 0xA2, 2 byte
    dw Instruction_ADD_C_8VALUE         ; 0xA3, 2 byte
    dw Instruction_ADD_D_8VALUE         ; 0xA4, 2 byte
    dw Instruction_SUB_A_8VALUE         ; 0xA5, 2 byte
    dw Instruction_SUB_B_8VALUE         ; 0xA6, 2 byte
    dw Instruction_SUB_C_8VALUE         ; 0xA7, 2 byte
    dw Instruction_SUB_D_8VALUE         ; 0xA8, 2 byte
    dw Instruction_MUL_8VALUE           ; 0xA9, 2 byte
    dw Instruction_DIV_8VALUE           ; 0xAA, 2 byte
    dw Instruction_MOD_8VALUE           ; 0xAB, 2 byte
    dw Instruction_GOTO_8VALUE          ; 0xAC, 2 byte
    dw Instruction_IF_A_EQUAL_8VALUE    ; 0xAD, 2 byte
    dw Instruction_IF_B_EQUAL_8VALUE    ; 0xAE, 2 byte
    dw Instruction_IF_C_EQUAL_8VALUE    ; 0xAF, 2 byte
    dw Instruction_IF_D_EQUAL_8VALUE    ; 0xB0, 2 byte
    dw Instruction_IF_A_NOTEQUAL_8VALUE ; 0xB1, 3 byte
    dw Instruction_IF_B_NOTEQUAL_8VALUE ; 0xB2, 3 byte
    dw Instruction_IF_C_NOTEQUAL_8VALUE ; 0xB3, 3 byte
    dw Instruction_IF_D_NOTEQUAL_8VALUE ; 0xB4, 3 byte
    dw Instruction_IF_A_GREATER_8VALUE  ; 0xB5, 3 byte
    dw Instruction_IF_B_GREATER_8VALUE  ; 0xB6, 3 byte
    dw Instruction_IF_C_GREATER_8VALUE  ; 0xB7, 3 byte
    dw Instruction_IF_D_GREATER_8VALUE  ; 0xB8, 3 byte
    dw Instruction_IF_A_LESSER_8VALUE   ; 0xB9, 3 byte
    dw Instruction_IF_B_LESSER_8VALUE   ; 0xBA, 3 byte
    dw Instruction_IF_C_LESSER_8VALUE   ; 0xBB, 3 byte
    dw Instruction_IF_D_LESSER_8VALUE   ; 0xBC, 3 byte
InstructionPointerTable_ThreeByte:      ;              ;
    dw Instruction_SET_A_16VALUE        ; 0xBD, 3 byte
    dw Instruction_SET_B_16VALUE        ; 0xBE, 3 byte
    dw Instruction_SET_C_16VALUE        ; 0xBF, 3 byte
    dw Instruction_SET_D_16VALUE        ; 0xC0, 3 byte
    dw Instruction_LOAD8_16VALUE        ; 0xC1, 3 byte
    dw Instruction_LOAD16_16VALUE       ; 0xC2, 3 byte
    dw Instruction_SAVE8_16VALUE        ; 0xC3, 3 byte
    dw Instruction_SAVE16_16VALUE       ; 0xC4, 3 byte
    dw Instruction_AND_16VALUE          ; 0xC5, 3 byte
    dw Instruction_OR_16VALUE           ; 0xC6, 3 byte
    dw Instruction_XOR_16VALUE          ; 0xC7, 3 byte
    dw Instruction_ADD_A_16VALUE        ; 0xC8, 3 byte
    dw Instruction_ADD_B_16VALUE        ; 0xC9, 3 byte
    dw Instruction_ADD_C_16VALUE        ; 0xCA, 3 byte
    dw Instruction_ADD_D_16VALUE        ; 0xCB, 3 byte
    dw Instruction_SUB_A_16VALUE        ; 0xCC, 3 byte
    dw Instruction_SUB_B_16VALUE        ; 0xCD, 3 byte
    dw Instruction_SUB_C_16VALUE        ; 0xCE, 3 byte
    dw Instruction_SUB_D_16VALUE        ; 0xCF, 3 byte
    dw Instruction_IF_A_EQUAL_16VALUE   ; 0xD0, 3 byte
    dw Instruction_IF_B_EQUAL_16VALUE   ; 0xD1, 3 byte
    dw Instruction_IF_C_EQUAL_16VALUE   ; 0xD2, 3 byte
    dw Instruction_IF_D_EQUAL_16VALUE   ; 0xD3, 3 byte
    dw Instruction_IF_A_NOTEQUAL_16VALUE; 0xD4, 3 byte
    dw Instruction_IF_B_NOTEQUAL_16VALUE; 0xD5, 3 byte
    dw Instruction_IF_C_NOTEQUAL_16VALUE; 0xD6, 3 byte
    dw Instruction_IF_D_NOTEQUAL_16VALUE; 0xD7, 3 byte
    dw Instruction_IF_A_GREATER_16VALUE ; 0xD8, 3 byte
    dw Instruction_IF_B_GREATER_16VALUE ; 0xD9, 3 byte
    dw Instruction_IF_C_GREATER_16VALUE ; 0xDA, 3 byte
    dw Instruction_IF_D_GREATER_16VALUE ; 0xDB, 3 byte
    dw Instruction_IF_A_LESSER_16VALUE  ; 0xDC, 3 byte
    dw Instruction_IF_B_LESSER_16VALUE  ; 0xDD, 3 byte
    dw Instruction_IF_C_LESSER_16VALUE  ; 0xDE, 3 byte
    dw Instruction_IF_D_LESSER_16VALUE  ; 0xDF, 3 byte

Instruction_RET:
    jp InstructionEnd

Instruction_SET_A_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, e
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableB], a
    ld a, e
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableC], a
    ld a, e
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableD], a
    ld a, e
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_A_16VALUE:
    ld a, e
    ld [wRegulationCustomLogicVariableA], a
    ld a, d
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_16VALUE:
    ld a, e
    ld [wRegulationCustomLogicVariableB], a
    ld a, d
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_16VALUE:
    ld a, e
    ld [wRegulationCustomLogicVariableC], a
    ld a, d
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_16VALUE:
    ld a, e
    ld [wRegulationCustomLogicVariableD], a
    ld a, d
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_A_B:
    ; Override A with B
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_A_C:
    ; Override A with C
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_A_D:
    ; Override A with D
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_A:
    ; Override B with A
    ld a, [wRegulationCustomLogicVariableA]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_B_C:
    ; Override B with C
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_B_D:
    ; Override B with D
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_A:
    ; Override C with A
    ld a, [wRegulationCustomLogicVariableA]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_C_B:
    ; Override C with B
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_C_D:
    ; Override C with D
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_A:
    ; Override D with A
    ld a, [wRegulationCustomLogicVariableA]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_D_B:
    ; Override D with B
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_D_C:
    ; Override D with C
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_A_RANDOM:
    call RegulationRandomNumber
    ld a, c
    ld [wRegulationCustomLogicVariableA], a
    ld a, d
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_RANDOM:
    call RegulationRandomNumber
    ld a, c
    ld [wRegulationCustomLogicVariableB], a
    ld a, d
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_RANDOM:
    call RegulationRandomNumber
    ld a, c
    ld [wRegulationCustomLogicVariableC], a
    ld a, d
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_RANDOM:
    call RegulationRandomNumber
    ld a, c
    ld [wRegulationCustomLogicVariableD], a
    ld a, d
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld c, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld c, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld c, a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld c, a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_RANDOM:
    call RegulationRandomizeTruly
    jp InstructionEnd

Instruction_SET_ARGA_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wVariableA], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wVariableA+1], a
    jp InstructionEnd

Instruction_SET_ARGB_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld [wVariableB], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wVariableB+1], a
    jp InstructionEnd

Instruction_SET_ARGC_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld [wVariableC], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wVariableC+1], a
    jp InstructionEnd

Instruction_SET_ARGD_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld [wVariableD], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wVariableD+1], a
    jp InstructionEnd

Instruction_SET_A_ARGA:
    ld a, [wVariableA]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableA+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_ARGB:
    ld a, [wVariableB]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wVariableB+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_ARGC:
   ld a, [wVariableC]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wVariableC+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_ARGD:
   ld a, [wVariableD]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wVariableD+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd

Instruction_SET_ARGB_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wVariableB], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wVariableB+1], a
    jp InstructionEnd

Instruction_SET_ARGC_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wVariableC], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wVariableC+1], a
    jp InstructionEnd

Instruction_SET_ARGD_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wVariableD], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wVariableD+1], a
    jp InstructionEnd

Instruction_SET_A_ARGB:
    ld a, [wVariableB]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableB+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_A_ARGC:
    ld a, [wVariableC]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableC+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_A_ARGD:
    ld a, [wVariableD]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableD+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD8_8VALUE:
    ld a, 0
    ld d, a
    ld hl, wRegulationCustomLogic
    add hl, de
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD16_8VALUE:
    ld a, 0
    ld d, a
    ld hl, wRegulationCustomLogic
    add hl, de
    ld a, [hli]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD8_16VALUE:
    ld h, d
    ld l, e
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD16_16VALUE:
    ld h, d
    ld l, e
    ld a, [hli]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD8_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld h, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld l, a
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_LOAD16_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld h, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld l, a
    ld a, [hli]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SAVE8_8VALUE:
    ld a, 0
    ld d, a
    ld hl, wRegulationCustomLogic
    add hl, de
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a

    jp InstructionEnd

Instruction_SAVE16_8VALUE:
    ld a, 0
    ld d, a
    ld hl, wRegulationCustomLogic
    add hl, de
    ld a, [wRegulationCustomLogicVariableA]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd

Instruction_SAVE8_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd

Instruction_SAVE16_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableA]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd

Instruction_SAVE8_B:

    jp InstructionEnd

Instruction_SAVE16_B:

    jp InstructionEnd

Instruction_AND_8VALUE:

    jp InstructionEnd

Instruction_AND_16VALUE:

    jp InstructionEnd

Instruction_AND_B:

    jp InstructionEnd

Instruction_AND_C:

    jp InstructionEnd

Instruction_AND_D:

    jp InstructionEnd

Instruction_OR_8VALUE:

    jp InstructionEnd

Instruction_OR_16VALUE:

    jp InstructionEnd

Instruction_OR_B:

    jp InstructionEnd

Instruction_OR_C:

    jp InstructionEnd

Instruction_OR_D:

    jp InstructionEnd

Instruction_XOR_8VALUE:

    jp InstructionEnd

Instruction_XOR_16VALUE:

    jp InstructionEnd

Instruction_XOR_B:

    jp InstructionEnd

Instruction_XOR_C:

    jp InstructionEnd

Instruction_XOR_D:

    jp InstructionEnd

Instruction_RSHIFT_8VALUE:

    jp InstructionEnd

Instruction_RSHIFT_16VALUE:

    jp InstructionEnd

Instruction_RSHIFT_B:

    jp InstructionEnd

Instruction_RSHIFT_C:

    jp InstructionEnd

Instruction_RSHIFT_D:

    jp InstructionEnd

Instruction_LSHIFT_8VALUE:

    jp InstructionEnd

Instruction_LSHIFT_16VALUE:

    jp InstructionEnd

Instruction_LSHIFT_B:

    jp InstructionEnd

Instruction_LSHIFT_C:

    jp InstructionEnd

Instruction_LSHIFT_D:

    jp InstructionEnd

Instruction_ADD_A_8VALUE:
Instruction_ADD_A_16VALUE:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Add the 8value/16value already preloaded
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_ADD_A_B:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableB]
    ld d, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_ADD_A_C:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableC]
    ld d, a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_ADD_A_D:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableD]
    ld d, a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_ADD_A_RANDOM:
    jp InstructionEnd

Instruction_ADD_B_8VALUE:

    jp InstructionEnd

Instruction_ADD_B_16VALUE:

    jp InstructionEnd

Instruction_ADD_B_A:
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableB]
    ld h, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld l, a
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld d, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable B
    ld a, h
    ld [wRegulationCustomLogicVariableB], a
    ld a, l
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_ADD_B_C:
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableB]
    ld h, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld l, a
    ; Load variable C
    ld a, [wRegulationCustomLogicVariableC]
    ld d, a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable B
    ld a, h
    ld [wRegulationCustomLogicVariableB], a
    ld a, l
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_ADD_B_D:
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableB]
    ld h, a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld l, a
    ; Load variable D
    ld a, [wRegulationCustomLogicVariableD]
    ld d, a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable B
    ld a, h
    ld [wRegulationCustomLogicVariableB], a
    ld a, l
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_ADD_B_RANDOM:
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

Instruction_ADD_C_RANDOM:
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

Instruction_ADD_D_RANDOM:
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

Instruction_SUB_A_RANDOM:
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

Instruction_SUB_B_RANDOM:
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

Instruction_SUB_C_RANDOM:
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

Instruction_SUB_D_RANDOM:
    jp InstructionEnd

Instruction_MUL_8VALUE:

    jp InstructionEnd

Instruction_MUL_B:

    jp InstructionEnd

Instruction_MUL_C:

    jp InstructionEnd

Instruction_MUL_D:

    jp InstructionEnd

Instruction_DIV_8VALUE:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, e
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_DIV_B:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableB + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_DIV_C:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableC + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_DIV_D:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableD + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_MOD_B:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableB + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_MOD_C:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableC + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_MOD_D:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableD + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_MOD_8VALUE:

    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, e
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableA + 1], a

    jp InstructionEnd

Instruction_GOTO_8VALUE:
    ld a, e
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value

    jp InstructionEnd

Instruction_GOTO_A:

    ld a, [wRegulationCustomLogicVariableA + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value

    jp InstructionEnd

Instruction_GOTO_B:

    ld a, [wRegulationCustomLogicVariableB + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value

    jp InstructionEnd

Instruction_GOTO_C:

    ld a, [wRegulationCustomLogicVariableC + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value

    jp InstructionEnd

Instruction_GOTO_D:

    ld a, [wRegulationCustomLogicVariableD + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value

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
