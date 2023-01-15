CheckWarpPokecenterOnLoadRule::
    ld a, [wRegulationCode+9]   ; load the return to the last Pokecenter when you load rule
    bit 6, a
    ret z

    ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
    ld a, 0
    ld [wSafariZoneGateCurScript], a

    ld a, [wLastBlackoutMap]
    ld [wDestinationMap], a
    ld hl, wd732
    set 2, [hl] ; fly warp or dungeon warp
    farcall SpecialWarpIn
    farcall ResetTrainers
    ret
