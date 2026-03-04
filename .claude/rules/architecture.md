# Project Architecture

Godot 4 project using GDScript at `EchoesOfChoice/`.

## File Map

All paths below are relative to `EchoesOfChoice/`.

### Core Data (`scripts/data/`)
- `ability_data.gd` -- Ability model (name, type, modifier, targets, flavor text)
- `ability_db.gd` -- Ability factory: static methods returning AbilityData for all abilities
- `battle_data.gd` -- Battle definition (enemies, narrative text, choices, music_track)
- `battle_db.gd` -- Battle database: all 27 battles with enemy composition and story text
- `enemy_db.gd` -- Enemy factory: creates FighterData for all enemy types
- `fighter_data.gd` -- Fighter stat model (HP, MP, ATK, DEF, SPD, abilities, buffs/debuffs)
- `fighter_db.gd` -- Player class factory: base classes (T0), display names, ability lookups
- `fighter_db_t1.gd` -- Tier 1 class upgrades and level-up functions
- `fighter_db_t2.gd` -- Tier 2 class upgrades (A-M) and level-up functions
- `fighter_db_t2b.gd` -- Tier 2 class upgrades (N-Z) and level-up functions

### Autoload (`scripts/autoload/`)
- `scene_manager.gd` -- Scene transitions with fade overlay, stops music on transition
- `music_manager.gd` -- Background music with crossfade, context-based track pools (battle, exploration, town, menu, boss, cutscene)
- `sfx_manager.gd` -- SFX playback: category enum with folder-based pools, 8-player polyphonic pool, per-category cooldown
- `audio_loader.gd` -- Static utility (class_name AudioLoader, not autoloaded): runtime audio file loading for WAV/OGG/MP3
- `input_config.gd` -- Input action registration (keyboard + gamepad mappings)
- `save_manager.gd` -- Multi-slot save system (3 manual + autosave), JSON serialization
- `pause_overlay.gd` -- CanvasLayer pause menu with save sub-menu, ESC keybinding
- `game_state.gd` -- Game state: party, battle progression, phase tracking

### Scenes (`scenes/`)
- `splash/splash.gd/.tscn` -- Wunderelf Studios splash screen, auto-advances to title
- `title/title.gd/.tscn` -- Title screen with Continue/Load Game/New Game/Quit
- `party_creation/party_creation.gd/.tscn` -- Tavern intro + 3 character creation loops
- `narrative/narrative.gd/.tscn` -- Pre/post-battle narrative text, branch choices, endings
- `battle/battle.gd/.tscn` -- ATB battle scene with turn order, buff/debuff indicators
- `town_stop/town_stop.gd/.tscn` -- Town rest stops between battles
- `class_upgrade/class_upgrade.gd/.tscn` -- Class upgrade selection and reveal

### UI (`scripts/ui/`)
- `dialogue_panel.gd` -- Typewriter text display with input guards
- `choice_menu.gd` -- Vertical choice menu with keyboard/gamepad navigation
- `name_input.gd` -- Text input for character naming
- `fighter_bar.gd` -- HP/MP bars with status effect indicators
- `combat_log.gd` -- Scrolling battle log
- `stats_panel.gd` -- Character stats display with close button

### Assets (`assets/`)
- `audio/music/` -- ~90 music tracks across contexts (menu, battle, boss, exploration, town, cutscene, game_over, victory)
- `audio/sfx/` -- ~600 sound effects in 28 categories + 8 voice packs
- `art/ui/` -- Title background, Wunderelf Studios logo
- `art/battles/` -- 26 battle scene background images
- `fonts/` -- Oswald-Bold.ttf for game theme
