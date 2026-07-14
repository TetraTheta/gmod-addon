# Fix Map

## Usage

Write Lua file here, and make a hard-link to lua directory of add-on.

## TODO

Use [`InitPostEntity`](https://wiki.facepunch.com/gmod/GM:InitPostEntity) and [`PlayerSelectSpawn`](https://wiki.facepunch.com/gmod/GM:PlayerSelectSpawn).

1. Move `info_player_start` entities to proper positions with `entity:SetPos()` and `entity:SetAngles()`.
2. Create variable or entity to save checkpoint number.
3. In `PlayerSelectSpawn` hook, use corresponding `info_player_start`.
