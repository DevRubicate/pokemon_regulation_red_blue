
CustomLogicInterpreter:
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

    cp $7A
    jr c, .oneByteInstruction
    cp $9E
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
    ld a, [hl]                                  ; Load the next next value after the instruction (precaching)
    ld d, a
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
    dw Instruction_NOP                  ; 0x00, 1 byte
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
    dw Instruction_LOAD8_B              ; 0x15, 1 byte
    dw Instruction_LOAD16_B             ; 0x16, 1 byte
    dw Instruction_SAVE8_B              ; 0x17, 1 byte
    dw Instruction_SAVE16_B             ; 0x18, 1 byte
    dw Instruction_AND_B                ; 0x19, 1 byte
    dw Instruction_AND_C                ; 0x1A, 1 byte
    dw Instruction_AND_D                ; 0x1B, 1 byte
    dw Instruction_OR_B                 ; 0x1C, 1 byte
    dw Instruction_OR_C                 ; 0x1D, 1 byte
    dw Instruction_OR_D                 ; 0x1E, 1 byte
    dw Instruction_XOR_B                ; 0x1F, 1 byte
    dw Instruction_XOR_C                ; 0x20, 1 byte
    dw Instruction_XOR_D                ; 0x21, 1 byte
    dw Instruction_RSHIFT_B             ; 0x22, 1 byte
    dw Instruction_RSHIFT_C             ; 0x23, 1 byte
    dw Instruction_RSHIFT_D             ; 0x24, 1 byte
    dw Instruction_LSHIFT_B             ; 0x25, 1 byte
    dw Instruction_LSHIFT_C             ; 0x26, 1 byte
    dw Instruction_LSHIFT_D             ; 0x27, 1 byte
    dw Instruction_ADD_A_B              ; 0x28, 1 byte
    dw Instruction_ADD_A_C              ; 0x29, 1 byte
    dw Instruction_ADD_A_D              ; 0x2A, 1 byte
    dw Instruction_ADD_B_A              ; 0x2B, 1 byte
    dw Instruction_ADD_B_C              ; 0x2C, 1 byte
    dw Instruction_ADD_B_D              ; 0x2D, 1 byte
    dw Instruction_ADD_C_A              ; 0x2E, 1 byte
    dw Instruction_ADD_C_B              ; 0x2F, 1 byte
    dw Instruction_ADD_C_D              ; 0x30, 1 byte
    dw Instruction_ADD_D_A              ; 0x31, 1 byte
    dw Instruction_ADD_D_B              ; 0x32, 1 byte
    dw Instruction_ADD_D_C              ; 0x33, 1 byte
    dw Instruction_SUB_A_B              ; 0x34, 1 byte
    dw Instruction_SUB_A_C              ; 0x35, 1 byte
    dw Instruction_SUB_A_D              ; 0x36, 1 byte
    dw Instruction_SUB_B_A              ; 0x37, 1 byte
    dw Instruction_SUB_B_C              ; 0x38, 1 byte
    dw Instruction_SUB_B_D              ; 0x39, 1 byte
    dw Instruction_SUB_C_A              ; 0x3A, 1 byte
    dw Instruction_SUB_C_B              ; 0x3B, 1 byte
    dw Instruction_SUB_C_D              ; 0x3C, 1 byte
    dw Instruction_SUB_D_A              ; 0x3D, 1 byte
    dw Instruction_SUB_D_B              ; 0x3E, 1 byte
    dw Instruction_SUB_D_C              ; 0x3F, 1 byte
    dw Instruction_MUL_B                ; 0x40, 1 byte
    dw Instruction_MUL_C                ; 0x41, 1 byte
    dw Instruction_MUL_D                ; 0x42, 1 byte
    dw Instruction_DIV_B                ; 0x43, 1 byte
    dw Instruction_DIV_C                ; 0x44, 1 byte
    dw Instruction_DIV_D                ; 0x45, 1 byte
    dw Instruction_GOTO_A               ; 0x46, 1 byte
    dw Instruction_GOTO_B               ; 0x47, 1 byte
    dw Instruction_GOTO_C               ; 0x48, 1 byte
    dw Instruction_GOTO_D               ; 0x49, 1 byte
    dw Instruction_IF_A_EQUAL_B         ; 0x4A, 1 byte
    dw Instruction_IF_A_EQUAL_C         ; 0x4B, 1 byte
    dw Instruction_IF_A_EQUAL_D         ; 0x4C, 1 byte
    dw Instruction_IF_B_EQUAL_A         ; 0x4D, 1 byte
    dw Instruction_IF_B_EQUAL_C         ; 0x4E, 1 byte
    dw Instruction_IF_B_EQUAL_D         ; 0x4F, 1 byte
    dw Instruction_IF_C_EQUAL_B         ; 0x50, 1 byte
    dw Instruction_IF_C_EQUAL_C         ; 0x51, 1 byte
    dw Instruction_IF_C_EQUAL_D         ; 0x52, 1 byte
    dw Instruction_IF_D_EQUAL_A         ; 0x53, 1 byte
    dw Instruction_IF_D_EQUAL_B         ; 0x54, 1 byte
    dw Instruction_IF_D_EQUAL_C         ; 0x55, 1 byte
    dw Instruction_IF_A_NOTEQUAL_B      ; 0x56, 1 byte
    dw Instruction_IF_A_NOTEQUAL_C      ; 0x57, 1 byte
    dw Instruction_IF_A_NOTEQUAL_D      ; 0x58, 1 byte
    dw Instruction_IF_B_NOTEQUAL_A      ; 0x59, 1 byte
    dw Instruction_IF_B_NOTEQUAL_C      ; 0x5A, 1 byte
    dw Instruction_IF_B_NOTEQUAL_D      ; 0x5B, 1 byte
    dw Instruction_IF_C_NOTEQUAL_B      ; 0x5C, 1 byte
    dw Instruction_IF_C_NOTEQUAL_C      ; 0x5D, 1 byte
    dw Instruction_IF_C_NOTEQUAL_D      ; 0x5E, 1 byte
    dw Instruction_IF_D_NOTEQUAL_A      ; 0x5F, 1 byte
    dw Instruction_IF_D_NOTEQUAL_B      ; 0x60, 1 byte
    dw Instruction_IF_D_NOTEQUAL_C      ; 0x61, 1 byte
    dw Instruction_IF_A_GREATER_B       ; 0x62, 1 byte
    dw Instruction_IF_A_GREATER_C       ; 0x63, 1 byte
    dw Instruction_IF_A_GREATER_D       ; 0x64, 1 byte
    dw Instruction_IF_B_GREATER_A       ; 0x65, 1 byte
    dw Instruction_IF_B_GREATER_C       ; 0x66, 1 byte
    dw Instruction_IF_B_GREATER_D       ; 0x67, 1 byte
    dw Instruction_IF_C_GREATER_B       ; 0x68, 1 byte
    dw Instruction_IF_C_GREATER_C       ; 0x69, 1 byte
    dw Instruction_IF_C_GREATER_D       ; 0x6A, 1 byte
    dw Instruction_IF_D_GREATER_A       ; 0x6B, 1 byte
    dw Instruction_IF_D_GREATER_B       ; 0x6C, 1 byte
    dw Instruction_IF_D_GREATER_C       ; 0x6D, 1 byte
    dw Instruction_IF_A_LESSER_B        ; 0x6E, 1 byte
    dw Instruction_IF_A_LESSER_C        ; 0x6F, 1 byte
    dw Instruction_IF_A_LESSER_D        ; 0x70, 1 byte
    dw Instruction_IF_B_LESSER_a        ; 0x71, 1 byte
    dw Instruction_IF_B_LESSER_C        ; 0x72, 1 byte
    dw Instruction_IF_B_LESSER_D        ; 0x73, 1 byte
    dw Instruction_IF_C_LESSER_B        ; 0x74, 1 byte
    dw Instruction_IF_C_LESSER_C        ; 0x75, 1 byte
    dw Instruction_IF_C_LESSER_D        ; 0x76, 1 byte
    dw Instruction_IF_D_LESSER_A        ; 0x77, 1 byte
    dw Instruction_IF_D_LESSER_B        ; 0x78, 1 byte
    dw Instruction_IF_D_LESSER_C        ; 0x79, 1 byte
    dw Instruction_SET_A_8VALUE         ; 0x7A, 2 byte
    dw Instruction_SET_B_8VALUE         ; 0x7B, 2 byte
    dw Instruction_SET_C_8VALUE         ; 0x7C, 2 byte
    dw Instruction_SET_D_8VALUE         ; 0x7D, 2 byte
    dw Instruction_AND_8VALUE           ; 0x7E, 2 byte
    dw Instruction_OR_8VALUE            ; 0x7F, 2 byte
    dw Instruction_XOR_8VALUE           ; 0x80, 2 byte
    dw Instruction_RSHIFT_8VALUE        ; 0x81, 2 byte
    dw Instruction_LSHIFT_8VALUE        ; 0x82, 2 byte
    dw Instruction_ADD_A_8VALUE         ; 0x83, 2 byte
    dw Instruction_ADD_B_8VALUE         ; 0x84, 2 byte
    dw Instruction_ADD_C_8VALUE         ; 0x85, 2 byte
    dw Instruction_ADD_D_8VALUE         ; 0x86, 2 byte
    dw Instruction_SUB_A_8VALUE         ; 0x87, 2 byte
    dw Instruction_SUB_B_8VALUE         ; 0x88, 2 byte
    dw Instruction_SUB_C_8VALUE         ; 0x89, 2 byte
    dw Instruction_SUB_D_8VALUE         ; 0x8A, 2 byte
    dw Instruction_MUL_8VALUE           ; 0x8B, 2 byte
    dw Instruction_DIV_8VALUE           ; 0x8C, 2 byte
    dw Instruction_GOTO_8VALUE          ; 0x8D, 2 byte
    dw Instruction_IF_A_EQUAL_8VALUE    ; 0x8E, 2 byte
    dw Instruction_IF_B_EQUAL_8VALUE    ; 0x8F, 2 byte
    dw Instruction_IF_C_EQUAL_8VALUE    ; 0x90, 2 byte
    dw Instruction_IF_D_EQUAL_8VALUE    ; 0x91, 2 byte
    dw Instruction_IF_A_NOTEQUAL_8VALUE ; 0x92, 2 byte
    dw Instruction_IF_B_NOTEQUAL_8VALUE ; 0x93, 2 byte
    dw Instruction_IF_C_NOTEQUAL_8VALUE ; 0x94, 2 byte
    dw Instruction_IF_D_NOTEQUAL_8VALUE ; 0x95, 2 byte
    dw Instruction_IF_A_GREATER_8VALUE  ; 0x96, 2 byte
    dw Instruction_IF_B_GREATER_8VALUE  ; 0x97, 2 byte
    dw Instruction_IF_C_GREATER_8VALUE  ; 0x98, 2 byte
    dw Instruction_IF_D_GREATER_8VALUE  ; 0x99, 2 byte
    dw Instruction_IF_A_LESSER_8VALUE   ; 0x9A, 2 byte
    dw Instruction_IF_B_LESSER_8VALUE   ; 0x9B, 2 byte
    dw Instruction_IF_C_LESSER_8VALUE   ; 0x9C, 2 byte
    dw Instruction_IF_D_LESSER_8VALUE   ; 0x9D, 2 byte
    dw Instruction_SET_A_16VALUE        ; 0x9E, 3 byte
    dw Instruction_SET_B_16VALUE        ; 0x9F, 3 byte
    dw Instruction_SET_C_16VALUE        ; 0xA0, 3 byte
    dw Instruction_SET_D_16VALUE        ; 0xA1, 3 byte
    dw Instruction_LOAD8_16VALUE        ; 0xA2, 3 byte
    dw Instruction_LOAD16_16VALUE       ; 0xA3, 3 byte
    dw Instruction_SAVE8_16VALUE        ; 0xA4, 3 byte
    dw Instruction_SAVE16_16VALUE       ; 0xA5, 3 byte
    dw Instruction_AND_16VALUE          ; 0xA6, 3 byte
    dw Instruction_OR_16VALUE           ; 0xA7, 3 byte
    dw Instruction_XOR_16VALUE          ; 0xA8, 3 byte
    dw Instruction_ADD_A_16VALUE        ; 0xA9, 3 byte
    dw Instruction_ADD_B_16VALUE        ; 0xAA, 3 byte
    dw Instruction_ADD_C_16VALUE        ; 0xAB, 3 byte
    dw Instruction_ADD_D_16VALUE        ; 0xAC, 3 byte
    dw Instruction_SUB_A_16VALUE        ; 0xAD, 3 byte
    dw Instruction_SUB_B_16VALUE        ; 0xAE, 3 byte
    dw Instruction_SUB_C_16VALUE        ; 0xAF, 3 byte
    dw Instruction_SUB_D_16VALUE        ; 0xB0, 3 byte
    dw Instruction_MUL_16VALUE          ; 0xB1, 3 byte
    dw Instruction_DIV_16VALUE          ; 0xB2, 3 byte
    dw Instruction_IF_A_EQUAL_16VALUE   ; 0xB3, 3 byte
    dw Instruction_IF_B_EQUAL_16VALUE   ; 0xB4, 3 byte
    dw Instruction_IF_C_EQUAL_16VALUE   ; 0xB5, 3 byte
    dw Instruction_IF_D_EQUAL_16VALUE   ; 0xB6, 3 byte
    dw Instruction_IF_A_NOTEQUAL_16VALUE; 0xB7, 3 byte
    dw Instruction_IF_B_NOTEQUAL_16VALUE; 0xB8, 3 byte
    dw Instruction_IF_C_NOTEQUAL_16VALUE; 0xB9, 3 byte
    dw Instruction_IF_D_NOTEQUAL_16VALUE; 0xBA, 3 byte
    dw Instruction_IF_A_GREATER_16VALUE ; 0xBB, 3 byte
    dw Instruction_IF_B_GREATER_16VALUE ; 0xBC, 3 byte
    dw Instruction_IF_C_GREATER_16VALUE ; 0xBD, 3 byte
    dw Instruction_IF_D_GREATER_16VALUE ; 0xBE, 3 byte
    dw Instruction_IF_A_LESSER_16VALUE  ; 0xBF, 3 byte
    dw Instruction_IF_B_LESSER_16VALUE  ; 0xC0, 3 byte
    dw Instruction_IF_C_LESSER_16VALUE  ; 0xC1, 3 byte
    dw Instruction_IF_D_LESSER_16VALUE  ; 0xC2, 3 byte

Instruction_NOP:
    jp InstructionEnd

Instruction_SET_A_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, d
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd

Instruction_SET_B_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableB], a
    ld a, d
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd

Instruction_SET_C_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableC], a
    ld a, d
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd

Instruction_SET_D_8VALUE:
    ld a, 0
    ld [wRegulationCustomLogicVariableD], a
    ld a, d
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
    ld [wRegulationRandomSeed], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationRandomSeed], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationRandomSeed], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd

Instruction_SET_RANDOM_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationRandomSeed], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationRandomSeed+1], a
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

Instruction_MUL_8VALUE:

    jp InstructionEnd

Instruction_MUL_16VALUE:

    jp InstructionEnd

Instruction_MUL_B:

    jp InstructionEnd

Instruction_MUL_C:

    jp InstructionEnd

Instruction_MUL_D:

    jp InstructionEnd

Instruction_DIV_8VALUE:

    jp InstructionEnd

Instruction_DIV_16VALUE:

    jp InstructionEnd

Instruction_DIV_B:

    jp InstructionEnd

Instruction_DIV_C:

    jp InstructionEnd

Instruction_DIV_D:

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

; 0x00
; 0x01
; 0x02
; 0x03
; 0x04
; 0x05
; 0x06
; 0x07
; 0x08
; 0x09
; 0x0A
; 0x0B
; 0x0C
; 0x0D
; 0x0E
; 0x0F
; 0x10
; 0x11
; 0x12
; 0x13
; 0x14
; 0x15
; 0x16
; 0x17
; 0x18
; 0x19
; 0x1A
; 0x1B
; 0x1C
; 0x1D
; 0x1E
; 0x1F
; 0x20
; 0x21
; 0x22
; 0x23
; 0x24
; 0x25
; 0x26
; 0x27
; 0x28
; 0x29
; 0x2A
; 0x2B
; 0x2C
; 0x2D
; 0x2E
; 0x2F
; 0x30
; 0x31
; 0x32
; 0x33
; 0x34
; 0x35
; 0x36
; 0x37
; 0x38
; 0x39
; 0x3A
; 0x3B
; 0x3C
; 0x3D
; 0x3E
; 0x3F
; 0x40
; 0x41
; 0x42
; 0x43
; 0x44
; 0x45
; 0x46
; 0x47
; 0x48
; 0x49
; 0x4A
; 0x4B
; 0x4C
; 0x4D
; 0x4E
; 0x4F
; 0x50
; 0x51
; 0x52
; 0x53
; 0x54
; 0x55
; 0x56
; 0x57
; 0x58
; 0x59
; 0x5A
; 0x5B
; 0x5C
; 0x5D
; 0x5E
; 0x5F
; 0x60
; 0x61
; 0x62
; 0x63
; 0x64
; 0x65
; 0x66
; 0x67
; 0x68
; 0x69
; 0x6A
; 0x6B
; 0x6C
; 0x6D
; 0x6E
; 0x6F
; 0x70
; 0x71
; 0x72
; 0x73
; 0x74
; 0x75
; 0x76
; 0x77
; 0x78
; 0x79
; 0x7A
; 0x7B
; 0x7C
; 0x7D
; 0x7E
; 0x7F
; 0x80
; 0x81
; 0x82
; 0x83
; 0x84
; 0x85
; 0x86
; 0x87
; 0x88
; 0x89
; 0x8A
; 0x8B
; 0x8C
; 0x8D
; 0x8E
; 0x8F
; 0x90
; 0x91
; 0x92
; 0x93
; 0x94
; 0x95
; 0x96
; 0x97
; 0x98
; 0x99
; 0x9A
; 0x9B
; 0x9C
; 0x9D
; 0x9E
; 0x9F
; 0xA0
; 0xA1
; 0xA2
; 0xA3
; 0xA4
; 0xA5
; 0xA6
; 0xA7
; 0xA8
; 0xA9
; 0xAA
; 0xAB
; 0xAC
; 0xAD
; 0xAE
; 0xAF
; 0xB0
; 0xB1
; 0xB2
; 0xB3
; 0xB4
; 0xB5
; 0xB6
; 0xB7
; 0xB8
; 0xB9
; 0xBA
; 0xBB
; 0xBC
; 0xBD
; 0xBE
; 0xBF
; 0xC0
; 0xC1
; 0xC2
; 0xC3
