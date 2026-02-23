# Class & Enemy Stat Catalog

## Player Classes — Base Stats

Stats set in constructors using `random.Next(min, max)`.

| Class | HP | PhysAtk | PhysDef | MagAtk | MagDef | Speed | Mana | Crit% | CritDmg | Dodge% |
|-------|-----|---------|---------|--------|--------|-------|------|-------|---------|--------|
| Squire | 50-60 | 15-20 | 13-17 | 7-10 | 10-15 | 10-15 | 4-13 | 2 | 2 | 1 |
| Mage | 45-52 | 10-17 | 10-15 | 17-23 | 15-20 | 13-17 | 15-23 | 1 | 1 | 1 |
| Entertainer | 45-52 | 10-17 | 10-15 | 12-20 | 15-20 | 15-20 | 10-17 | 1 | 1 | 1 |
| Scholar | 40-47 | 7-10 | 10-13 | 15-20 | 15-20 | 10-15 | 10-17 | 1 | 1 | 1 |

## Player Classes — Tier 1

Inherit base stats via `KeepStatsOnUpgrade()`. Only crit/dodge set in constructor.

| Class | Archetype | Role | Abilities | Crit% | CritDmg | Dodge% |
|-------|-----------|------|-----------|-------|---------|--------|
| Duelist | Fighter | Offensive | Slash, Feint | 3 | 3 | 1 |
| Warden | Fighter | Defensive | Block, ShieldBash | 1 | 1 | 1 |
| Ranger | Fighter | Offensive | Pierce, DoubleArrow | 3 | 3 | 1 |
| Martial Artist | Fighter | Offensive | Punch, Sweep | 3 | 3 | 2 |
| Mistweaver | Mage | Offensive | Ice, Chill | 2 | 2 | 1 |
| Firebrand | Mage | Offensive | Fire, Scorch | 2 | 2 | 1 |
| Stormcaller | Mage | Offensive | Lightning, Gust | 3 | 2 | 2 |
| Acolyte | Mage | Support | Cure, Protect, Radiance | 1 | 1 | 1 |
| Bard | Entertainer | Support | Seduce, Melody, Encourage | 1 | 1 | 2 |
| Dervish | Entertainer | Hybrid | Seduce, Dance | 2 | 2 | 3 |
| Orator | Entertainer | Support | Oration, Encourage | 1 | 1 | 1 |
| Chorister | Entertainer | Support | Melody, Sing, Encore | 1 | 1 | 1 |
| Artificer | Scholar | Offensive | EnergyBlast, MagicalTinkering | 1 | 1 | 1 |
| Tinker | Scholar | Utility | Trap, SpringLoaded | 1 | 1 | 1 |
| Arithmancer | Scholar | Utility | Recite, Calculate | 1 | 1 | 1 |
| Cosmologist | Scholar | Utility | TimeWarp, BlackHole, Gravity | 1 | 1 | 1 |

## Player Classes — Tier 2

| Class | Archetype | Role | Abilities | Crit% | CritDmg | Dodge% |
|-------|-----------|------|-----------|-------|---------|--------|
| Cavalry | Fighter | Offensive | Lance, Trample, Rally | 3 | 2 | 2 |
| Knight | Fighter | Defensive | Block, Valor, Aegis | 2 | 2 | 1 |
| Dragoon | Fighter | Hybrid | Jump, DragonBreath, DragonWard | 2 | 2 | 2 |
| Bastion | Fighter | Defensive | ShieldSlam, Fortify, Bulwark | 1 | 1 | 1 |
| Mercenary | Fighter | Offensive | GunShot, CalledShot, Evasion | 4 | 7 | 1 |
| Hunter | Fighter | Offensive | TripleArrow, Snare, HuntersMark | 3 | 3 | 4 |
| Ninja | Fighter | Offensive | SweepingSlash, Dash, SmokeBomb | 3 | 3 | 3 |
| Monk | Fighter | Hybrid | SpiritAttack, PreciseStrike, Meditate | 3 | 3 | 3 |
| Cryomancer | Mage | Offensive | Blizzard, Frostbite, Wall | 2 | 2 | 1 |
| Hydromancer | Mage | Offensive | Purify, Tsunami, Undertow | 2 | 2 | 3 |
| Pyromancer | Mage | Offensive | FireBall, Inferno, Enrage | 2 | 2 | 3 |
| Geomancer | Mage | Offensive | Tremor, Lava, Wall | 2 | 2 | 1 |
| Electromancer | Mage | Offensive | Thunderbolt, ChainLightning, LightningRush | 4 | 3 | 2 |
| Tempest | Mage | Offensive | Hurricane, Tornado, Knockdown | 2 | 2 | 4 |
| Paladin | Mage | Hybrid | Cure, Smash, Smite | 1 | 1 | 1 |
| Priest | Mage | Support | Restoration, HeavenlyBody, Holy | 1 | 1 | 1 |
| Warcrier | Entertainer | Hybrid | BattleCry, Smash, Encore | 3 | 3 | 2 |
| Illusionist | Entertainer | Hybrid | ShadowAttack, Mirage, Bewilderment | 3 | 2 | 4 |
| Mime | Entertainer | Hybrid | Wall, Anvil, InvisibleBox | 2 | 2 | 3 |
| Minstrel | Entertainer | Support | Ballad, Frustrate, Serenade | 1 | 1 | 1 |
| Herald | Entertainer | Support | Inspire, Proclamation, Decree | 1 | 1 | 1 |
| Muse | Entertainer | Support | Lullaby, Vocals, SoothingMelody | 1 | 1 | 1 |
| Laureate | Entertainer | Support | Ovation, Recite, Eulogy | 1 | 1 | 1 |
| Elegist | Entertainer | Support | Nightfall, Inspire, Dirge | 2 | 2 | 1 |
| Automaton | Scholar | Utility | ServoStrike, ProgramDefense, Overclock | 3 | 3 | 1 |
| Technomancer | Scholar | Utility | Random, ProgramDefense, ProgramOffense | 1 | 1 | 1 |
| Alchemist | Scholar | Hybrid | Transmute, VialToss, Elixir | 1 | 1 | 1 |
| Thaumaturge | Scholar | Hybrid | RunicStrike, ArcaneWard, RunicBlast | 1 | 1 | 1 |
| Astronomer | Scholar | Offensive | Starfall, MeteorShower, Eclipse | 1 | 1 | 1 |
| Chronomancer | Scholar | Utility | WarpSpeed, TimeBomb, TimeFreeze | 1 | 1 | 1 |
| Siegemaster | Scholar | Defensive | Earthquake, Build, Demolish | 2 | 2 | 1 |
| Bombardier | Scholar | Hybrid | Shrapnel, Explosion, Detonate | 2 | 2 | 1 |

## Enemies

| Enemy | Level | HP | PhysAtk | PhysDef | MagAtk | MagDef | Speed | Mana | Abilities |
|-------|-------|----|---------|---------|--------|--------|-------|------|-----------|
| Thug | 1 | 45-55 | 14-18 | 8-12 | 3-6 | 8-12 | 12-16 | 4-8 | Punch |
| Bear | 1 | 75-85 | 18-25 | 18-25 | 4-8 | 4-8 | 10-25 | 4-13 | Slash |
| Imp | 1 | 40-50 | 4-10 | 8-15 | 10-15 | 10-15 | 15-20 | 20-31 | Fire |
| Captain | 1 | 60-80 | 13-16 | 13-16 | 4-8 | 4-8 | 5-10 | 15-25 | Explosion |
| Pirate | 1 | 60-80 | 10-13 | 10-13 | 5-10 | 5-10 | 5-10 | 10-20 | GunShot |
| Dragon | 1 | 110-130 | 10-13 | 10-13 | 10-13 | 10-13 | 5-10 | 12-21 | Fire2 |
| Demon | 1 | 110-130 | 4-8 | 8-14 | 16-22 | 13-16 | 5-10 | 20-30 | Fire, Frustrate |
| Zombie | 1 | 30-50 | 18-25 | 4-10 | 18-25 | 4-10 | 10-40 | 4-13 | Slash |
| Druid | 7 | 88-108 | 22-30 | 24-32 | 30-40 | 26-34 | 22-30 | 35-50 | Thornlash, Regrowth, Entangle |
| Necromancer | 7 | 78-98 | 18-26 | 20-28 | 36-46 | 22-30 | 24-32 | 40-55 | DeathTouch, Blight, Decay |
| Psion | 7 | 72-92 | 16-24 | 18-26 | 38-48 | 24-32 | 28-36 | 40-55 | Mindblast, Telekinesis, Confuse |
| Runewright | 7 | 90-110 | 26-34 | 26-34 | 26-34 | 26-34 | 20-28 | 35-50 | RuneStrike, Inscribe, GlyphOfPower |
| Shaman | 7 | 95-115 | 24-32 | 28-36 | 26-34 | 28-36 | 18-26 | 35-50 | SpiritBolt, Rejuvenate, AncestralWard |
| Warlock | 7 | 72-92 | 16-24 | 18-26 | 38-48 | 22-30 | 26-34 | 40-55 | ShadowBolt, Hex, DarkPact |
| Seraph | 9 | 110-130 | 32-42 | 30-38 | 32-42 | 28-36 | 24-32 | 50-65 | Judgment, Sanctuary, Consecrate |
| Fiend | 9 | 90-110 | 22-30 | 22-30 | 42-52 | 26-34 | 28-36 | 55-75 | Hellfire, Corruption, Torment |
| WaterElemental | 10 | 350-450 | 40-50 | 20-30 | 50-60 | 20-30 | 20-30 | 60-80 | Tsunami |
| FireElemental | 10 | 350-450 | 50-60 | 20-30 | 40-50 | 20-30 | 25-35 | 60-80 | FireBall |
| AirElemental | 10 | 260-340 | 30-40 | 25-35 | 30-40 | 25-35 | 30-40 | 60-80 | Hurricane |
| Siren | 1 | 50-65 | 6-12 | 8-14 | 14-20 | 12-18 | 13-18 | 15-25 | Lullaby, Torrent |
| Shade | 4 | 74-88 | 15-21 | 10-15 | 17-23 | 13-18 | 21-28 | 21-31 | ShadowAttack, Frustrate |
| FireWyrmling | 6 | 115-124 | 17-20 | 16-19 | 28-31 | 20-23 | 16-19 | 25-28 | DragonBreath, TailStrike, Roar |
| FrostWyrmling | 6 | 115-124 | 26-29 | 20-23 | 17-20 | 16-19 | 16-19 | 20-23 | Claw, TailStrike, Riptide |
| Hellion | 6 | 130-139 | 24-27 | 20-23 | 18-21 | 16-19 | 15-18 | 22-25 | InfernalStrike, ShadowStrike, Hex |
| Fiendling | 6 | 125-134 | 14-17 | 16-19 | 28-31 | 20-23 | 15-18 | 28-31 | Brimstone, Dread, Hex |

## Enemy IncreaseLevel Growth

| Enemy | HP | Mana | PhysAtk | PhysDef | MagAtk | MagDef | Speed |
|-------|----|------|---------|---------|--------|--------|-------|
| Thug | +3-7 | +1-3 | +1-3 | +1-2 | +0-2 | +1-2 | +1-3 |
| Bear | +5-10 | +1-4 | +3-6 | +3-6 | +1-3 | +1-3 | +1-3 |
| Imp | +5-10 | +2-7 | +1-3 | +1-3 | +2-5 | +2-5 | +2-5 |
| Captain | +5-10 | +2-7 | +3-6 | +3-6 | +1-3 | +1-3 | +2-5 |
| Pirate | +5-10 | +2-7 | +2-5 | +2-5 | +1-3 | +1-3 | +2-5 |
| Dragon | +10-20 | +2-7 | +2-5 | +2-5 | +2-5 | +2-5 | +1-3 |
| Demon | +8-15 | +2-7 | +1-3 | +1-3 | +3-6 | +3-6 | +2-5 |
| Zombie | +5-10 | +1-4 | +3-6 | +1-3 | +3-6 | +1-3 | +1-8 |
| Druid | +7-12 | +3-6 | +2-4 | +2-4 | +4-7 | +3-5 | +2-4 |
| Necromancer | +5-10 | +4-7 | +1-3 | +2-4 | +5-8 | +2-4 | +2-4 |
| Psion | +5-10 | +4-7 | +1-3 | +1-3 | +6-9 | +2-4 | +2-4 |
| Runewright | +7-12 | +3-6 | +3-5 | +3-5 | +3-5 | +3-5 | +2-4 |
| Shaman | +8-13 | +3-6 | +2-4 | +3-5 | +3-5 | +3-5 | +1-3 |
| Warlock | +5-10 | +4-7 | +1-3 | +1-3 | +6-9 | +2-4 | +2-4 |
| Seraph | +8-14 | +3-6 | +3-6 | +3-5 | +3-6 | +3-5 | +2-4 |
| Fiend | +6-12 | +4-8 | +1-3 | +1-3 | +6-10 | +2-4 | +2-4 |
| Siren | +5-10 | +2-5 | +1-3 | +1-3 | +3-6 | +2-5 | +2-4 |
| Shade | +5-10 | +2-5 | +2-4 | +1-3 | +2-5 | +2-4 | +2-5 |
| FireWyrmling | +0 | +0 | +0 | +0 | +0 | +0 | +0 (zeroed growth) |
| FrostWyrmling | +0 | +0 | +0 | +0 | +0 | +0 | +0 (zeroed growth) |
| Hellion | +0 | +0 | +0 | +0 | +0 | +0 | +0 (zeroed growth) |
| Fiendling | +0 | +0 | +0 | +0 | +0 | +0 | +0 (zeroed growth) |
| Elementals | — | — | — | — | — | — | — (empty IncreaseLevel) |

## Enemy Counterparts (Dedicated enemies replacing Tier 2 dual-use classes)

These enemies share abilities with their player counterparts but have independently tunable stats.

| Enemy | Player Counterpart | Level | HP | PhysAtk | PhysDef | MagAtk | MagDef | Speed | Mana | Abilities | Battle |
|-------|-------------------|-------|----|---------|---------|--------|--------|-------|------|-----------|--------|
| Commander | Knight | 5 | 85-105 | 23-33 | 26-36 | 9-14 | 12-18 | 14-20 | 10-20 | Block, Valor, Aegis | ArmyBattle |
| Draconian | Dragoon | 5 | 75-95 | 27-37 | 17-26 | 27-37 | 10-15 | 15-25 | 10-20 | Lunge, Launch, Phalanx | ArmyBattle |
| Sentinel | Bastion | 5 | 90-110 | 18-25 | 30-40 | 8-12 | 25-35 | 12-17 | 10-20 | ShieldSlam, Fortify, Bulwark | ArmyBattle |
| Harlequin | Mime | 6 | 75-93 | 20-28 | 14-22 | 27-36 | 20-28 | 19-28 | 30-40 | Wall, Anvil, InvisibleBox | BoxBattle |
| Phantom | Illusionist | 6 | 62-80 | 16-23 | 18-27 | 28-36 | 14-19 | 28-37 | 15-25 | ShadowAttack, Mirage, Bewilderment | BoxBattle |
| Ringmaster | Herald | 6 | 80-100 | 25-35 | 20-28 | 20-28 | 20-28 | 22-30 | 25-35 | Inspire, Proclamation, Decree | BoxBattle |
| Android | Automaton | 5 | 70-90 | 22-30 | 18-26 | 18-26 | 14-22 | 20-30 | 20-30 | ServoStrike, ProgramDefense, Overclock | LabBattle |
| Machinist | Siegemaster | 5 | 80-100 | 20-30 | 25-35 | 15-24 | 15-20 | 16-22 | 15-25 | Earthquake, Build, Demolish | LabBattle |
| Ironclad | Thaumaturge | 5 | 65-85 | 18-26 | 26-35 | 9-16 | 22-30 | 13-18 | 15-25 | RunicStrike, ArcaneWard, RunicBlast | LabBattle |

### Enemy Counterpart IncreaseLevel Growth

| Enemy | HP | Mana | PhysAtk | PhysDef | MagAtk | MagDef | Speed |
|-------|----|------|---------|---------|--------|--------|-------|
| Commander | +11-17 | +1-4 | +3-6 | +3-6 | +1-3 | +1-3 | +1-3 |
| Draconian | +9-15 | +1-4 | +4-7 | +2-4 | +4-7 | +1-3 | +2-4 |
| Sentinel | +15-21 | +1-4 | +1-3 | +4-7 | +1-3 | +4-7 | +1-3 |
| Harlequin | +8-13 | +5-8 | +3-5 | +2-4 | +4-8 | +4-8 | +2-5 |
| Phantom | +5-10 | +2-5 | +3-5 | +3-6 | +5-8 | +2-4 | +5-8 |
| Android | +10-15 | +4-7 | +4-8 | +4-8 | +3-6 | +3-6 | +4-8 |
| Machinist | +11-17 | +2-5 | +4-7 | +4-8 | +2-4 | +2-4 | +2-4 |
| Ironclad | +8-15 | +2-5 | +3-6 | +5-10 | +2-4 | +5-10 | +1-3 |
| Ringmaster | +8-13 | +3-6 | +3-6 | +2-4 | +2-4 | +2-4 | +2-5 |

## Remaining Dual-Use Classes (Early Game)

These player classes are still used directly as enemies. Stat changes affect both sides.

| Player Class | Archetype | Tier | Battle Used In | # Enemies | Enemy Level-Ups | Character Names |
|-------------|-----------|------|----------------|-----------|-----------------|-----------------|
| Mistweaver | Mage | 1 | DeepForestBattle | 1 | 2 | Morwen |
| Stormcaller | Mage | 1 | DeepForestBattle | 1 | 2 | Thessia |
| Firebrand | Mage | 1 | DeepForestBattle | 1 | 2 | Ashani |
| Dervish | Entertainer | 1 | ClearingBattle | 1 | 2 | Chadwick |
| Chorister | Entertainer | 1 | ClearingBattle | 1 | 2 | Aria |
| Bard | Entertainer | 1 | ClearingBattle | 1 | 2 | Riff |

MirrorBattle clones the entire player party — any class can appear as an enemy there.
