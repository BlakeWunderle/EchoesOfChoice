---
name: class-reference
description: Quick-reference for all 47 player classes in Echoes of Choice, including upgrade trees, abilities, and archetype groupings. Use when analyzing class win rates, identifying which upgrade tree a class belongs to, checking class abilities, or mapping simulation output back to archetypes. Also use when a whole tree branch appears weak or strong to determine if the issue is the Tier 1 parent, the Tier 2 class, or shared abilities.
---

# Class Reference

45 player classes across 4 archetypes (plus 2 Royal). Squire has 3 T1 branches; Entertainer and Scholar have 4; Mage has 2.

## Upgrade Trees

Each line: `Base -> (Item) -> Tier1 [abilities] -> (Item) -> Tier2 [abilities]`

### Fighter

- Squire [Slash, Guard] -> (Sword) -> Duelist [Slash, Feint] -> (Horse) -> Cavalry [Lance, Trample, Rally] | (Spear) -> Dragoon [Jump, DragonBreath, DragonWard]
- Squire -> (Bow) -> Ranger [Pierce, DoubleArrow] -> (Gun) -> Mercenary [GunShot, CalledShot, Evasion] | (Trap) -> Hunter [TripleArrow, Snare, HuntersMark]
- Squire -> (Headband) -> MartialArtist [Punch, Sweep] -> (Sword) -> Ninja [SweepingSlash, Dash, SmokeBomb] | (Staff) -> Monk [SpiritAttack, PreciseStrike, ChiMend]

### Mage

- Mage [ArcaneBolt] -> (RedStone) -> Invoker [ArcaneBolt, ElementalSurge] -> (FireStone) -> Infernalist [FireBall, Inferno, Enrage] | (WaterStone) -> Tidecaller [Purify, Tsunami, Undertow] | (LightningStone) -> Tempest [Thunderbolt, ChainLightning, Hurricane]
- Mage -> (WhiteStone) -> Acolyte [Cure, Protect, Radiance] -> (Hammer) -> Paladin [Cure, Smash, Smite] | (HolyBook) -> Priest [Restoration, HeavenlyBody, Holy] | (DarkOrb) -> Warlock [ShadowBolt, Curse, DrainLife]

### Entertainer

- Entertainer [Sing, Demoralize] -> (Guitar) -> Bard [Seduce, Melody, Encourage] -> (WarHorn) -> Warcrier [BattleCry, Smash, Encore] | (Hat) -> Minstrel [Ballad, Frustrate, Serenade]
- Entertainer -> (Slippers) -> Dervish [Seduce, Dance] -> (Light) -> Illusionist [ShadowAttack, Mirage, Bewilderment] | (Paint) -> Mime [InvisibleWall, Anvil, InvisibleBox]
- Entertainer -> (Scroll) -> Orator [Oration, Encourage] -> (Pen) -> Elegist [Nightfall, Inspire, Dirge] | (Medal) -> Laureate [Ovation, Recite, Eulogy]
- Entertainer -> (Hymnal) -> Chorister [Melody, Sing, Encore] -> (Trumpet) -> Herald [Inspire, Proclamation, Decree] | (Lyre) -> Muse [Lullaby, Vocals, SoothingMelody]

### Scholar

- Scholar [Proof, EnergyBlast] -> (Crystal) -> Artificer [EnergyBlast, MagicalTinkering] -> (Potion) -> Alchemist [Transmute, VialToss, Elixir] | (Hammer) -> Thaumaturge [RunicStrike, ArcaneWard, RunicBlast]
- Scholar -> (Blueprint) -> Tinker [Trap, SpringLoaded] -> (Dynamite) -> Bombardier [Shrapnel, Explosion, Detonate] | (Brick) -> Siegemaster [Earthquake, Demolish, Taunt]
- Scholar -> (Textbook) -> Cosmologist [TimeWarp, BlackHole, Gravity] -> (TimeMachine) -> Chronomancer [WarpSpeed, TimeBomb, TimeFreeze] | (Telescope) -> Astronomer [Starfall, MeteorShower, Eclipse]
- Scholar -> (Abacus) -> Arithmancer [Recite, Calculate] -> (ClockworkCore) -> Automaton [ServoStrike, ProgramDefense, Overclock] | (Computer) -> Technomancer [Random, ProgramDefense, ProgramOffense]

## Using This Reference

When analyzing CLASS BREAKDOWN output from the battle simulator:

1. **Map class to tree**: Find the class in the trees above to identify its archetype, Tier 1 parent, and sibling class.
2. **Check siblings**: If a Tier 2 class is weak, check whether its sibling (same Tier 1 parent) is also weak. Both weak = likely a Tier 1 growth issue. One weak = likely a Tier 2 ability/stat issue.
3. **Check branch**: If both Tier 2 classes under a Tier 1 are weak, the Tier 1 growth rates or upgrade bonuses may need adjustment.

For full per-class details (abilities, crit/dodge, upgrade bonuses), see [class-details.md](class-details.md).
For stat growth numbers and enemy counterparts, see the [character-stat-tuning skill](../character-stat-tuning/class-catalog.md).
