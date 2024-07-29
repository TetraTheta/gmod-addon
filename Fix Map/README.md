# Fix Map

## TODO

Use [`InitPostEntity`](https://wiki.facepunch.com/gmod/GM:InitPostEntity) and [`PlayerSelectSpawn`](https://wiki.facepunch.com/gmod/GM:PlayerSelectSpawn).

1. Move `info_player_start` entities to proper positions with `entity:SetPos()` and `entity:SetAngles()`.
2. Create variable or entity to save checkpoint number.
3. In `PlayerSelectSpawn` hook, use corresponding `info_player_start`.
