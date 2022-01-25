
CustomLogicInterpreter::

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
    dw Instruction_RET                          ; 0x00
    dw Instruction_SET_A_B                      ; 0x01
    dw Instruction_SET_A_C                      ; 0x02
    dw Instruction_SET_A_D                      ; 0x03
    dw Instruction_SET_S_A                      ; 0x04
    dw Instruction_SET_S_B                      ; 0x05
    dw Instruction_SET_S_C                      ; 0x06
    dw Instruction_SET_S_D                      ; 0x07
    dw Instruction_SET_A_S                      ; 0x08
    dw Instruction_SET_B_S                      ; 0x09
    dw Instruction_SET_C_S                      ; 0x0A
    dw Instruction_SET_D_S                      ; 0x0B
    dw Instruction_SET_T_A                      ; 0x0C
    dw Instruction_SET_T_B                      ; 0x0D
    dw Instruction_SET_T_C                      ; 0x0E
    dw Instruction_SET_T_D                      ; 0x0F
    dw Instruction_SET_A_T                      ; 0x10
    dw Instruction_SET_B_T                      ; 0x11
    dw Instruction_SET_C_T                      ; 0x12
    dw Instruction_SET_D_T                      ; 0x13
    dw Instruction_SET_A_RANDOM                 ; 0x14
    dw Instruction_SET_S_RANDOM                 ; 0x15
    dw Instruction_SET_T_RANDOM                 ; 0x16
    dw Instruction_SET_RANDOM_A                 ; 0x17
    dw Instruction_SET_RANDOM_S                 ; 0x18
    dw Instruction_SET_RANDOM_T                 ; 0x19
    dw Instruction_SET_A_ARGA                   ; 0x1A
    dw Instruction_SET_A_ARGB                   ; 0x1B
    dw Instruction_SET_A_ARGC                   ; 0x1C
    dw Instruction_SET_A_ARGD                   ; 0x1D
    dw Instruction_SET_S_ARGA                   ; 0x1E
    dw Instruction_SET_S_ARGB                   ; 0x1F
    dw Instruction_SET_S_ARGC                   ; 0x20
    dw Instruction_SET_S_ARGD                   ; 0x21
    dw Instruction_SET_T_ARGA                   ; 0x22
    dw Instruction_SET_T_ARGB                   ; 0x23
    dw Instruction_SET_T_ARGC                   ; 0x24
    dw Instruction_SET_T_ARGD                   ; 0x25
    dw Instruction_SET_ARGA_A                   ; 0x26
    dw Instruction_SET_ARGB_A                   ; 0x27
    dw Instruction_SET_ARGC_A                   ; 0x28
    dw Instruction_SET_ARGD_A                   ; 0x29
    dw Instruction_SET_ARGA_S                   ; 0x2A
    dw Instruction_SET_ARGB_S                   ; 0x2B
    dw Instruction_SET_ARGC_S                   ; 0x2C
    dw Instruction_SET_ARGD_S                   ; 0x2D
    dw Instruction_SET_ARGA_T                   ; 0x2E
    dw Instruction_SET_ARGB_T                   ; 0x2F
    dw Instruction_SET_ARGC_T                   ; 0x30
    dw Instruction_SET_ARGD_T                   ; 0x31
    dw Instruction_AND_A_B                      ; 0x32
    dw Instruction_AND_A_C                      ; 0x33
    dw Instruction_AND_A_D                      ; 0x34
    dw Instruction_AND_A_S                      ; 0x35
    dw Instruction_AND_S_T                      ; 0x36
    dw Instruction_OR_A_B                       ; 0x37
    dw Instruction_OR_A_C                       ; 0x38
    dw Instruction_OR_A_D                       ; 0x39
    dw Instruction_OR_A_S                       ; 0x3A
    dw Instruction_OR_S_T                       ; 0x3B
    dw Instruction_XOR_A_B                      ; 0x3C
    dw Instruction_XOR_A_C                      ; 0x3D
    dw Instruction_XOR_A_D                      ; 0x3E
    dw Instruction_XOR_A_S                      ; 0x3F
    dw Instruction_XOR_S_T                      ; 0x40
    dw Instruction_RSHIFT_A_B                   ; 0x41
    dw Instruction_RSHIFT_A_C                   ; 0x42
    dw Instruction_RSHIFT_A_D                   ; 0x43
    dw Instruction_RSHIFT_A_S                   ; 0x44
    dw Instruction_RSHIFT_S_T                   ; 0x45
    dw Instruction_LSHIFT_A_B                   ; 0x46
    dw Instruction_LSHIFT_A_C                   ; 0x47
    dw Instruction_LSHIFT_A_D                   ; 0x48
    dw Instruction_LSHIFT_A_S                   ; 0x49
    dw Instruction_LSHIFT_S_T                   ; 0x4A
    dw Instruction_ADD_A_B                      ; 0x4B
    dw Instruction_ADD_A_C                      ; 0x4C
    dw Instruction_ADD_A_D                      ; 0x4D
    dw Instruction_ADD_A_S                      ; 0x4E
    dw Instruction_ADD_S_T                      ; 0x4F
    dw Instruction_ADD_A_RANDOM                 ; 0x50
    dw Instruction_ADD_S_RANDOM                 ; 0x51
    dw Instruction_SUB_A_B                      ; 0x52
    dw Instruction_SUB_A_C                      ; 0x53
    dw Instruction_SUB_A_D                      ; 0x54
    dw Instruction_SUB_A_S                      ; 0x55
    dw Instruction_SUB_S_T                      ; 0x56
    dw Instruction_SUB_A_RANDOM                 ; 0x57
    dw Instruction_SUB_S_RANDOM                 ; 0x58
    dw Instruction_MUL_A_A                      ; 0x59
    dw Instruction_MUL_A_B                      ; 0x5A
    dw Instruction_MUL_A_C                      ; 0x5B
    dw Instruction_MUL_A_D                      ; 0x5C
    dw Instruction_MUL_A_S                      ; 0x5D
    dw Instruction_MUL_S_T                      ; 0x5E
    dw Instruction_DIV_A_B                      ; 0x5F
    dw Instruction_DIV_A_C                      ; 0x60
    dw Instruction_DIV_A_D                      ; 0x61
    dw Instruction_DIV_A_S                      ; 0x62
    dw Instruction_DIV_S_T                      ; 0x63
    dw Instruction_MOD_A_B                      ; 0x64
    dw Instruction_MOD_A_C                      ; 0x65
    dw Instruction_MOD_A_D                      ; 0x66
    dw Instruction_MOD_A_S                      ; 0x67
    dw Instruction_MOD_S_T                      ; 0x68
    dw Instruction_LOAD8_A_S                    ; 0x69
    dw Instruction_LOAD8_S_T                    ; 0x6A
    dw Instruction_LOAD16_A_S                   ; 0x6B
    dw Instruction_LOAD16_S_T                   ; 0x6C
    dw Instruction_SAVE8_A_S                    ; 0x6D
    dw Instruction_SAVE8_S_T                    ; 0x6E
    dw Instruction_SAVE16_A_S                   ; 0x6F
    dw Instruction_SAVE16_S_T                   ; 0x70
    dw Instruction_GOTO_A                       ; 0x71
    dw Instruction_GOTO_S                       ; 0x72
    dw Instruction_IFEQUAL_A_B                  ; 0x73
    dw Instruction_IFEQUAL_A_C                  ; 0x74
    dw Instruction_IFEQUAL_A_D                  ; 0x75
    dw Instruction_IFEQUAL_S_T                  ; 0x76
    dw Instruction_IFNOTEQUAL_A_B               ; 0x77
    dw Instruction_IFNOTEQUAL_A_C               ; 0x78
    dw Instruction_IFNOTEQUAL_A_D               ; 0x79
    dw Instruction_IFNOTEQUAL_S_T               ; 0x7A
    dw Instruction_IFGREATER_A_B                ; 0x7B
    dw Instruction_IFGREATER_A_C                ; 0x7C
    dw Instruction_IFGREATER_A_D                ; 0x7D
    dw Instruction_IFGREATER_S_T                ; 0x7E
    dw Instruction_IFGREATEREQUAL_A_B           ; 0x7F
    dw Instruction_IFGREATEREQUAL_A_C           ; 0x80
    dw Instruction_IFGREATEREQUAL_A_D           ; 0x81
    dw Instruction_IFGREATEREQUAL_S_T           ; 0x82
    dw Instruction_IFLESSER_A_B                 ; 0x83
    dw Instruction_IFLESSER_A_C                 ; 0x84
    dw Instruction_IFLESSER_A_D                 ; 0x85
    dw Instruction_IFLESSER_S_T                 ; 0x86
    dw Instruction_IFLESSEREQUAL_A_B            ; 0x87
    dw Instruction_IFLESSEREQUAL_A_C            ; 0x88
    dw Instruction_IFLESSEREQUAL_A_D            ; 0x89
    dw Instruction_IFLESSEREQUAL_S_T            ; 0x8A
InstructionPointerTable_TwoByte:                ;
    dw Instruction_SET_A_8VALUE                 ; 0x8B
    dw Instruction_SET_B_8VALUE                 ; 0x8C
    dw Instruction_SET_C_8VALUE                 ; 0x8D
    dw Instruction_SET_D_8VALUE                 ; 0x8E
    dw Instruction_AND_A_8VALUE                 ; 0x8F
    dw Instruction_AND_S_8VALUE                 ; 0x90
    dw Instruction_OR_A_8VALUE                  ; 0x91
    dw Instruction_OR_S_8VALUE                  ; 0x92
    dw Instruction_XOR_A_8VALUE                 ; 0x93
    dw Instruction_XOR_S_8VALUE                 ; 0x94
    dw Instruction_RSHIFT_A_8VALUE              ; 0x95
    dw Instruction_RSHIFT_S_8VALUE              ; 0x96
    dw Instruction_LSHIFT_A_8VALUE              ; 0x97
    dw Instruction_LSHIFT_S_8VALUE              ; 0x98
    dw Instruction_ADD_A_8VALUE                 ; 0x99
    dw Instruction_ADD_S_8VALUE                 ; 0x9A
    dw Instruction_SUB_A_8VALUE                 ; 0x9B
    dw Instruction_SUB_S_8VALUE                 ; 0x9C
    dw Instruction_MUL_A_8VALUE                 ; 0x9D
    dw Instruction_MUL_S_8VALUE                 ; 0x9E
    dw Instruction_DIV_A_8VALUE                 ; 0x9F
    dw Instruction_DIV_S_8VALUE                 ; 0xA0
    dw Instruction_MOD_A_8VALUE                 ; 0xA1
    dw Instruction_MOD_S_8VALUE                 ; 0xA2
    dw Instruction_LOAD8_A_8VALUE               ; 0xA3
    dw Instruction_LOAD8_S_8VALUE               ; 0xA4
    dw Instruction_LOAD16_A_8VALUE              ; 0xA5
    dw Instruction_LOAD16_S_8VALUE              ; 0xA6
    dw Instruction_SAVE8_A_8VALUE               ; 0xA7
    dw Instruction_SAVE8_S_8VALUE               ; 0xA8
    dw Instruction_SAVE16_A_8VALUE              ; 0xA9
    dw Instruction_SAVE16_S_8VALUE              ; 0xAA
    dw Instruction_GOTO_8VALUE                  ; 0xAB
    dw Instruction_IFEQUAL_A_8VALUE             ; 0xAC
    dw Instruction_IFEQUAL_S_8VALUE             ; 0xAD
    dw Instruction_IFNOTEQUAL_A_8VALUE          ; 0xAE
    dw Instruction_IFNOTEQUAL_S_8VALUE          ; 0xAF
    dw Instruction_IFGREATER_A_8VALUE           ; 0xB0
    dw Instruction_IFGREATER_S_8VALUE           ; 0xB1
    dw Instruction_IFGREATEREQUAL_A_8VALUE      ; 0xB2
    dw Instruction_IFGREATEREQUAL_S_8VALUE      ; 0xB3
    dw Instruction_IFLESSER_A_8VALUE            ; 0xB4
    dw Instruction_IFLESSER_S_8VALUE            ; 0xB5
    dw Instruction_IFLESSEREQUAL_A_8VALUE       ; 0xB6
    dw Instruction_IFLESSEREQUAL_S_8VALUE       ; 0xB7
    dw Instruction_CALL_8VALUE                  ; 0xB8
InstructionPointerTable_ThreeByte:              ;
    dw Instruction_SET_A_16VALUE                ; 0xB9
    dw Instruction_SET_B_16VALUE                ; 0xBA
    dw Instruction_SET_C_16VALUE                ; 0xBB
    dw Instruction_SET_D_16VALUE                ; 0xBC
    dw Instruction_AND_A_16VALUE                ; 0xBD
    dw Instruction_AND_S_16VALUE                ; 0xBE
    dw Instruction_OR_A_16VALUE                 ; 0xBF
    dw Instruction_OR_S_16VALUE                 ; 0xC0
    dw Instruction_XOR_A_16VALUE                ; 0xC1
    dw Instruction_XOR_S_16VALUE                ; 0xC2
    dw Instruction_RSHIFT_A_16VALUE             ; 0xC3
    dw Instruction_RSHIFT_S_16VALUE             ; 0xC4
    dw Instruction_LSHIFT_A_16VALUE             ; 0xC5
    dw Instruction_LSHIFT_S_16VALUE             ; 0xC6
    dw Instruction_ADD_A_16VALUE                ; 0xC7
    dw Instruction_ADD_S_16VALUE                ; 0xC8
    dw Instruction_SUB_A_16VALUE                ; 0xC9
    dw Instruction_SUB_S_16VALUE                ; 0xCA
    dw Instruction_MUL_A_16VALUE                ; 0xCB
    dw Instruction_MUL_S_16VALUE                ; 0xCC
    dw Instruction_DIV_A_16VALUE                ; 0xCD
    dw Instruction_DIV_S_16VALUE                ; 0xCE
    dw Instruction_MOD_A_16VALUE                ; 0xCF
    dw Instruction_MOD_S_16VALUE                ; 0xD0
    dw Instruction_LOAD8_A_16VALUE              ; 0xD1
    dw Instruction_LOAD8_S_16VALUE              ; 0xD2
    dw Instruction_LOAD16_A_16VALUE             ; 0xD3
    dw Instruction_LOAD16_S_16VALUE             ; 0xD4
    dw Instruction_SAVE8_A_16VALUE              ; 0xD5
    dw Instruction_SAVE8_S_16VALUE              ; 0xD6
    dw Instruction_SAVE16_A_16VALUE             ; 0xD7
    dw Instruction_SAVE16_S_16VALUE             ; 0xD8
    dw Instruction_IFEQUAL_A_16VALUE            ; 0xD9
    dw Instruction_IFEQUAL_S_16VALUE            ; 0xDA
    dw Instruction_IFNOTEQUAL_A_16VALUE         ; 0xE0
    dw Instruction_IFNOTEQUAL_S_16VALUE         ; 0xE1
    dw Instruction_IFGREATER_A_16VALUE          ; 0xE2
    dw Instruction_IFGREATER_S_16VALUE          ; 0xE3
    dw Instruction_IFGREATEREQUAL_A_16VALUE     ; 0xE4
    dw Instruction_IFGREATEREQUAL_S_16VALUE     ; 0xE5
    dw Instruction_IFLESSER_A_16VALUE           ; 0xE6
    dw Instruction_IFLESSER_S_16VALUE           ; 0xE7
    dw Instruction_IFLESSEREQUAL_A_16VALUE      ; 0xE8
    dw Instruction_IFLESSEREQUAL_S_16VALUE      ; 0xE9

Instruction_RET:
    jp InstructionEnd
Instruction_SET_A_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_A_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_A_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_S_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_A_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_B_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd
Instruction_SET_C_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd
Instruction_SET_D_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd
Instruction_SET_T_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_B:
    ld a, [wRegulationCustomLogicVariableB]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wRegulationCustomLogicVariableB+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_C:
    ld a, [wRegulationCustomLogicVariableC]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wRegulationCustomLogicVariableC+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_D:
    ld a, [wRegulationCustomLogicVariableD]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wRegulationCustomLogicVariableD+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_A_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_B_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wRegulationCustomLogicVariableB], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd
Instruction_SET_C_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wRegulationCustomLogicVariableC], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd
Instruction_SET_D_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wRegulationCustomLogicVariableD], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd
Instruction_SET_A_RANDOM:
    call RegulationRandomNumber
    ld a, d
    ld [wRegulationCustomLogicVariableA], a
    ld a, e
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_S_RANDOM:
    call RegulationRandomNumber
    ld a, d
    ld [wRegulationCustomLogicVariableS], a
    ld a, e
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_T_RANDOM:
    call RegulationRandomNumber
    ld a, d
    ld [wRegulationCustomLogicVariableT], a
    ld a, e
    ld [wRegulationCustomLogicVariableT+1], a
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
Instruction_SET_RANDOM_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld c, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd
Instruction_SET_RANDOM_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld c, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld d, a
    add c
    ld [wRegulationRandomSeed], a
    ld a, c
    xor d
    ld [wRegulationRandomSeed+1], a
    jp InstructionEnd
Instruction_SET_A_ARGA:
    ld a, [wVariableA]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [wVariableA+1]
    ld [wRegulationCustomLogicVariableA+1], a
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
Instruction_SET_S_ARGA:
    ld a, [wVariableA]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wVariableA+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_ARGB:
    ld a, [wVariableB]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wVariableB+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_ARGC:
    ld a, [wVariableC]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wVariableC+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_S_ARGD:
    ld a, [wVariableD]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [wVariableD+1]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SET_T_ARGA:
    ld a, [wVariableA]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wVariableA+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_ARGB:
    ld a, [wVariableB]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wVariableB+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_ARGC:
    ld a, [wVariableC]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wVariableC+1]
    ld [wRegulationCustomLogicVariableT+1], a
    jp InstructionEnd
Instruction_SET_T_ARGD:
    ld a, [wVariableD]
    ld [wRegulationCustomLogicVariableT], a
    ld a, [wVariableD+1]
    ld [wRegulationCustomLogicVariableT+1], a
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
Instruction_SET_ARGA_A:
    ld a, [wRegulationCustomLogicVariableA]
    ld [wVariableA], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [wVariableA+1], a
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
Instruction_SET_ARGA_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wVariableA], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wVariableA+1], a
    jp InstructionEnd
Instruction_SET_ARGB_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wVariableB], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wVariableB+1], a
    jp InstructionEnd
Instruction_SET_ARGC_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wVariableC], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wVariableC+1], a
    jp InstructionEnd
Instruction_SET_ARGD_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld [wVariableD], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [wVariableD+1], a
    jp InstructionEnd
Instruction_SET_ARGA_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wVariableA], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wVariableA+1], a
    jp InstructionEnd
Instruction_SET_ARGB_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wVariableB], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wVariableB+1], a
    jp InstructionEnd
Instruction_SET_ARGC_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wVariableC], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wVariableC+1], a
    jp InstructionEnd
Instruction_SET_ARGD_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld [wVariableD], a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld [wVariableD+1], a
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
Instruction_AND_A_B:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableB]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    and b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableB+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    and b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_AND_A_C:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableC]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    and b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableC+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    and b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_AND_A_D:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableD]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    and b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableD+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    and b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_AND_A_S:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableS]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    and b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableS+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    and b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_AND_S_T:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableT]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS]
    and b
    ld [wRegulationCustomLogicVariableS], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableT+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS+1]
    and b
    ld [wRegulationCustomLogicVariableS+1], a

    jp InstructionEnd
Instruction_OR_A_B:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableB]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    or b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableB+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    or b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_OR_A_C:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableC]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    or b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableC+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    or b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_OR_A_D:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableD]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    or b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableD+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    or b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_OR_A_S:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableS]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    or b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableS+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    or b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_OR_S_T:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableT]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS]
    or b
    ld [wRegulationCustomLogicVariableS], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableT+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS+1]
    or b
    ld [wRegulationCustomLogicVariableS+1], a

    jp InstructionEnd
Instruction_XOR_A_B:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableB]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    xor b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableB+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    xor b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_XOR_A_C:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableC]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    xor b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableC+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    xor b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_XOR_A_D:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableD]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    xor b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableD+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    xor b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_XOR_A_S:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableS]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    xor b
    ld [wRegulationCustomLogicVariableA], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableS+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
    xor b
    ld [wRegulationCustomLogicVariableA+1], a

    jp InstructionEnd
Instruction_XOR_S_T:
    ; upper byte
    ld a, [wRegulationCustomLogicVariableT]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS]
    xor b
    ld [wRegulationCustomLogicVariableS], a

    ; lower byte
    ld a, [wRegulationCustomLogicVariableT+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS+1]
    xor b
    ld [wRegulationCustomLogicVariableS+1], a

    jp InstructionEnd
Instruction_RSHIFT_A_B:
    ld a, [wRegulationCustomLogicVariableB+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being rightshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rr b            ; rotate b to the right, pushing rightmost bit into the carry
    rr a            ; rotate a to the right, pushing carry into leftmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end

    ; Save the variable being rightshifted
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, b
    ld [wRegulationCustomLogicVariableA], a

    jp InstructionEnd
Instruction_RSHIFT_A_C:
    ld a, [wRegulationCustomLogicVariableC+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being rightshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rr b            ; rotate b to the right, pushing rightmost bit into the carry
    rr a            ; rotate a to the right, pushing carry into leftmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end

    ; Save the variable being rightshifted
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, b
    ld [wRegulationCustomLogicVariableA], a
    jp InstructionEnd
Instruction_RSHIFT_A_D:
    ld a, [wRegulationCustomLogicVariableD+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being rightshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rr b            ; rotate b to the right, pushing rightmost bit into the carry
    rr a            ; rotate a to the right, pushing carry into leftmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end

    ; Save the variable being rightshifted
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, b
    ld [wRegulationCustomLogicVariableA], a
    jp InstructionEnd
Instruction_RSHIFT_A_S:
    ld a, [wRegulationCustomLogicVariableS+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being rightshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rr b            ; rotate b to the right, pushing rightmost bit into the carry
    rr a            ; rotate a to the right, pushing carry into leftmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end

    ; Save the variable being rightshifted
    ld [wRegulationCustomLogicVariableA+1], a
    ld a, b
    ld [wRegulationCustomLogicVariableA], a
    jp InstructionEnd
Instruction_RSHIFT_S_T:
    ld a, [wRegulationCustomLogicVariableT+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being rightshifted
    ld a, [wRegulationCustomLogicVariableS]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS+1]
 .loop
    or a            ; clear carry
    rr b            ; rotate b to the right, pushing rightmost bit into the carry
    rr a            ; rotate a to the right, pushing carry into leftmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end

    ; Save the variable being rightshifted
    ld [wRegulationCustomLogicVariableS+1], a
    ld a, b
    ld [wRegulationCustomLogicVariableS], a
    jp InstructionEnd
Instruction_LSHIFT_A_B:
    ld a, [wRegulationCustomLogicVariableB+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rl a            ; rotate b to the left, pushing leftmopst bit into the carry
    rl b            ; rotate a to the left, pushing carry into rightmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end
    ; save the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    jp InstructionEnd
Instruction_LSHIFT_A_C:
    ld a, [wRegulationCustomLogicVariableC+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rl a            ; rotate b to the left, pushing leftmopst bit into the carry
    rl b            ; rotate a to the left, pushing carry into rightmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end
    ; save the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    jp InstructionEnd
Instruction_LSHIFT_A_D:
    ld a, [wRegulationCustomLogicVariableD+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rl a            ; rotate b to the left, pushing leftmopst bit into the carry
    rl b            ; rotate a to the left, pushing carry into rightmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end
    ; save the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    jp InstructionEnd
Instruction_LSHIFT_A_S:
    ld a, [wRegulationCustomLogicVariableS+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA+1]
 .loop
    or a            ; clear carry
    rl a            ; rotate b to the left, pushing leftmopst bit into the carry
    rl b            ; rotate a to the left, pushing carry into rightmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end
    ; save the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableA+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableA]
    jp InstructionEnd
Instruction_LSHIFT_S_T:
    ld a, [wRegulationCustomLogicVariableT+1]
    and a
    jr z, .end  ; If we are shifting zero times, just end right away
    ld c, a
    ; Load the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableS]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS+1]
 .loop
    or a            ; clear carry
    rl a            ; rotate b to the left, pushing leftmopst bit into the carry
    rl b            ; rotate a to the left, pushing carry into rightmost bit
    dec c           ; decrement loop
    jr nz, .loop    ; loop as long as there are iterations left
 .end
    ; save the variable being leftshifted
    ld a, [wRegulationCustomLogicVariableS+1]
    ld b, a
    ld a, [wRegulationCustomLogicVariableS]
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
    ; Load variable C
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
    ; Load variable D
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
Instruction_ADD_A_S:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable D
    ld a, [wRegulationCustomLogicVariableS]
    ld d, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_ADD_S_T:
    ; Load variable S
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ; Load variable T
    ld a, [wRegulationCustomLogicVariableT]
    ld d, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld e, a
    ; Add them together
    add hl, de
    ; Store the result in variable S
    ld a, h
    ld [wRegulationCustomLogicVariableS], a
    ld a, l
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_ADD_A_RANDOM:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load random numbers to de
    call RegulationRandomNumber
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_ADD_S_RANDOM:
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ; Load random numbers to de
    call RegulationRandomNumber
    ; Add them together
    add hl, de
    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableS], a
    ld a, l
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SUB_A_B:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable B
    ld a, [wRegulationCustomLogicVariableB]
    xor $ff
    ld d, a
    ld a, [wRegulationCustomLogicVariableB+1]
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SUB_A_C:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable C
    ld a, [wRegulationCustomLogicVariableC]
    xor $ff
    ld d, a
    ld a, [wRegulationCustomLogicVariableC+1]
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SUB_A_D:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable D
    ld a, [wRegulationCustomLogicVariableD]
    xor $ff
    ld d, a
    ld a, [wRegulationCustomLogicVariableD+1]
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SUB_A_S:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a
    ; Load variable D
    ld a, [wRegulationCustomLogicVariableS]
    xor $ff
    ld d, a
    ld a, [wRegulationCustomLogicVariableS+1]
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SUB_S_T:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable S
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ; Load variable A
    ld a, [wRegulationCustomLogicVariableT]
    xor $ff
    ld d, a
    ld a, [wRegulationCustomLogicVariableT+1]
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable S
    ld a, h
    ld [wRegulationCustomLogicVariableS], a
    ld a, l
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SUB_A_RANDOM:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableA]
    ld h, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld l, a

    ; Load random numbers to de
    call RegulationRandomNumber
    ld a, d
    xor $ff
    ld d, a
    ld a, e
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableA], a
    ld a, l
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SUB_S_RANDOM:
    ; This instruction normally subtracts, however there is no
    ; "sub hl, de" opcode, so we are using a trick to get the
    ; same result. In 16 bit math A - B can be expressed as
    ; (A + (B ^ 0xFFFF) + 1) & 0xFFFF.

    ; Load variable A
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a

    ; Load random numbers to de
    call RegulationRandomNumber
    ld a, d
    xor $ff
    ld d, a
    ld a, e
    xor $ff
    ld e, a

    ; Do our trick
    add hl, de
    inc hl

    ; Store the result in variable A
    ld a, h
    ld [wRegulationCustomLogicVariableS], a
    ld a, l
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_MUL_A_A: ; todo
    jp InstructionEnd
Instruction_MUL_A_B: ; todo
    jp InstructionEnd
Instruction_MUL_A_C: ; todo
    jp InstructionEnd
Instruction_MUL_A_D: ; todo
    jp InstructionEnd
Instruction_MUL_A_S: ; todo
    jp InstructionEnd
Instruction_MUL_S_T: ; todo
    jp InstructionEnd
Instruction_DIV_A_B:
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
Instruction_DIV_A_C:
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
Instruction_DIV_A_D:
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
Instruction_DIV_A_S:
    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableS + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableA + 1], a
    jp InstructionEnd
Instruction_DIV_S_T:
    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableS]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableS + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableT + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the end result of the division
    ld a, [hQuotient + 2]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [hQuotient + 3]
    ld [wRegulationCustomLogicVariableS + 1], a
    jp InstructionEnd
Instruction_MOD_A_B:
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
Instruction_MOD_A_C:
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
Instruction_MOD_A_D:
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
Instruction_MOD_A_S:
    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableA]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableA + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableS + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableA + 1], a
    jp InstructionEnd
Instruction_MOD_S_T:
    ; Our input value is 2 bytes long
    ld a, 2
    ld b, a

    ; The 16 bit value to be divided
    ld a, [wRegulationCustomLogicVariableS]
    ld [hDividend], a
    ld a, [wRegulationCustomLogicVariableS + 1]
    ld [hDividend + 1], a

    ; The 8 bit value to divide by
    ld a, [wRegulationCustomLogicVariableT + 1]
    ld [hDivisor], a

    ; Invoke the division
    call Divide

    ; Read out the 8 bit remainer which is the mod result
    ld a, 0
    ld [wRegulationCustomLogicVariableS], a
    ld a, [hRemainder]
    ld [wRegulationCustomLogicVariableS + 1], a
    jp InstructionEnd
Instruction_LOAD8_A_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_LOAD8_S_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld h, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld l, a
    ld a, [hli]
    ld a, 0
    ld [wRegulationCustomLogicVariableS], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_LOAD16_A_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ld a, [hli]
    ld [wRegulationCustomLogicVariableA], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_LOAD16_S_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld h, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld l, a
    ld a, [hli]
    ld [wRegulationCustomLogicVariableS], a
    ld a, [hl]
    ld [wRegulationCustomLogicVariableS+1], a
    jp InstructionEnd
Instruction_SAVE8_A_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE8_S_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld h, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld l, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE16_A_S:
    ld a, [wRegulationCustomLogicVariableS]
    ld h, a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld l, a
    ld a, [wRegulationCustomLogicVariableA]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE16_S_T:
    ld a, [wRegulationCustomLogicVariableT]
    ld h, a
    ld a, [wRegulationCustomLogicVariableT+1]
    ld l, a
    ld a, [wRegulationCustomLogicVariableS]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [hl], a
    jp InstructionEnd
Instruction_GOTO_A:
    ld a, [wRegulationCustomLogicVariableA + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value
    jp InstructionEnd
Instruction_GOTO_S:
    ld a, [wRegulationCustomLogicVariableS + 1]
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value
    jp InstructionEnd
Instruction_IFEQUAL_A_B: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_A_C: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_A_D: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_A: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_B: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_C: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_D: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_T: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_A_B: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_A_C: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_A_D: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_A: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_B: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_C: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_D: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_T: ; todo
    jp InstructionEnd
Instruction_IFGREATER_A_B: ; todo
    jp InstructionEnd
Instruction_IFGREATER_A_C: ; todo
    jp InstructionEnd
Instruction_IFGREATER_A_D: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_A: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_B: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_C: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_D: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_T: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_A_B: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_A_C: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_A_D: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_A: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_B: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_C: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_D: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_T: ; todo
    jp InstructionEnd
Instruction_IFLESSER_A_B: ; todo
    jp InstructionEnd
Instruction_IFLESSER_A_C: ; todo
    jp InstructionEnd
Instruction_IFLESSER_A_D: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_A: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_B: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_C: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_D: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_T: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_A_B: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_A_C: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_A_D: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_A: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_B: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_C: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_D: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_T: ; todo
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
Instruction_AND_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_AND_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_OR_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_OR_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_XOR_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_XOR_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_RSHIFT_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_RSHIFT_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_LSHIFT_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_LSHIFT_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_ADD_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_ADD_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_SUB_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_SUB_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_MUL_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_MUL_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_DIV_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_DIV_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_MOD_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_MOD_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD8_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD8_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD16_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD16_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_SAVE8_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_SAVE8_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_SAVE16_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_SAVE16_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_GOTO_8VALUE:
    ld a, e
    inc a                                           ; Increment by 1 since we use a 1-based index in the interpreter
    ld [WRegulationCustomLogicProgramCounter], a    ; Set the PC to this new value
    jp InstructionEnd
Instruction_IFEQUAL_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATER_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSER_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_A_8VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_8VALUE: ; todo
    jp InstructionEnd
Instruction_CALL_8VALUE:
    jr :++                      ; jump to the end of safecall so that's where we end up once it's over
    :
    ld [wSafeBankBackup], a     ; save a
    ld a, h
    ld [wSafeBankBackup+1], a   ; save h
    ld a, l
    ld [wSafeBankBackup+2], a   ; save l

    ldh a, [hLoadedROMBank]     ; load what bank we are currently in
    push af                     ; save bank for later

    ld hl, SafeBankswitchReturn ; load address we will return to once this safecall is done
    push hl                     ; push the address we will return to

    ld hl, ExternalFunctions
    add hl, de
    add hl, de
    add hl, de

    ld a, [hli]
    ld e, a
    ld a, [hli]
    ld d, a
    push de

    ld a, [hli]              ; load the bank we wanna go to
    pop hl                   ; load the address we wanna go to

    jp SafeBankswitch           ; jump to SafeBankSwitch which isn't stored in a bank itself
    :
    call :--                     ; use a call to ensure this is where we return once we are done
    jp InstructionEnd
Instruction_SET_A_16VALUE:
    ld a, d
    ld [wRegulationCustomLogicVariableA], a
    ld a, e
    ld [wRegulationCustomLogicVariableA+1], a
    jp InstructionEnd
Instruction_SET_B_16VALUE:
    ld a, d
    ld [wRegulationCustomLogicVariableB], a
    ld a, e
    ld [wRegulationCustomLogicVariableB+1], a
    jp InstructionEnd
Instruction_SET_C_16VALUE:
    ld a, d
    ld [wRegulationCustomLogicVariableC], a
    ld a, e
    ld [wRegulationCustomLogicVariableC+1], a
    jp InstructionEnd
Instruction_SET_D_16VALUE:
    ld a, d
    ld [wRegulationCustomLogicVariableD], a
    ld a, e
    ld [wRegulationCustomLogicVariableD+1], a
    jp InstructionEnd
Instruction_AND_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_AND_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_OR_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_OR_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_XOR_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_XOR_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_RSHIFT_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_RSHIFT_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_LSHIFT_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_LSHIFT_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_ADD_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_ADD_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_SUB_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_SUB_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_MUL_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_MUL_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_DIV_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_DIV_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_MOD_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_MOD_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD8_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD8_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD16_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_LOAD16_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_SAVE8_A_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE8_S_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE16_A_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableA]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableA+1]
    ld [hl], a
    jp InstructionEnd
Instruction_SAVE16_S_16VALUE:
    ld h, d
    ld l, e
    ld a, [wRegulationCustomLogicVariableS]
    ld [hli], a
    ld a, [wRegulationCustomLogicVariableS+1]
    ld [hl], a
    jp InstructionEnd
Instruction_IFEQUAL_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFEQUAL_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFNOTEQUAL_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATER_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATER_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFGREATEREQUAL_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSER_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSER_S_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_A_16VALUE: ; todo
    jp InstructionEnd
Instruction_IFLESSEREQUAL_S_16VALUE: ; todo
    jp InstructionEnd
