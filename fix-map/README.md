# Fix Map

## Usage

Write Lua file here, and make a hard-link to lua directory of add-on.

# NOTE

- `InitEntitySpawn` is both `SERVER`/`CLIENT`, so `if not SERVER then return end` is required.
- `OnEntityCreated` is both `SERVER`/`CLIENT`, so `if not SERVER then return end` is required.
- `PlayerSpawn` hook is `SERVER`-only.
