---
paths:
  - "**/*.gd"
  - "**/*.tscn"
---

# Project Architecture

Godot 4 project using GDScript at `PartingShadows/`.

## File Map

All paths below are relative to `PartingShadows/`.

### Core Data -- Shared (`scripts/data/`)
- `ability_data.gd` -- Ability model (name, type, modifier, targets, flavor text)
- `ability_db.gd` -- Ability factory: static methods returning AbilityData for enemy abilities
- `ability_db_player.gd` -- Player ability factory: Squire, Mage, Entertainer tree abilities
- `ability_db_player_b.gd` -- Player ability factory: Tinker, Wildling, Wanderer tree abilities
- `battle_data.gd` -- Battle definition (enemies, narrative text, choices, music_track)
- `battle_db.gd` -- Battle router: dispatches battle_id to story1/, story2/, and story3/ act modules
- `enemy_helpers.gd` -- Shared stat helpers (es, fixed, base) for all enemy DB factories
- `enemy_db_router.gd` -- Enemy creation router for simulation
- `enemy_roles.gd` -- Enemy combat role, subtype, damage type, and threat tier metadata for all 211 enemies
- `enums.gd` -- Shared enums (ability types, targeting, roles, subtypes, damage types, enemy tiers)
- `fighter_data.gd` -- Fighter stat model (HP, MP, ATK, DEF, SPD, abilities, buffs/debuffs)
- `fighter_db.gd` -- Player class factory: base classes (T0), data-driven level-up, upgrade routing, preview
- `fighter_db_meta.gd` -- Class metadata: display names, ability lookups, flavor text for all 56 classes
- `fighter_db_roles.gd` -- Combat role, subtype, and damage type metadata for all 56 player classes
- `fighter_db_t1.gd` -- Tier 1 class upgrades and level-up functions
- `fighter_db_t2.gd` -- Tier 2 class upgrades: Squire, Mage, Wanderer-Sentinel trees
- `fighter_db_t2b.gd` -- Tier 2 class upgrades: Entertainer, Tinker trees
- `fighter_db_t2c.gd` -- Tier 2 class upgrades: Wildling, Wanderer-Pathfinder trees
- `story_db.gd` -- Story registry: available stories, unlock requirements, first battle IDs

### Core Data -- Story 1 (`scripts/data/story1/`)
- `battle_db_act1.gd` -- Act I battles (city streets, forest, waypoint, forest waypoint town)
- `battle_db_act2.gd` -- Act II battles (branching wilds)
- `battle_db_act3.gd` -- Act III battles (city return + tower reveal)
- `battle_db_act45.gd` -- Act IV-V battles (corruption + final, GateBattle branches to Path A or B)
- `battle_db_act5b.gd` -- Path B battles (ritual anchor, sanctum collapse, stranger undone)
- `enemy_db.gd` -- Act I enemies (thug, ruffian, pickpocket, wolf, boar, goblin, hound, bandit)
- `enemy_db_act2.gd` -- Act II enemies (raider through wraith, 26 types)
- `enemy_db_act345.gd` -- Acts III-V enemies (royal_guard through stranger_final, 17 types)
- `enemy_db_act5b.gd` -- Path B enemies (sigil_colossus through stranger_undone, 7 types)
- `enemy_ability_db.gd` -- Story 1 enemy ability definitions (Acts I-II)
- `enemy_ability_db_late.gd` -- Story 1 enemy ability definitions (Acts III-V)
- `enemy_ability_db_act5b.gd` -- Story 1 Path B enemy ability definitions

### Core Data -- Story 2 (`scripts/data/story2/`)
- `battle_db_s2.gd` -- Act I battles (cave awakening through cave exit)
- `battle_db_s2_act2.gd` -- Act II battles (coastal descent through lighthouse storm)
- `battle_db_s2_act3.gd` -- Act III battles (beneath lighthouse through the reveal, ShatteredSanctum branches to Path A or B)
- `battle_db_s2_act4.gd` -- Act IV Path A battles (depths through Eye of Oblivion, Sera sacrifice)
- `battle_db_s2_pathb.gd` -- Path B battles (archive awakening through Unblinking Eye, save Sera)
- `enemy_db_s2.gd` -- Act I enemies
- `enemy_db_s2_act2.gd` -- Act II enemies
- `enemy_db_s2_act3.gd` -- Act III enemies
- `enemy_db_s2_act4.gd` -- Act IV enemies
- `enemy_db_s2_pathb.gd` -- Path B enemies (fractured_scholar through unblinking_eye, 12 types)
- `enemy_ability_db_s2.gd` -- Story 2 enemy ability definitions (Acts I-II)
- `enemy_ability_db_s2_late.gd` -- Story 2 enemy ability definitions (Acts III-IV)
- `enemy_ability_db_s2_pathb.gd` -- Story 2 Path B enemy ability definitions

### Core Data -- Story 3 (`scripts/data/story3/`)
- `battle_db_s3.gd` -- Acts I-II battles (dream onset through second dream)
- `battle_db_s3_act2.gd` -- Act II expansion battles (extended dream + waking investigation)
- `battle_db_s3_act3.gd` -- Act III battles (lucid dream and cult dream sanctum)
- `battle_db_s3_act45.gd` -- Acts IV-V battles (cult lair through Threadmaster)
- `battle_db_s3_pathb.gd` -- Path B battles (suspicion route: inn search through betrayal)
- `battle_db_s3_pathc.gd` -- Path C battles (Lira's confession route)
- `enemy_db_s3.gd` -- Acts I-II enemies
- `enemy_db_s3_act2.gd` -- Act II expansion enemies (dream + waking investigation)
- `enemy_db_s3_act3.gd` -- Act III enemies (lucid_phantom, thread_spinner, loom_sentinel, cult_shade, dream_warden, thought_leech, void_spinner, void_phantom, rift_mender, sanctum_shade, loom_warden, sanctum_guardian — all unique per battle)
- `enemy_db_s3_act45.gd` -- Acts IV-V enemies (cult_acolyte, cult_enforcer, cult_hexer, thread_guard, dream_hound, ritual_guardian, cult_ritualist, high_weaver, shadow_fragment, threadmaster — all unique per battle)
- `enemy_db_s3_pathb.gd` -- Path B enemies
- `enemy_db_s3_pathc.gd` -- Path C enemies
- `enemy_ability_db_s3.gd` -- Story 3 enemy ability definitions
- `enemy_ability_db_s3_act2.gd` -- Act II expansion enemy abilities
- `enemy_ability_db_s3_pathb.gd` -- Path B enemy abilities
- `enemy_ability_db_s3_pathc.gd` -- Path C enemy abilities

### Autoload (`scripts/autoload/`)
- `logger.gd` -- GameLog autoload: info/warn logging, clipboard export
- `scene_manager.gd` -- Scene transitions with fade overlay, loading spinner with random gameplay tips, stops music on transition
- `music_manager.gd` -- Background music with crossfade, context-based track pools (battle, exploration, town, menu, boss, cutscene), routed to Music bus
- `sfx_manager.gd` -- SFX playback with categorized sound pools, pitch variation, cooldowns, round-robin AudioStreamPlayer pool on SFX bus
- `audio_loader.gd` -- Static utility (class_name AudioLoader, not autoloaded): runtime audio file loading for WAV/OGG/MP3
- `input_config.gd` -- Input action registration with runtime keyboard remapping (gamepad hardcoded), binding persistence via SettingsManager
- `game_state.gd` -- Game state: party, battle progression, story tracking, phase tracking, playtime counter, Steam rich presence updates
- `save_manager.gd` -- Multi-slot save system (3 manual + autosave), JSON serialization with story_id, delete_save, Steam Cloud sync
- `unlock_manager.gd` -- Persistent unlock tracking (story completion, reward classes) via user://unlocks.json, Steam achievement hooks, Steam Cloud sync
- `pause_overlay.gd` -- CanvasLayer pause menu with save, settings, compendium, key bindings sub-menus, confirmation dialogs, ESC keybinding; multiplayer-aware (no tree pause, hide save, leave session); Open to Multiplayer with fighter picker
- `pause_save_slots.gd` -- Save slot UI helper: show/select/overwrite/delete save slots, used by pause_overlay
- `compendium_manager.gd` -- Cross-session enemy/class compendium tracking via user://compendium.json, Steam achievement hooks, Steam Cloud sync
- `settings_manager.gd` -- Global settings persistence (music/SFX/master volume, text speed, difficulty, display mode, resolution, color blind mode with HP/MP/buff/debuff palettes, key bindings) via user://settings.json, Steam Cloud sync
- `steam_manager.gd` -- Steam SDK initialization, persona name, overlay detection, achievements, Cloud read/write/delete, rich presence
- `net_manager.gd` -- Multiplayer session manager: lobby create/join, peer tracking, slot assignment, transport abstraction (ENet/Steam), disconnect handling with AI takeover, game state broadcast for mid-game join
- `local_coop.gd` -- Local co-op manager: device tracking, input gating via _input() filter, slot-to-player mapping, active player control

### Scenes (`scenes/`)
- `splash/splash.gd/.tscn` -- Wunderelf Studios splash screen, auto-advances to title
- `title/title.gd/.tscn` -- Title screen with Continue/Load Game/New Game/Settings/Credits/Quit; New Game opens play mode submenu (Single/Co-op 2P/Co-op 3P/Online)
- `story_select/story_select.gd/.tscn` -- Story selection screen with lock state (New Game submenu)
- `controller_assign/controller_assign.gd/.tscn` -- Local co-op controller assignment: device registration, New Story/Load Save/Back menu
- `lobby/lobby.gd/.tscn` -- Multiplayer lobby: host/join, player list, player count toggle (2P/3P), story select, load save, fighter picker, start
- `party_creation/party_creation.gd/.tscn` -- Tavern intro + 3 character creation loops; multiplayer-aware with per-player creation and waiting overlay; local co-op device gating with player indicator
- `party_creation/party_creation_text.gd` -- Story-specific narrative text for party creation intro/bridge/outro
- `credits/credits.gd/.tscn` -- Scrolling credits scene with music, any-key skip
- `narrative/narrative.gd/.tscn` -- Pre/post-battle narrative text, branch choices, endings, defeat choices, story completion unlocks; multiplayer ready gate, branch voting
- `narrative/narrative_endings.gd` -- Story ending text and unlock notification helpers
- `battle/battle.gd/.tscn` -- ATB battle scene with turn order, buff/debuff indicators, SFX on combat events, post-battle summary overlay, auto-battle mode (unlock-gated); multiplayer: host/guest code paths; local co-op device-gated turns
- `battle/battle_multiplayer.gd` -- Multiplayer RPC logic: remote action execution, state sync, peer disconnect handling
- `battle/battle_ui_builder.gd` -- Static UI construction for battle scene (portrait cards, action menu, combat log layout)
- `battle/battle_display.gd` -- Display helpers: combat events, floating numbers, turn order, portrait cards, battle summary
- `town_stop/town_stop.gd/.tscn` -- Town rest stops between battles with class upgrades and stat comparison preview; multiplayer ready gate, per-player upgrades, branch voting

### Battle Engine (`scripts/battle/`)
- `battle_engine.gd` -- ATB combat loop, turn resolution, ability execution, combat_event signal for floating damage numbers

### UI (`scripts/ui/`)
- `dialogue_panel.gd` -- Typewriter text display with configurable speed, input guards
- `choice_menu.gd` -- Vertical choice menu with keyboard/gamepad navigation, screen reader hints
- `name_input.gd` -- Text input for character naming
- `fighter_bar.gd` -- HP/MP bars with color-blind-aware palettes, status effect indicators, screen reader tooltips
- `combat_log.gd` -- Scrolling battle log with configurable font size
- `stats_panel.gd` -- Character stats display with close button
- `settings_panel.gd` -- Reusable settings UI (music/SFX/master volume sliders, speed/font/color blind dropdowns, toggles, key bindings button)
- `compendium_panel.gd` -- Compendium viewer with Enemies (by story) and Classes (by tier) tabs
- `compendium/compendium_registry.gd` -- Static registry: class/enemy/battle ID lists, portrait path helpers
- `compendium/compendium_card.gd` -- Compendium list item card
- `compendium/compendium_list_view.gd` -- Paginated list view for compendium tabs
- `compendium/pagination_controls.gd` -- Pagination UI controls
- `compendium/detail_modal_base.gd` -- Base class for compendium detail modals
- `compendium/class_detail_modal.gd` -- Class detail modal with tier tree and abilities
- `compendium/enemy_detail_modal.gd` -- Enemy detail modal
- `compendium/battle_detail_modal.gd` -- Battle detail modal
- `confirm_dialog.gd` -- Modal Yes/No confirmation dialog with dark teal styling
- `tip_overlay.gd` -- One-time contextual tutorial tips with JSON persistence (user://tips_seen.json)
- `portrait_card.gd` -- Fighter portrait card with tweened HP/MP bars, floating damage numbers, death animation, status indicators, screen reader tooltips
- `waiting_overlay.gd` -- Animated "Waiting for [Player]..." overlay for multiplayer turn waits
- `virtual_keyboard.gd` -- On-screen keyboard for gamepad text input
- `fighter_picker.gd` -- Multiplayer fighter slot assignment overlay with host cycling and RPC sync
- `ready_gate.gd` -- Multi-player ready gate: blocks progression until all players confirm (local co-op + online)
- `vote_panel.gd` -- Multi-player branch voting: sequential (local co-op) or simultaneous (online) with majority/random tie-break
- `input_remap_panel.gd` -- Keyboard rebinding UI with per-action key capture, reset defaults, settings persistence

### Tools (`scripts/tools/` and `tools/`)
- `scripts/tools/battle_stage_db.gd` -- Battle stage definitions for balance simulator (shared + Story 1)
- `scripts/tools/battle_stage_db_s2s3.gd` -- Battle stage definitions for Story 2 and Story 3
- `scripts/tools/party_composer.gd` -- Party generation for simulation
- `scripts/tools/simulation_runner.gd` -- Battle simulation engine
- `scripts/tools/sim_cache.gd` -- Simulation result caching with file-hash invalidation
- `scripts/tools/sim_diagnostics.gd` -- Per-class offense/defense diagnostics for weak classes (role-aware categories)
- `scripts/tools/sim_progressive.gd` -- Progressive stage validation for simulation
- `scripts/tools/sim_report.gd` -- JSON/text report generation for simulation results
- `scripts/tools/sim_report_markdown.gd` -- Markdown class balance report generator (tier tables, outliers, boss section)
- `scripts/tools/sim_repetitiveness.gd` -- Battle repetitiveness analysis: cosine similarity on role/subtype vectors, damage monotony detection
- `tools/battle_simulator.gd` -- Headless battle simulator entry point
- `tools/battle_sim_parallel.gd` -- Parallel worker coordinator for batch simulation
- `tools/debug_battle.gd` -- Quick-launch a battle for testing UI changes (with debug_battle.tscn)
- `tools/repetitiveness.gd` -- Standalone repetitiveness analysis: per-story archetype similarity + damage monotony

### Resources (`resources/`)
- `audio/default_bus_layout.tres` -- Audio bus layout: Master, Music (→Master), SFX (→Master)
- `gui/game_theme.tres` -- Global UI theme (fonts, button/panel/scrollbar styles, colors)
- `shaders/shadow_portrait.gdshader` -- Portrait shadow effect shader

### Assets (`assets/`)
- `audio/music/` -- ~70 music tracks across contexts (menu, battle, battle_dark, battle_scifi, boss, town, cutscene, game_over, victory)
- `audio/sfx/` -- ~1600 SFX files: combat subfolders (strike, impact, slash, spell, etc.) + ui/
- `art/ui/` -- Title background, Wunderelf Studios logo
- `art/battles/` -- 154 battle scene background images
- `art/portraits/` -- 690 enemy and class portrait images
- `fonts/Cinzel-Bold.ttf` -- Primary UI font (buttons, labels, menus) via game_theme.tres
- `fonts/CormorantGaramond-SemiBold.ttf` -- Narrative/body text (RichTextLabel, LineEdit) via game_theme.tres
- `fonts/Oswald-Bold.ttf` -- Available in project but not referenced by game_theme.tres
