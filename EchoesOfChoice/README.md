# Echoes of Choice

A text-based RPG where a mysterious stranger in a tavern sets three warriors on a branching journey. Choose your class, upgrade your abilities, and fight your way through a world where every decision shapes your path. No two playthroughs are the same.

## How to Play

The game runs in the console. Type your choices and press Enter.

- **Character creation**: Name three warriors and pick a class for each.
- **Battle actions**: On your turn, choose to `Attack`, use an `Ability` (costs mana), or view `Stats`.
- **Path choices**: After certain battles, choose which direction to travel. Each path leads to different enemies and encounters.
- **Class upgrades**: After key victories, each warrior finds an item that evolves their class and abilities.
- **Auto-save**: The game saves after every victory. On startup, choose to continue or start fresh.

## Classes

Four base classes, each branching into unique upgrade paths across two tiers -- 32 final classes in total.

| Base Class | Playstyle |
|------------|-----------|
| **Squire** | High health and physical attack. The front-line fighter. |
| **Mage** | High magic attack and mana. Elemental damage and healing. |
| **Entertainer** | High speed with a mix of offensive and support abilities. |
| **Scholar** | Strong magic stats with unique utility abilities. |

Each class upgrade presents a meaningful choice -- there are no wrong answers, just different builds.

### Class Evolution

Each base class branches into four Tier 1 specializations, and each Tier 1 class branches into two Tier 2 classes. Upgrade items found after key battles unlock each evolution. Some final classes are hidden below -- you'll have to discover them on your own.

**Squire**

- Duelist (Sword) -- a fencer who strikes with precision
  - Cavalry (Horse)
  - Dragoon (Spear)
- Warden (Shield) -- a defensive wall
  - Knight (Sword)
  - Bastion (Helmet)
- Ranger (Bow) -- a ranged skirmisher
  - ???
  - Hunter (Trap)
- Martial Artist (Headband) -- an unarmed brawler
  - ???
  - Monk (Staff)

**Mage**

- Firebrand (Red Stone) -- channels the destructive power of fire
  - Pyromancer (Fire Stone)
  - ???
- Mistweaver (Blue Stone) -- commands water and ice
  - Cryomancer (Ice Stone)
  - Hydromancer (Water Stone)
- Stormcaller (Yellow Stone) -- wields lightning and wind
  - Electromancer (Lightning Stone)
  - Tempest (Air Stone)
- Acolyte (White Stone) -- draws on divine light
  - Paladin (Hammer)
  - Priest (Holy Book)

**Entertainer**

- Bard (Guitar) -- a musician whose songs cut deep
  - Minstrel (Hat)
  - ???
- Dervish (Slippers) -- a dancer who fights with grace
  - Illusionist (Light)
  - ???
- Orator (Scroll) -- a speaker whose words wound
  - Elegist (Pen)
  - Laureate (Medal)
- Chorister (Hymnal) -- a vocalist with powerful support magic
  - Herald (Trumpet)
  - Muse (Lyre)

**Scholar**

- Artificer (Crystal) -- a crafter who channels magic through potions and runes
  - Alchemist (Potion)
  - Thaumaturge (Hammer)
- Tinker (Blueprint) -- an inventor who builds destructive devices
  - Bombardier (Dynamite)
  - Siegemaster (Brick)
- Cosmologist (Textbook) -- a stargazer who studies the universe
  - Astronomer (Telescope)
  - ???
- Arithmancer (Abacus) -- a mathematician who bends logic into power
  - ???
  - Technomancer (Computer)

## Stats

- **Health** -- Your life total. Drops to zero and that character is knocked out for the rest of the battle.
- **Mana** -- Fuels abilities. Starts full each battle and does not regenerate during combat.
- **Physical Attack** -- Determines damage from basic attacks and physical abilities.
- **Physical Defense** -- Reduces incoming physical damage.
- **Magic Attack** -- Determines damage from magical abilities.
- **Magic Defense** -- Reduces incoming magical damage.
- **Speed** -- Controls how often a character gets a turn. Faster characters act more frequently.
- **Crit Chance** -- Likelihood of landing a critical hit. Applies to both basic attacks and abilities.
- **Crit Damage** -- Bonus damage multiplier when a critical hit lands.
- **Dodge Chance** -- Chance to completely avoid a physical attack. Abilities cannot be dodged.

## Combat

- **Turns** -- Speed fills a hidden gauge. When it's full, that character acts. Faster characters can take multiple turns before a slower one gets a single turn.
- **Basic attacks** cost no mana and deal damage based on Physical Attack minus the target's Physical Defense. They can be dodged and can land critical hits.
- **Abilities** cost mana and cannot be dodged. Damage scales with the relevant attack stat minus the target's matching defense. They can still land critical hits. Some abilities target all enemies or all allies.
- **Buffs and debuffs** are temporary stat changes that wear off after a set number of turns.
- **Taunt** forces all enemies to attack the taunting character for one turn, protecting fragile allies.
- **Mana** does not regenerate during battle. Every ability spent is mana you won't have later in the fight.
- **Knockouts** -- When a character's health reaches zero, they are knocked out for the rest of that battle. If the party wins, all knocked-out allies are revived and rejoin at full health. If all three fall, the journey ends.

## Abilities

Abilities cost mana to use and cannot be dodged. Each class learns different abilities as they upgrade.

### Physical Damage

| Ability | Description |
|---------|-------------|
| **Called Shot** | A precise shot aimed at a vital spot. |
| **Double Arrow** | Fires two arrows at a single target. |
| **Earthquake** | Shakes the ground beneath all enemies. |
| **Gun Shot** | A quick firearm blast. |
| **Jump** | A leaping strike from above. |
| **Lance** | A mounted charge with a heavy lance. |
| **Lunge** | A forward spear thrust. |
| **Pierce** | A direct shot aimed at the heart. |
| **Precise Strike** | A calculated hit targeting a weak point. |
| **Punch** | A straightforward punch. |
| **Shield Bash** | Slams a shield into the enemy. |
| **Shield Slam** | A heavy shield blow. |
| **Shrapnel** | Hurls metal fragments at a target. |
| **Slash** | A sweeping weapon slash. |
| **Smash** | A heavy overhead weapon strike. |
| **Sweeping Slash** | A wide circular blade sweep. |
| **Trample** | Charges through the enemy. |
| **Triple Arrow** | Fires three arrows across all enemies. |
| **Valor** | A righteous strike fueled by conviction. |

### Magic Damage

| Ability | Description |
|---------|-------------|
| **Arcane Bolt** | A small bolt of raw arcane energy. |
| **Ballad** | A damaging musical verse. |
| **Black Hole** | Opens a brief gravitational rift. |
| **Blight** | Necrotic pestilence that eats at the target. |
| **Blizzard** | A snowstorm that damages all enemies. |
| **Chain Lightning** | Lightning that arcs between foes. |
| **Corruption** | Dark energy that damages from within. |
| **Death Touch** | Drains the life from a target. |
| **Ember** | A concentrated ball of flame. |
| **Energy Blast** | A scientific explosion of raw energy. |
| **Fire** | A basic fire spell. |
| **Fire Ball** | Hurls a large fireball at one enemy. |
| **Hellfire** | An infernal eruption of demonic fire. |
| **Holy** | A burst of divine light. |
| **Hurricane** | Batters all enemies with violent wind. |
| **Ice** | A focused blast of frost. |
| **Inferno** | Engulfs a target in flames. |
| **Lava** | Molten rock erupts beneath a target. |
| **Lightning** | A bolt of lightning. |
| **Melody** | A damaging sound wave. |
| **Meteor Shower** | Calls down meteors on all enemies. |
| **Mindblast** | A psychic burst that assaults the mind. |
| **Nightfall** | Shrouds a target in consuming darkness. |
| **Oration** | Cutting words that wound like a blade. |
| **Proclamation** | A commanding declaration that harms a foe. |
| **Radiance** | A burst of divine light that sears a target. |
| **Recite** | Spoken words laced with damaging power. |
| **Runic Blast** | A concentrated burst of runic energy. |
| **Servo Strike** | A mechanical strike powered by gears. |
| **Shadow Bolt** | A bolt of shadow energy. |
| **Spring Loaded** | Launches a mechanism that crashes down. |
| **Starfall** | A star plummets from above. |
| **Thunderbolt** | A focused bolt of thunder. |
| **Time Bomb** | A delayed arcane explosion. |
| **Tornado** | A spiraling vortex of wind. |
| **Torrent** | A rushing wave of water. |
| **Tremor** | A magical ground tremor. |
| **Tsunami** | A massive wave crashes into a target. |
| **Vocals** | Sonic damage carried by the voice. |

### Mixed Damage

These abilities deal both physical and magical damage.

| Ability | Description |
|---------|-------------|
| **Anvil** | Drops a conjured anvil on the enemy. |
| **Battle Cry** | A war cry that creates a shockwave. |
| **Dance** | A whirlwind of graceful strikes. |
| **Dragon Breath** | Breathes draconic energy at a target. |
| **Explosion** | A violent detonation of force. |
| **Judgment** | A divine blade of light passes sentence. |
| **Launch** | Leaps into the air and crashes down. |
| **Rune Strike** | A weapon strike empowered by runes. |
| **Runic Strike** | Channels arcane energy through a weapon, striking with physical and magical force. |
| **Shadow Attack** | Leaps from the darkness to strike. |
| **Smite** | A holy strike that punishes the target. |
| **Spirit Attack** | An attack empowered by spiritual energy. |
| **Spirit Bolt** | A bolt of spectral energy. |
| **Telekinesis** | Hurls the target with invisible force. |
| **Thornlash** | Lashes the enemy with conjured thorns. |
| **Transmute** | Alters matter to inflict damage. |

### Healing

| Ability | Description |
|---------|-------------|
| **Cure** | Restores health to one ally. |
| **Elixir** | Administers a healing potion to one ally. |
| **Purify** | Cleanses and heals an ally with purified water. |
| **Regrowth** | Nature-based healing that mends an ally. |
| **Rejuvenate** | Channels ancestral energy to heal an ally. |
| **Restoration** | A powerful restorative spell for one ally. |
| **Sanctuary** | Wraps an ally in a strong healing ward. |
| **Serenade** | A melodic song that soothes and heals one ally. |
| **Soothing Melody** | A calming song that heals the entire party. |

### Ally Buffs

These abilities strengthen your party for a limited time.

| Ability | Description |
|---------|-------------|
| **Aegis** | Raises an ally's resistance to magic. |
| **Ancestral Ward** | Summons an ancestral barrier around an ally. |
| **Arcane Ward** | Inscribes protective runes that shield all allies. |
| **Block** | Braces behind a shield to bolster defense. |
| **Build** | Constructs defensive structures around an ally. |
| **Bulwark** | Raises the defense of all allies. |
| **Consecrate** | Blesses an ally with holy protection. |
| **Dash** | A burst of speed for one ally. |
| **Dragon Ward** | Cloaks an ally in a draconic aura. |
| **Encourage** | Boosts an ally's fighting spirit. |
| **Encore** | Crowd energy drives an ally to hit harder. |
| **Forge** | Reforges weapons to boost the party's attack. |
| **Fortify** | Reinforces an ally's armor. |
| **Glyph of Power** | Inscribes a glyph that boosts an ally's attack. |
| **Guard** | Braces into a defensive stance. |
| **Heavenly Body** | Celestial energy shields the entire party. |
| **Ignite** | Sets an ally's spirit ablaze, amplifying their magical power. |
| **Inscribe** | Writes a protective rune on an ally. |
| **Invisible Wall** | An invisible barrier that blocks incoming attacks. |
| **Inspire** | A motivating speech that greatly boosts an ally's attack. |
| **Lightning Rush** | Charges an ally with electric speed. |
| **Magical Tinkering** | Tinkers with gear to boost an ally's magic power. |
| **Meditate** | Focuses the mind to resist magic. |
| **Mirage** | Creates illusory copies to shield an ally. |
| **Overclock** | Overclocks an ally's systems for extreme speed. |
| **Ovation** | The crowd's energy fuels an ally's attack power. |
| **Phalanx** | Forms a shield wall to protect one ally. |
| **Program Defense** | Runs a defense algorithm with variable results. |
| **Program Offense** | Runs an attack algorithm with variable results. |
| **Protect** | Shields an ally with a protective barrier. |
| **Quick Draw** | Steady hands and sharp reflexes for a burst of speed. |
| **Rally** | Rallies the entire party to move faster. |
| **Reinforce** | Reinforces the entire party's defenses. |
| **Smoke Bomb** | A smoke screen that briefly increases dodge chance. |
| **Time Warp** | Bends time to speed up an ally. |
| **Trap** | Lays defensive traps around an ally. |
| **Wall** | Raises a barrier to shield the entire party. |
| **Warp Speed** | Warps space to dramatically increase an ally's speed. |

### Enemy Debuffs

These abilities weaken enemies for a limited time.

| Ability | Description |
|---------|-------------|
| **Bewilderment** | Illusions that lower an enemy's magic resistance. |
| **Calculate** | Identifies structural weaknesses in the enemy. |
| **Chill** | A touch of frost that slows the enemy. |
| **Confuse** | Scrambles the enemy's magical defenses. |
| **Decay** | Corrodes the enemy's armor. |
| **Decree** | A commanding order that weakens resolve. |
| **Demolish** | Demolishes the enemy's structural defenses. |
| **Demoralize** | Shakes the morale of all enemies, reducing their attack. |
| **Detonate** | An explosion that shatters enemy armor. |
| **Dirge** | A mournful tune that slows an enemy. |
| **Eclipse** | Darkness that strips away magic resistance. |
| **Entangle** | Roots an enemy in place. |
| **Eulogy** | Somber words that weaken an enemy's magical resistance. |
| **Feint** | A fake-out that exposes the enemy's guard. |
| **Frostbite** | Numbing cold that slows an enemy. |
| **Frustrate** | Disrupts the enemy's focus, greatly reducing their attack. |
| **Gravity** | Increased gravity that weighs down an enemy. |
| **Gust** | A fierce gust of wind that staggers and slows the enemy. |
| **Hex** | A curse that saps an enemy's attack power. |
| **Hunters Mark** | Marks an enemy's weak spots for the party. |
| **Invisible Box** | Traps an enemy in an imaginary box, slowing them. |
| **Knockdown** | Knocks an enemy to the ground, slowing them. |
| **Lullaby** | A drowsy melody that slows an enemy. |
| **Proof** | Uses logic to undermine an enemy's magical resistance. |
| **Roar** | A frightening roar that reduces an enemy's attack. |
| **Scorch** | Burns away an enemy's defenses. |
| **Seduce** | A charming presence that lowers an enemy's guard. |
| **Sing** | A vocal enchantment that weakens magic resistance. |
| **Snare** | A trap that slows an enemy. |
| **Time Freeze** | Freezes time around an enemy, dramatically slowing them. |
| **Topple** | A low sweeping kick that sends the enemy crashing down. |
| **Torment** | Psychic torment that weakens an enemy's defenses. |
| **Undertow** | An undercurrent that drags down an enemy's speed. |
| **Vial Toss** | A corrosive vial that weakens an enemy's armor. |

### Utility

| Ability | Description |
|---------|-------------|
| **Dark Pact** | A dark bargain that greatly boosts your own magic power. |
| **Random** | An unpredictable surge of magical energy with random results. |
| **Taunt** | Forces all enemies to attack you for one turn. |

## Party Tips

- You create three warriors at the start. Consider covering different roles rather than tripling up on one class.
- **Damage dealers** end fights faster but need someone to keep them alive.
- **Healers** are invaluable in long fights, but they can't carry a battle alone.
- **Tanks** with Taunt can draw enemy attacks and shield fragile allies.
- **Support** characters who buff allies or debuff enemies can turn the tide in tough encounters.
- Mana does not regenerate during battle, so balance ability use with basic attacks to avoid running dry.
- Abilities cannot be dodged, making them reliable against evasive enemies.

## The Journey

- The journey begins in a tavern and leads through forests, caves, shores, and stranger places.
- After certain victories, each warrior discovers an item that evolves their class. Choose carefully -- each item leads to a different specialization.
- The road branches. Not every playthrough visits the same locations or faces the same enemies.
- Allies may join your cause before the final confrontation.
- There are multiple routes to the end, and the challenges you face depend on the choices you make.

## Building and Running

Requires .NET 8.0 SDK.

```
cd "Echoes of Choice"
dotnet run
```
