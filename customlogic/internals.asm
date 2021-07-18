RegulationRandomNumber::
    ld hl, wRegulationRandomSeed
    ld a, [hl+]
    sra a
    sra a
    sra a
    xor [hl]
    inc hl
    rra
    rl [hl]
    dec hl
    rl [hl]
    dec hl
    rl [hl]
    ld a, [$fff4]          ; get divider register to increase randomness
    add [hl]
    ret
