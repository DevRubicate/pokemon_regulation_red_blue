RegulationRandomNumber::
    ld a, [wRegulationRandomSeed]
    ld b, a
    add a, a
    add a, a
    add a, b
    inc a
    rlc a
    ld e, a
    ld [wRegulationRandomSeed], a
    ld b, a
    ld a, [wRegulationRandomSeed+1]
    xor a, b
    ld b, a
    add a, a
    add a, a
    add a, b
    inc a
    rlc a
    ld d, a
    ld [wRegulationRandomSeed+1], a
    ld b, a
  ret

RegulationRandomizeTruly::
    ld a, [rDIV]
    ld b, a
    add a, a
    add a, a
    add a, b
    inc a
    rlc a
    ld c, a
    ld [wRegulationRandomSeed], a
    ld b, a
    ld a, [rDIV]
    xor a, $FF
    xor a, b
    ld b, a
    add a, a
    add a, a
    add a, b
    inc a
    rlc a
    ld d, a
    ld [wRegulationRandomSeed+1], a
    ld b, a
  ret

RegulationProgressChecksum::
    ; Checksum calculations

    ; Load the first byte of the checksum
    ; Add the input byte + 1
    ; Store it back into the first byte of the checksum
    ld a, [wRegulationChecksum+0]
    add c
    add 1
    ld [wRegulationChecksum+0], a

    ; Load the second byte of the checksum
    ; Subtract the first byte of the checksum
    ; Xor the input byte
    ; Store it back into the second byte of the checksum
    ld b, a
    ld a, [wRegulationChecksum+1]
    sub b
    xor c
    ld [wRegulationChecksum+1], a


    ; Parity bit
    ; 0: All bits in all bytes
    ; 1: All bits in odd bytes
    ; 2: All bits in even bytes
    ; 3: Odd bits in all bytes
    ; 4: Even bits in all bytes
    ; 5: Upper bits in all bytes
    ; 6: Lower bits in all bytes
    ; 7: Bit 0, 1, 4, 5 of all bytes

    ld a, [wRegulationChecksum+2]           ; Load the parity byte

    ; Calculate if we are odd or even
    ld a, [wVariableF]
    add 1
    ld [wVariableF], a
    bit 0, a
    jr nz, .even                            ; We incremented by one just before doing our bit test, so do the opposite

    call CalcParityBit                      ; Calculate the input parity bit and save it in b
    ld a, [wRegulationChecksum+2]           ; Load the parity byte

    ; The "everything" parity bit
    xor a, b                                ; XOR old parity bit 0 with the new parity bit

    ; The "odd byte" parity bit
    sla b                                   ; shift new parity bit into bit 1
    xor a, b                                ; XOR old parity bit 1 with the new parity bit
    jr .next

    .even:
    call CalcParityBit                      ; Calculate the input parity bit and save it in b
    ld a, [wRegulationChecksum+2]           ; Load the parity byte

    ; The "everything" parity bit
    xor a, b                                ; XOR old parity bit 0 with the new parity bit

    ; The "even byte" parity bit
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    xor a, b                                ; XOR old parity bit 2 with the new parity bit

    .next:
    ld [wRegulationChecksum+2], a           ; Save the parity byte

    ; The "odd bit" parity bit
    call CalcOddParityBit                   ; Calculate the odd bit input parity bit and save it in b
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    sla b                                   ; shift new parity bit into bit 3
    ld a, [wRegulationChecksum+2]           ; Load the parity byte
    xor a, b                                ; XOR old parity bit 3 with the new parity bit
    ld [wRegulationChecksum+2], a           ; Save the parity byte

    ; The "even bit" parity bit
    call CalcEvenParityBit                  ; Calculate the even bit input parity bit and save it in b
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    sla b                                   ; shift new parity bit into bit 3
    sla b                                   ; shift new parity bit into bit 4
    ld a, [wRegulationChecksum+2]           ; Load the parity byte
    xor a, b                                ; XOR old parity bit 4 with the new parity bit
    ld [wRegulationChecksum+2], a           ; Save the parity byte

    ; The "upper bits" parity bit
    call CalcUpperParityBit                 ; Calculate the upper input parity bit and save it in b
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    sla b                                   ; shift new parity bit into bit 3
    sla b                                   ; shift new parity bit into bit 4
    sla b                                   ; shift new parity bit into bit 5
    ld a, [wRegulationChecksum+2]           ; Load the parity byte
    xor a, b                                ; XOR old parity bit 5 with the new parity bit
    ld [wRegulationChecksum+2], a           ; Save the parity byte

    ; The "lower bits" parity bit
    call CalcLowerParityBit                 ; Calculate the lower input parity bit and save it in b
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    sla b                                   ; shift new parity bit into bit 3
    sla b                                   ; shift new parity bit into bit 4
    sla b                                   ; shift new parity bit into bit 5
    sla b                                   ; shift new parity bit into bit 6
    ld a, [wRegulationChecksum+2]           ; Load the parity byte
    xor a, b                                ; XOR old parity bit 6 with the new parity bit
    ld [wRegulationChecksum+2], a           ; Save the parity byte

    ; The "mix" parity bit
    call CalcMixedParityBit                 ; Calculate the mixed input parity bit and save it in b
    sla b                                   ; shift new parity bit into bit 1
    sla b                                   ; shift new parity bit into bit 2
    sla b                                   ; shift new parity bit into bit 3
    sla b                                   ; shift new parity bit into bit 4
    sla b                                   ; shift new parity bit into bit 5
    sla b                                   ; shift new parity bit into bit 6
    sla b                                   ; shift new parity bit into bit 7
    ld a, [wRegulationChecksum+2]           ; Load the parity byte
    xor a, b                                ; XOR old parity bit 7 with the new parity bit
    ld [wRegulationChecksum+2], a           ; Save the parity byte


    ret

CalcParityBit:
    ld a, 0
    ld b, c

    ; bit 0
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 1
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 2
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 3
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 4
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 5
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 6
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 7
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret

CalcEvenParityBit:
    ld a, 0
    ld b, c

    ; bit 0
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 2
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 4
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 6
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret

CalcOddParityBit:
    ld a, 0
    ld b, c
    rrc b

    ; bit 1
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 3
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 5
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 7
    rrc b
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret

CalcUpperParityBit:
    ld a, 0
    ld b, c
    rrc b
    rrc b
    rrc b
    rrc b

    ; bit 4
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 5
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 6
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 7
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret

CalcLowerParityBit:
    ld a, 0
    ld b, c

    ; bit 0
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 1
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 2
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 3
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret

CalcMixedParityBit:
    ld a, 0
    ld b, c

    ; bit 0
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 1
    rrc b
    jr nc, :+
    inc a
    :

    rrc b
    rrc b

    ; bit 4
    rrc b
    jr nc, :+
    inc a
    :

    ; bit 5
    rrc b
    jr nc, :+
    inc a
    :

    and %00000001
    ld b, a

    ret
