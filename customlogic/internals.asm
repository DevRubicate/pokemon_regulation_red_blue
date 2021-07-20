RegulationRandomNumber::
    ld a, [wRegulationRandomSeed]
    ld b, a
    add a, a
    add a, a
    add a, b
    inc a
    rlc a
    ld c, a
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
