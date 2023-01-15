DrawTitleScreen::

    hlcoord 1, 12
    ld de, RegulationTitleText
    call PlaceString

    hlcoord 5, 13
    ld de, VersionText
    call PlaceString

    hlcoord 2, 15
    ld de, CreditText
    call PlaceString

    hlcoord 4, 16
    ld de, URLText
    call PlaceString

    ret

RegulationTitleText:
    db   "#MON REGULATION@"

VersionText:
    db   "Version{REGVERSION}@"

CreditText:
    db   "Made by Rubicate@"

URLText:
    db   "pokereg.net@"
