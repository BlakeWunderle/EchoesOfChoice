# Asset Manifest

Documents which files were extracted from which purchased asset pack.
Reconstruct the asset tree from the original zips in `Assets/` if needed.

## Audio

### Combat SFX (`audio/sfx/combat/`)
- **Sources**:
  - `Assets/modernfantasycombatsounds_row.zip` — 323 files across 44 categories (strikes, slashes, spells, impacts, swooshes, footsteps, punches)
  - `Assets/scifigamesoundeffectsbundle_row.zip` — 293 sci-fi impact/monster SFX (Impacts/, Monsters/ subfolders)
- **Format**: WAV
- **Total**: ~616 files

### UI SFX (`audio/sfx/ui/`)
- **Sources**:
  - `Assets/fantasyultimatemusiccollection_row.zip` — 19 exciting fanfare cues (SHORT CUES/EXCITING FANFARES/)
  - `Assets/pixelgamesounds_row.zip` — 133 retro chiptune jingles/tonal SFX (01_Melodic_Category01/, 03_Short_Tonal_Sfx/)
  - `Assets/scifigamesoundeffectsbundle_row.zip` — 1,252 sci-fi interface sounds (Interface/ subfolder)
- **Format**: WAV
- **Total**: ~1,404 files

### Movement SFX (`audio/sfx/movement/`)
- **Source**: `Assets/scifigamesoundeffectsbundle_row.zip` (Footsteps/ subfolder)
- **Format**: WAV
- **Contents**: 136 footstep sounds (metal gangway, hard sole on metal)

### Battle Music (`audio/music/battle/`)
- **Sources**:
  - `Assets/completefantasyactionrpgmusicbundle_row.zip` (Battles/ subfolder) — WAV
  - `Assets/fantasytensionmusicpack1_row.zip` (OGG/ subfolder) — OGG
  - `Assets/fantasytensionmusicpack2_row.zip` (OGG/ subfolder) — OGG
  - `Assets/fantasyultimatemusiccollection_row.zip` (MUSIC/BATTLE I/) — WAV
- **Contents**: 63 tracks (battle themes, tension tracks)
- **Note**: Tracks with "LOOP" suffix are loopable versions

### Boss Battle Music (`audio/music/boss/`)
- **Sources**:
  - `Assets/darkfantasybossbattles_row.zip` — 10 FULL/MAIN boss tracks (skip modular loop/intro/outro pieces)
  - `Assets/fantasyultimatemusiccollection_row.zip` (MUSIC/BATTLE II/) — additional epic battle tracks
- **Format**: WAV
- **Contents**: 10 tracks (The Essence of a Soul, Awakening of the Juggernaut, Dance of the Blades A/B, Impending Terror, Calamity of the Desert, Nox - The Light Incarnate, The Battle of Ages, Tomb of the Antediluvian, The Bonfire)

### Sci-Fi Battle Music (`audio/music/battle_scifi/`)
- **Source**: `Assets/scififantasymusic_row.zip` — LOOP variants only
- **Format**: WAV
- **Contents**: 24 tracks (action, cantina, exploration sci-fi themes)
- **Used for**: Lab battle (sci-fi setting in a fantasy world)

### Exploration Music (`audio/music/exploration/`)
- **Sources**:
  - `Assets/completefantasyactionrpgmusicbundle_row.zip` (Exploration/ + Dungeons/ subfolders)
  - `Assets/fantasyultimatemusiccollection_row.zip` (MUSIC/ADVENTURE HEROIC/ + FANTASY OPEN WORLD/)
  - `Assets/darkfantasyexploration_row.zip` — 7 region tracks (one per region: Cinderlands, Blighted Wasteland, The Dark Invitation, Twilight Sanctuary, Spectral Veil, Echoes From Beyond, Dark Whispers)
- **Format**: WAV
- **Contents**: 73 tracks (overworld, dungeon, dark fantasy regions)

### Town Music (`audio/music/town/`)
- **Source**: `Assets/fantasyultimatemusiccollection_row.zip` (MUSIC/TOWN n VILLAGE/ + MEDIEVAL TAVERN/ + MEDIEVAL CELTIC/)
- **Format**: WAV
- **Contents**: 30 tracks (village themes, tavern music, celtic melodies)

### Menu Music (`audio/music/menu/`)
- **Source**: `Assets/completefantasyactionrpgmusicbundle_row.zip` (Menus/ subfolder)
- **Format**: WAV
- **Contents**: 40 tracks (title screen, menu themes, short action/peaceful loops)

### Cutscene Music (`audio/music/cutscene/`)
- **Sources**:
  - `Assets/completefantasyactionrpgmusicbundle_row.zip` (Cues/ subfolder) — 27 story cues
  - `Assets/fantasyultimatemusiccollection_row.zip` (SHORT CUES/SAD n DESPAIR/) — 15 sad/defeat cues
- **Format**: WAV
- **Contents**: 42 tracks (story cues, horn calls, transitions, defeat themes)

## Art

### UI Assets (`art/ui/`)
- **Source**: `Assets/ccgfantasygameui.zip` (extracted via unitypackage)
- **Format**: PNG
- **Contents**: 230 files
  - `Sprites/Characters/` (117 character portraits)
  - `Sprites/Components/` (61 UI elements - frames, buttons, icons)
  - `Sprites/Chars/` (43 smaller character sprites)
  - `Sprites/CardFront/` (4 card front designs)
  - `Sprites/CardCover/` (4 card back designs)
  - `Oswald-Bold.ttf` (font)

## Staged Assets (outside Godot project)

### 3D Models (`Assets_Staged/models/`)
- **Sources**: 10 `Assets/poly_*.zip` packs (secondary .zip inside each, not the .unitypackage)
- **Format**: FBX/OBJ
- **Categories**: village, farm, forest_village, houses, medieval_camp, town_city, weapons, tools, medical, scifi

## Not Yet Extracted

### Low Priority
- `Assets/industrialsoundeffectsbundle_row.zip` - Industrial SFX (1.2 GB)
