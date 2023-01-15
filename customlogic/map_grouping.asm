
LoadMapGrouping::
    ld a, 0
    ld d, a
    ld a, [wCurMap]
    ld e, a
    ld hl, MapGroupingTable
    add hl, de
    ld a, [hl]
    ld d, a
    ret

SetBitFlag::
    ; In register d we have the value which tells us what flag that should be set.
    ; While in hl we have the address to where the flags are stored. However, it's
    ; not a matter of simply adding d to hl as each byte holds 8 flags rather
    ; than one flag.

    ; To solve this, we need to split register d into two separate values, the first
    ; is the byte offset, and the second is the bit offset. Fortunately for us, the
    ; bottom 3 bits of register d exclusively holds what bit we want to set, and
    ; the top 5 bits of the register d exclusively holds what byte we want to set.
    ; So it's really only a matter of separating and adjusting them.

    ld b, a
    and $F8         ; Mask out the lowest 3 bits
    rrc a
    rrc a
    rrc a           ; Rotate 3 times to the right
    ld e, a         ; Save the byte offset into d
    ld a, 0
    ld d, a         ; Save zero as the upper byte
    add hl, de      ; Add byte offset to the hl pointer


    ld a, b
    and $7          ; Mask out the upper 5 bits
    ld b, a         ; Create a loop using b as the iterator
    ld a, 1
    jr z, .end      ; If bit offset is zero jump to .end
.loop
    rlc a           ; Rotate a to the left one step
    dec b           ; Decrement b by 1
    jr nz, .loop    ; Keep looping until b is 0
.end

    ; Register a is now a value that corresponds to the correct flag being set, so
    ; all we need to do is OR it with the old flags at this byte and save it again.

    or [hl]         ; Merge a with the old flags
    ld [hl], a      ; Save the flags back

    ret



CheckBitFlag::
    ; In register d we have the value which tells us what flag that should be set.
    ; While in hl we have the address to where the flags are stored. However, it's
    ; not a matter of simply adding d to hl as each byte holds 8 flags rather
    ; than one flag.

    ; To solve this, we need to split register d into two separate values, the first
    ; is the byte offset, and the second is the bit offset. Fortunately for us, the
    ; bottom 3 bits of register d exclusively holds what bit we want to set, and
    ; the top 5 bits of the register d exclusively holds what byte we want to set.
    ; So it's really only a matter of separating and adjusting them.

    ld b, a
    and $F8         ; Mask out the lowest 3 bits
    rrc a
    rrc a
    rrc a           ; Rotate 3 times to the right
    ld e, a         ; Save the byte offset into d
    ld a, 0
    ld d, a         ; Save zero as the upper byte
    add hl, de      ; Add byte offset to the hl pointer


    ld a, b
    and $7          ; Mask out the upper 5 bits
    ld b, a         ; Create a loop using b as the iterator
    ld a, 1
    jr z, .end      ; If bit offset is zero jump to .end
.loop
    rlc a           ; Rotate a to the left one step
    dec b           ; Decrement b by 1
    jr nz, .loop    ; Keep looping until b is 0
.end
    ; Register a is now a value that corresponds to the correct flag being set, so
    ; all we need to do is OR it with the old flags at this byte and save it again.
    and [hl]         ; Merge a with the old bitflags
    ; the zero flag is our answer
    ret



MapGroupingTable:
    db 26   ; PALLET_TOWN
    db 27   ; VIRIDIAN_CITY
    db 28   ; PEWTER_CITY
    db 29   ; CERULEAN_CITY
    db 30   ; LAVENDER_TOWN
    db 31   ; VERMILION_CITY
    db 32   ; CELADON_CITY
    db 33   ; FUCHSIA_CITY
    db 34   ; CINNABAR_ISLAND
    db 35   ; INDIGO_PLATEAU
    db 36   ; SAFFRON_CITY
    db 0    ; UNUSED_MAP_0B
    db 1    ; ROUTE_1
    db 2    ; ROUTE_2
    db 3    ; ROUTE_3
    db 4    ; ROUTE_4
    db 5    ; ROUTE_5
    db 6    ; ROUTE_6
    db 7    ; ROUTE_7
    db 8    ; ROUTE_8
    db 9    ; ROUTE_9
    db 10   ; ROUTE_10
    db 11   ; ROUTE_11
    db 12   ; ROUTE_12
    db 13   ; ROUTE_13
    db 14   ; ROUTE_14
    db 15   ; ROUTE_15
    db 16   ; ROUTE_16
    db 17   ; ROUTE_17
    db 18   ; ROUTE_18
    db 19   ; ROUTE_19
    db 20   ; ROUTE_20
    db 21   ; ROUTE_21
    db 22   ; ROUTE_22
    db 23   ; ROUTE_23
    db 24   ; ROUTE_24
    db 25   ; ROUTE_25
    db 26   ; REDS_HOUSE_1F
    db 26   ; REDS_HOUSE_2F
    db 26   ; BLUES_HOUSE
    db 26   ; OAKS_LAB
    db 27   ; VIRIDIAN_POKECENTER
    db 27   ; VIRIDIAN_MART
    db 27   ; VIRIDIAN_SCHOOL_HOUSE
    db 27   ; VIRIDIAN_NICKNAME_HOUSE
    db 27   ; VIRIDIAN_GYM
    db 39   ; DIGLETTS_CAVE_ROUTE_2
    db 37   ; VIRIDIAN_FOREST_NORTH_GATE
    db 2    ; ROUTE_2_TRADE_HOUSE
    db 2    ; ROUTE_2_GATE
    db 37   ; VIRIDIAN_FOREST_SOUTH_GATE
    db 37   ; VIRIDIAN_FOREST
    db 28   ; MUSEUM_1F
    db 28   ; MUSEUM_2F
    db 28   ; PEWTER_GYM
    db 28   ; PEWTER_NIDORAN_HOUSE
    db 28   ; PEWTER_MART
    db 28   ; PEWTER_SPEECH_HOUSE
    db 28   ; PEWTER_POKECENTER
    db 38   ; MT_MOON_1F
    db 38   ; MT_MOON_B1F
    db 38   ; MT_MOON_B2F
    db 32   ; CERULEAN_TRASHED_HOUSE
    db 32   ; CERULEAN_TRADE_HOUSE
    db 32   ; CERULEAN_POKECENTER
    db 32   ; CERULEAN_GYM
    db 32   ; BIKE_SHOP
    db 32   ; CERULEAN_MART
    db 4    ; MT_MOON_POKECENTER
    db 0    ; CERULEAN_TRASHED_HOUSE_COPY
    db 5    ; ROUTE_5_GATE
    db 0    ; UNDERGROUND_PATH_ROUTE_5
    db 5    ; DAYCARE
    db 6    ; ROUTE_6_GATE
    db 0    ; UNDERGROUND_PATH_ROUTE_6
    db 0    ; UNDERGROUND_PATH_ROUTE_6_COPY
    db 7    ; ROUTE_7_GATE
    db 0    ; UNDERGROUND_PATH_ROUTE_7
    db 0    ; UNDERGROUND_PATH_ROUTE_7_COPY
    db 8    ; ROUTE_8_GATE
    db 0    ; UNDERGROUND_PATH_ROUTE_8
    db 40   ; ROCK_TUNNEL_POKECENTER
    db 40   ; ROCK_TUNNEL_1F
    db 42   ; POWER_PLANT
    db 11   ; ROUTE_11_GATE_1F
    db 39   ; DIGLETTS_CAVE_ROUTE_11
    db 11   ; ROUTE_11_GATE_2F
    db 12   ; ROUTE_12_GATE_1F
    db 25   ; BILLS_HOUSE
    db 31   ; VERMILION_POKECENTER
    db 31   ; POKEMON_FAN_CLUB
    db 31   ; VERMILION_MART
    db 31   ; VERMILION_GYM
    db 31   ; VERMILION_PIDGEY_HOUSE
    db 31   ; VERMILION_DOCK
    db 31   ; SS_ANNE_1F
    db 31   ; SS_ANNE_2F
    db 31   ; SS_ANNE_3F
    db 31   ; SS_ANNE_B1F
    db 31   ; SS_ANNE_BOW
    db 31   ; SS_ANNE_KITCHEN
    db 31   ; SS_ANNE_CAPTAINS_ROOM
    db 31   ; SS_ANNE_1F_ROOMS
    db 31   ; SS_ANNE_2F_ROOMS
    db 31   ; SS_ANNE_B1F_ROOMS
    db 0    ; UNUSED_MAP_69
    db 0    ; UNUSED_MAP_6A
    db 0    ; UNUSED_MAP_6B
    db 35   ; VICTORY_ROAD_1F
    db 0    ; UNUSED_MAP_6D
    db 0    ; UNUSED_MAP_6E
    db 0    ; UNUSED_MAP_6F
    db 0    ; UNUSED_MAP_70
    db 35   ; LANCES_ROOM
    db 0    ; UNUSED_MAP_72
    db 0    ; UNUSED_MAP_73
    db 0    ; UNUSED_MAP_74
    db 0    ; UNUSED_MAP_75
    db 35   ; HALL_OF_FAME
    db 0    ; UNDERGROUND_PATH_NORTH_SOUTH
    db 35   ; CHAMPIONS_ROOM
    db 0    ; UNDERGROUND_PATH_WEST_EAST
    db 32   ; CELADON_MART_1F
    db 32   ; CELADON_MART_2F
    db 32   ; CELADON_MART_3F
    db 32   ; CELADON_MART_4F
    db 32   ; CELADON_MART_ROOF
    db 32   ; CELADON_MART_ELEVATOR
    db 32   ; CELADON_MANSION_1F
    db 32   ; CELADON_MANSION_2F
    db 32   ; CELADON_MANSION_3F
    db 32   ; CELADON_MANSION_ROOF
    db 32   ; CELADON_MANSION_ROOF_HOUSE
    db 32   ; CELADON_POKECENTER
    db 32   ; CELADON_GYM
    db 32   ; GAME_CORNER
    db 32   ; CELADON_MART_5F
    db 32   ; GAME_CORNER_PRIZE_ROOM
    db 32   ; CELADON_DINER
    db 32   ; CELADON_CHIEF_HOUSE
    db 32   ; CELADON_HOTEL
    db 30   ; LAVENDER_POKECENTER
    db 30   ; POKEMON_TOWER_1F
    db 30   ; POKEMON_TOWER_2F
    db 30   ; POKEMON_TOWER_3F
    db 30   ; POKEMON_TOWER_4F
    db 30   ; POKEMON_TOWER_5F
    db 30   ; POKEMON_TOWER_6F
    db 30   ; POKEMON_TOWER_7F
    db 30   ; MR_FUJIS_HOUSE
    db 30   ; LAVENDER_MART
    db 30   ; LAVENDER_CUBONE_HOUSE
    db 33   ; FUCHSIA_MART
    db 33   ; FUCHSIA_BILLS_GRANDPAS_HOUSE
    db 33   ; FUCHSIA_POKECENTER
    db 33   ; WARDENS_HOUSE
    db 33   ; SAFARI_ZONE_GATE
    db 33   ; FUCHSIA_GYM
    db 33   ; FUCHSIA_MEETING_ROOM
    db 41   ; SEAFOAM_ISLANDS_B1F
    db 41   ; SEAFOAM_ISLANDS_B2F
    db 41   ; SEAFOAM_ISLANDS_B3F
    db 41   ; SEAFOAM_ISLANDS_B4F
    db 31   ; VERMILION_OLD_ROD_HOUSE
    db 33   ; FUCHSIA_GOOD_ROD_HOUSE
    db 34   ; POKEMON_MANSION_1F
    db 34   ; CINNABAR_GYM
    db 34   ; CINNABAR_LAB
    db 34   ; CINNABAR_LAB_TRADE_ROOM
    db 34   ; CINNABAR_LAB_METRONOME_ROOM
    db 34   ; CINNABAR_LAB_FOSSIL_ROOM
    db 34   ; CINNABAR_POKECENTER
    db 34   ; CINNABAR_MART
    db 34   ; CINNABAR_MART_COPY
    db 35   ; INDIGO_PLATEAU_LOBBY
    db 36   ; COPYCATS_HOUSE_1F
    db 36   ; COPYCATS_HOUSE_2F
    db 36   ; FIGHTING_DOJO
    db 36   ; SAFFRON_GYM
    db 36   ; SAFFRON_PIDGEY_HOUSE
    db 36   ; SAFFRON_MART
    db 36   ; SILPH_CO_1F
    db 36   ; SAFFRON_POKECENTER
    db 36   ; MR_PSYCHICS_HOUSE
    db 15   ; ROUTE_15_GATE_1F
    db 15   ; ROUTE_15_GATE_2F
    db 16   ; ROUTE_16_GATE_1F
    db 16   ; ROUTE_16_GATE_2F
    db 16   ; ROUTE_16_FLY_HOUSE
    db 12   ; ROUTE_12_SUPER_ROD_HOUSE
    db 18   ; ROUTE_18_GATE_1F
    db 18   ; ROUTE_18_GATE_2F
    db 41   ; SEAFOAM_ISLANDS_1F
    db 22   ; ROUTE_22_GATE
    db 35   ; VICTORY_ROAD_2F
    db 12   ; ROUTE_12_GATE_2F
    db 31   ; VERMILION_TRADE_HOUSE
    db 39   ; DIGLETTS_CAVE
    db 35   ; VICTORY_ROAD_3F
    db 32   ; ROCKET_HIDEOUT_B1F
    db 32   ; ROCKET_HIDEOUT_B2F
    db 32   ; ROCKET_HIDEOUT_B3F
    db 32   ; ROCKET_HIDEOUT_B4F
    db 32   ; ROCKET_HIDEOUT_ELEVATOR
    db 0    ; UNUSED_MAP_CC
    db 0    ; UNUSED_MAP_CD
    db 0    ; UNUSED_MAP_CE
    db 36   ; SILPH_CO_2F
    db 36   ; SILPH_CO_3F
    db 36   ; SILPH_CO_4F
    db 36   ; SILPH_CO_5F
    db 36   ; SILPH_CO_6F
    db 36   ; SILPH_CO_7F
    db 36   ; SILPH_CO_8F
    db 34   ; POKEMON_MANSION_2F
    db 34   ; POKEMON_MANSION_3F
    db 34   ; POKEMON_MANSION_B1F
    db 33   ; SAFARI_ZONE_EAST
    db 33   ; SAFARI_ZONE_NORTH
    db 33   ; SAFARI_ZONE_WEST
    db 33   ; SAFARI_ZONE_CENTER
    db 33   ; SAFARI_ZONE_CENTER_REST_HOUSE
    db 33   ; SAFARI_ZONE_SECRET_HOUSE
    db 33   ; SAFARI_ZONE_WEST_REST_HOUSE
    db 33   ; SAFARI_ZONE_EAST_REST_HOUSE
    db 33   ; SAFARI_ZONE_NORTH_REST_HOUSE
    db 43   ; CERULEAN_CAVE_2F
    db 43   ; CERULEAN_CAVE_B1F
    db 43   ; CERULEAN_CAVE_1F
    db 30   ; NAME_RATERS_HOUSE
    db 29   ; CERULEAN_BADGE_HOUSE
    db 0    ; UNUSED_MAP_E7
    db 40   ; ROCK_TUNNEL_B1F
    db 36   ; SILPH_CO_9F
    db 36   ; SILPH_CO_10F
    db 36   ; SILPH_CO_11F
    db 36   ; SILPH_CO_ELEVATOR
    db 0    ; UNUSED_MAP_ED
    db 0    ; UNUSED_MAP_EE
    db 0    ; TRADE_CENTER
    db 0    ; COLOSSEUM
    db 0    ; UNUSED_MAP_F1
    db 0    ; UNUSED_MAP_F2
    db 0    ; UNUSED_MAP_F3
    db 0    ; UNUSED_MAP_F4
    db 35   ; LORELEIS_ROOM
    db 35   ; BRUNOS_ROOM
    db 35   ; AGATHAS_ROOM
