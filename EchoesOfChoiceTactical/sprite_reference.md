# Sprite Reference — Classes & Enemies

Current sprite assignments with stats, abilities, and visual notes.
Use this alongside the sprite catalog PNGs to evaluate assignments.

## Player Classes (54)

### Squire Tree

**Squire** (Tier 0) — Melee DPS, Support
- Sprite: `chibi_armored_knight_medieval_knight` | Female: `chibi_amazon_warrior_1`
- HP ? | MP 9 | PAtk 21 | PDef 15 | MAtk 9 | MDef 11 | Spd 13 | Mov 4 | Jump 2 | Crit 15%, Dodge 5%
- Abilities: slash, guard
- Upgrades to: duelist, ranger, warden, martial_artist
- Should look like: Young knight in basic plate armor, sword and shield

**Duelist** (Tier 1) — Melee DPS
- Sprite: `chibi_samurai_3` | Female: `chibi_medieval_warrior_girl_duelist`
- HP ? | MP 9 | PAtk 24 | PDef 17 | MAtk 9 | MDef 11 | Spd 15 | Mov 4 | Jump 2 | Crit 20%, Dodge 5%
- Abilities: slash, feint
- Upgrades to: cavalry, dragoon
- Should look like: Elegant swordsman with rapier, precise stance

**Cavalry** (Tier 2) — Mobile DPS, Support, Fast, Mobile
- Sprite: `chibi_medieval_warrior_medieval_commander` | Female: `chibi_amazon_warrior_2_cavalry`
- HP ? | MP 9 | PAtk 28 | PDef 14 | MAtk 9 | MDef 10 | Spd 16 | Mov 7 | Jump 1 | Crit 25%, Dodge 10%
- Abilities: lance, trample, rally
- Should look like: Mounted heavy knight, lance, commander bearing

**Dragoon** (Tier 2) — Melee DPS
- Sprite: `chibi_spartan_knight_warrior_spartan_knight_with_spear` | Female: `chibi_spartan_knight_warrior_spartan_knight_with_spear_f`
- HP ? | MP 12 | PAtk 25 | PDef 17 | MAtk 14 | MDef 11 | Spd 14 | Mov 4 | Jump 3 | Crit 15%, Dodge 5%
- Abilities: jump_ability, dragon_breath, dragon_ward
- Should look like: Armored lancer with spear, knight-like heavy gear

**Ranger** (Tier 1) — Mobile DPS, Mobile
- Sprite: `chibi_archer_1` | Female: `chibi_elf_archer_archer_2_ranger`
- HP ? | MP 9 | PAtk 24 | PDef 17 | MAtk 9 | MDef 11 | Spd 15 | Mov 5 | Jump 3 | Crit 20%, Dodge 5%
- Abilities: pierce, double_arrow
- Upgrades to: mercenary, hunter
- Should look like: Bow-wielding woodsman in green/brown, hooded

**Mercenary** (Tier 2) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_mercenaries_1` | Female: `chibi_mercenaries_1_f`
- HP ? | MP 9 | PAtk 26 | PDef 14 | MAtk 9 | MDef 10 | Spd 16 | Mov 5 | Jump 2 | Crit 30%, Dodge 5%
- Abilities: gun_shot, called_shot, evasion
- Should look like: Hired sword in practical leather armor, weapon for pay

**Hunter** (Tier 2) — Mobile DPS, Mobile
- Sprite: `chibi_archer_3` | Female: `chibi_forest_ranger_1_hunter`
- HP ? | MP 9 | PAtk 24 | PDef 17 | MAtk 9 | MDef 14 | Spd 14 | Mov 5 | Jump 3 | Crit 15%, Dodge 20%
- Abilities: triple_arrow, snare, hunters_mark
- Should look like: Wilderness tracker with bow, earth-toned cloak

**Warden** (Tier 1) — Fighter
- Sprite: `chibi_armored_knight_templar_knight` | Female: `chibi_armored_knight_templar_knight_f`
- HP ? | MP 9 | PAtk 17 | PDef 23 | MAtk 9 | MDef 13 | Spd 12 | Mov 3 | Jump 1 | Crit 5%
- Abilities: block, shield_bash
- Upgrades to: knight, bastion
- Should look like: Heavy defensive fighter, tower shield, fortress stance

**Knight** (Tier 2) — Melee DPS
- Sprite: `chibi_knight_1` | Female: `chibi_valkyrie_2`
- HP ? | MP 9 | PAtk 19 | PDef 26 | MAtk 9 | MDef 15 | Spd 13 | Mov 4 | Jump 2 | Crit 5%
- Abilities: block, valor, second_wind
- Should look like: Fully armored knight in heavy plate, great shield

**Bastion** (Tier 2) — Fighter
- Sprite: `chibi_king_defender_sergeant_very_heavy_armored_frontier_defender` | Female: `chibi_king_defender_sergeant_very_heavy_armored_frontier_defender_f`
- HP ? | MP 9 | PAtk 17 | PDef 28 | MAtk 9 | MDef 15 | Spd 13 | Mov 4 | Jump 2 | Crit 5%
- Abilities: shield_slam, fortify, bulwark
- Should look like: Immovable fortress in maximum plate armor, huge shield

**Martial Artist** (Tier 1) — Melee DPS
- Sprite: `chibi_monk_old_warrior_monk_guy` | Female: `chibi_priest_1_martial_artist`
- HP ? | MP 9 | PAtk 25 | PDef 14 | MAtk 9 | MDef 10 | Spd 15 | Mov 4 | Jump 2 | Crit 20%, Dodge 10%
- Abilities: punch, sweep
- Upgrades to: ninja, monk
- Should look like: Bare-fisted fighter in light robes or wraps

**Ninja** (Tier 2) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_ninja_assassin_white_ninja` | Female: `chibi_ninja_assassin_assassin_guy`
- HP ? | MP 12 | PAtk 27 | PDef 14 | MAtk 9 | MDef 10 | Spd 17 | Mov 5 | Jump 3 | Crit 25%, Dodge 15%
- Abilities: sweeping_slash, dash, smoke_bomb
- Should look like: Dark-clad assassin, masked, throwing stars

**Monk** (Tier 2) — Healer, Melee DPS, Fast
- Sprite: `chibi_spiritual_monk_1` | Female: `chibi_spiritual_monk_1_f`
- HP ? | MP 14 | PAtk 26 | PDef 14 | MAtk 14 | MDef 10 | Spd 16 | Mov 4 | Jump 3 | Crit 25%, Dodge 15%
- Abilities: spirit_attack, precise_strike, chi_mend
- Should look like: Disciplined martial artist in monk robes, prayer beads

### Mage Tree

**Mage** (Tier 0) — Caster
- Sprite: `chibi_magician_1_blonde` | Female: `chibi_magician_1_white`
- HP ? | MP 19 | PAtk 11 | PDef 11 | MAtk 23 | MDef 18 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: arcane_bolt
- Upgrades to: mistweaver, firebrand, stormcaller, acolyte
- Should look like: Classic robed caster with staff, arcane energy

**Mistweaver** (Tier 1) — Caster
- Sprite: `chibi_dark_oracle_1_mistweaver` | Female: `chibi_pyromancer_2_mistweaver`
- HP ? | MP 19 | PAtk 14 | PDef 12 | MAtk 26 | MDef 18 | Spd 12 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: ice, chill
- Upgrades to: cryomancer, hydromancer
- Should look like: Fog/mist mage in dark flowing robes, obscured

**Cryomancer** (Tier 2) — Caster, Terrain
- Sprite: `chibi_shaman_of_thunder_2_cryomancer` | Female: `chibi_winter_witch_1_cryomancer`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 13 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: blizzard, frostbite, ice_wall
- Should look like: Ice mage in blue/white, frost crystals, cold aura

**Hydromancer** (Tier 2) — Caster
- Sprite: `chibi_shaman_of_thunder_2_hydromancer` | Female: `chibi_winter_witch_1_hydromancer`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 12 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: purify, tsunami, undertow
- Should look like: Water mage in blue/aqua robes, flowing water motifs

**Firebrand** (Tier 1) — Caster
- Sprite: `chibi_dark_oracle_1_firebrand` | Female: `chibi_pyromancer_2_firebrand`
- HP ? | MP 19 | PAtk 14 | PDef 10 | MAtk 28 | MDef 18 | Spd 13 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: fire, scorch
- Upgrades to: pyromancer, geomancer
- Should look like: Fire-aspected hybrid fighter, flames and blade

**Pyromancer** (Tier 2) — Caster
- Sprite: `chibi_magician_3_pyromancer` | Female: `chibi_fantasy_warrior_medieval_hooded_girl_pyromancer`
- HP ? | MP 18 | PAtk 9 | PDef 10 | MAtk 28 | MDef 17 | Spd 14 | Mov 4 | Jump 2 | Crit 10%, Dodge 15%
- Abilities: fire_ball, inferno, enrage
- Should look like: Fire mage in red/orange robes, flames dancing

**Geomancer** (Tier 2) — Caster, Terrain
- Sprite: `chibi_magician_3_geomancer` | Female: `chibi_fantasy_warrior_medieval_hooded_girl_geomancer`
- HP ? | MP 16 | PAtk 9 | PDef 14 | MAtk 24 | MDef 17 | Spd 12 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: tremor, lava, wall
- Should look like: Earth mage in brown/green, stone/crystal staff

**Stormcaller** (Tier 1) — Caster
- Sprite: `chibi_dark_oracle_1_stormcaller` | Female: `chibi_pyromancer_2_stormcaller`
- HP ? | MP 19 | PAtk 14 | PDef 10 | MAtk 28 | MDef 18 | Spd 13 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: lightning, gust
- Upgrades to: electromancer, tempest
- Should look like: Storm mage with lightning motifs, crackling staff

**Electromancer** (Tier 2) — Caster
- Sprite: `chibi_magician_undead_magician_3_electromancer` | Female: `chibi_witch_3_electromancer`
- HP ? | MP 18 | PAtk 9 | PDef 10 | MAtk 28 | MDef 17 | Spd 15 | Mov 4 | Jump 2 | Crit 20%, Dodge 5%
- Abilities: thunderbolt, chain_lightning, lightning_rush
- Should look like: Lightning mage with sparking staff, stormy look

**Tempest** (Tier 2) — Caster
- Sprite: `chibi_magician_undead_magician_3_tempest` | Female: `chibi_witch_3_tempest`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 14 | Mov 4 | Jump 2 | Crit 15%, Dodge 20%
- Abilities: hurricane, tornado, knockdown
- Should look like: Storm warrior crackling with energy, wind-swept

**Acolyte** (Tier 1) — Healer, Caster, Support
- Sprite: `chibi_priest_1` | Female: `chibi_ghost_knight_3_acolyte`
- HP ? | MP 19 | PAtk 12 | PDef 13 | MAtk 20 | MDef 23 | Spd 12 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: cure, protect, radiance
- Upgrades to: paladin, priest
- Should look like: Junior healer in simple white/blue robes

**Paladin** (Tier 2) — Melee DPS
- Sprite: `chibi_paladin_1` | Female: `chibi_valkyrie_3_paladin`
- HP ? | MP 16 | PAtk 19 | PDef 22 | MAtk 18 | MDef 18 | Spd 13 | Mov 4 | Jump 2 | Crit 5%
- Abilities: lay_on_hands, smash, smite
- Should look like: Holy warrior in white/gold plate, radiant

**Priest** (Tier 2) — Healer, Caster
- Sprite: `chibi_priest_3` | Female: `chibi_priest_3_f`
- HP ? | MP 20 | PAtk 7 | PDef 13 | MAtk 22 | MDef 21 | Spd 12 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: restoration, heavenly_body, holy
- Should look like: Holy caster in white vestments, divine glow

### Entertainer Tree

**Entertainer** (Tier 0) — Caster, Mobile
- Sprite: `chibi_villager_1` | Female: `chibi_citizen_3`
- HP ? | MP 14 | PAtk 14 | PDef 12 | MAtk 18 | MDef 18 | Spd 15 | Mov 5 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: sing, demoralize
- Upgrades to: bard, dervish, orator, chorister
- Should look like: Humble performer in colorful civilian clothes

**Bard** (Tier 1) — Caster, Support, Fast
- Sprite: `chibi_old_hero_1` | Female: `chibi_women_citizen_women_3_bard`
- HP ? | MP 14 | PAtk 14 | PDef 12 | MAtk 21 | MDef 18 | Spd 16 | Mov 4 | Jump 1 | Crit 5%, Dodge 10%
- Abilities: seduce, melody, encourage
- Upgrades to: warcrier, minstrel
- Should look like: Wandering musician with instrument, traveler's garb

**Warcrier** (Tier 2) — Melee DPS
- Sprite: `chibi_viking_1` | Female: `chibi_valkyrie_3_warcrier`
- HP ? | MP 14 | PAtk 22 | PDef 16 | MAtk 16 | MDef 13 | Spd 14 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: battle_cry, smash, encore
- Should look like: Battle shouter in warrior gear, horned helm, fierce

**Minstrel** (Tier 2) — Caster
- Sprite: `chibi_vampire_hunter_1_minstrel` | Female: `chibi_witch_1_minstrel`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 14 | Mov 4 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: ballad, frustrate, serenade
- Should look like: Traveling musician in road-worn colorful clothes

**Dervish** (Tier 1) — Caster, Fast, Mobile
- Sprite: `chibi_persian_arab_warriors_persian_and_arab_warriors_1` | Female: `chibi_amazon_warrior_3_dervish`
- HP ? | MP 14 | PAtk 14 | PDef 12 | MAtk 21 | MDef 18 | Spd 17 | Mov 5 | Jump 2 | Crit 10%, Dodge 15%
- Abilities: seduce, dance
- Upgrades to: illusionist, mime
- Should look like: Fast whirling dancer with curved blade, flowing garments

**Illusionist** (Tier 2) — Caster, Fast
- Sprite: `chibi_dark_oracle_2` | Female: `chibi_dark_oracle_2_f`
- HP ? | MP 16 | PAtk 14 | PDef 10 | MAtk 26 | MDef 17 | Spd 16 | Mov 4 | Jump 2 | Crit 15%, Dodge 20%
- Abilities: shadow_attack, mirage, bewilderment
- Should look like: Trickster mage in shifting colors, mirrors/smoke

**Mime** (Tier 2) — Caster, Terrain
- Sprite: `chibi_mimic_2_human` | Female: `chibi_mimic_2_human`
- HP ? | MP 14 | PAtk 18 | PDef 16 | MAtk 20 | MDef 13 | Spd 15 | Mov 4 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: invisible_wall, anvil, invisible_box
- Should look like: Silent performer in black/white, masked

**Orator** (Tier 1) — Caster, Support
- Sprite: `chibi_citizen_1` | Female: `chibi_women_citizen_women_1_orator`
- HP ? | MP 14 | PAtk 14 | PDef 12 | MAtk 21 | MDef 18 | Spd 14 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: oration, encourage
- Upgrades to: laureate, elegist
- Should look like: Well-dressed speechmaker, noble civilian attire

**Laureate** (Tier 2) — Caster
- Sprite: `chibi_citizen_2` | Female: `chibi_women_citizen_women_3_laureate`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 13 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: ovation, recite, eulogy
- Should look like: Acclaimed poet in fine noble clothes, quill

**Elegist** (Tier 2) — Caster, Support
- Sprite: `chibi_fantasy_warrior_black_wizard` | Female: `chibi_magician_girl_3`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 13 | Mov 4 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: nightfall, inspire, dirge
- Should look like: Melancholic poet in dark mysterious robes

**Chorister** (Tier 1) — Caster
- Sprite: `chibi_citizen_2_chorister` | Female: `chibi_magician_girl_2_chorister`
- HP ? | MP 14 | PAtk 14 | PDef 12 | MAtk 21 | MDef 18 | Spd 14 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: melody, sing, encore
- Upgrades to: herald, muse
- Should look like: Choir singer in formal religious vestments

**Herald** (Tier 2) — Caster, Support
- Sprite: `chibi_magician_2` | Female: `chibi_winter_witch_2_herald`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 14 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: inspire, proclamation, decree
- Should look like: Magical herald in ceremonial mage robes, glowing sigils

**Muse** (Tier 2) — Caster
- Sprite: `chibi_villager_2` | Female: `chibi_magician_girl_1`
- HP ? | MP 18 | PAtk 9 | PDef 12 | MAtk 24 | MDef 17 | Spd 14 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: lullaby, vocals, soothing_melody
- Should look like: Inspiring artist in bright creative clothes

### Scholar Tree

**Scholar** (Tier 0) — Caster
- Sprite: `chibi_old_hero_2` | Female: `chibi_dark_elves_1_scholar`
- HP ? | MP 14 | PAtk 7 | PDef 12 | MAtk 20 | MDef 20 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: proof, energy_blast
- Upgrades to: artificer, tinker, cosmologist, arithmancer
- Should look like: Robed academic with books, spectacles, aged wisdom

**Artificer** (Tier 1) — Caster
- Sprite: `chibi_technomage_1` | Female: `chibi_winter_witch_3_artificer`
- HP ? | MP 14 | PAtk 12 | PDef 11 | MAtk 22 | MDef 18 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: energy_blast, magical_tinkering
- Upgrades to: alchemist, thaumaturge
- Should look like: Magical crafter with tools, mechanical parts

**Alchemist** (Tier 2) — Caster
- Sprite: `chibi_bloody_alchemist_1` | Female: `chibi_dark_elves_3_alchemist`
- HP ? | MP 16 | PAtk 16 | PDef 16 | MAtk 22 | MDef 17 | Spd 13 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: transmute, vial_toss, elixir
- Should look like: Potion maker with vials, stained apron, goggles

**Thaumaturge** (Tier 2) — Caster
- Sprite: `chibi_dark_oracle_3` | Female: `chibi_dark_oracle_3_f`
- HP ? | MP 16 | PAtk 14 | PDef 17 | MAtk 22 | MDef 20 | Spd 13 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: runic_strike, arcane_ward, runic_blast
- Should look like: Advanced mage in ornate robes, powerful aura

**Tinker** (Tier 1) — Caster
- Sprite: `chibi_gnome_1` | Female: `chibi_women_citizen_women_2_tinker`
- HP ? | MP 14 | PAtk 9 | PDef 11 | MAtk 20 | MDef 18 | Spd 11 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: trap, spring_loaded
- Upgrades to: bombardier, siegemaster
- Should look like: Small inventor with gadgets, goggles, wrench

**Bombardier** (Tier 2) — Caster
- Sprite: `chibi_mercenaries_2` | Female: `chibi_vampire_hunter_3_bombardier`
- HP ? | MP 14 | PAtk 20 | PDef 15 | MAtk 21 | MDef 17 | Spd 13 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: shrapnel, explosion, detonate
- Should look like: Explosives expert with bombs, heavy pack

**Siegemaster** (Tier 2) — Melee DPS
- Sprite: `chibi_king_defender_sergeant_medieval_sergeant` | Female: `chibi_valkyrie_1_siegemaster`
- HP ? | MP 14 | PAtk 19 | PDef 22 | MAtk 16 | MDef 17 | Spd 12 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: earthquake, build, demolish
- Should look like: Heavy military engineer, fortification gear

**Cosmologist** (Tier 1) — Caster
- Sprite: `chibi_dark_oracle_3` | Female: `chibi_dark_oracle_3_cosmologist_f`
- HP ? | MP 14 | PAtk 7 | PDef 12 | MAtk 20 | MDef 20 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: time_warp, black_hole, gravity
- Upgrades to: astronomer, chronomancer
- Should look like: Cosmic scholar with dimensional/space motifs

**Astronomer** (Tier 2) — Caster
- Sprite: `chibi_old_hero_3` | Female: `chibi_old_hero_3_f`
- HP ? | MP 18 | PAtk 7 | PDef 13 | MAtk 26 | MDef 19 | Spd 13 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: starfall, meteor_shower, eclipse
- Should look like: Stargazer in robes with telescope, celestial patterns

**Chronomancer** (Tier 2) — Caster
- Sprite: `chibi_time_keeper_2` | Female: `chibi_fallen_angel_s_1_chronomancer`
- HP ? | MP 18 | PAtk 7 | PDef 13 | MAtk 24 | MDef 19 | Spd 15 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: warp_speed, time_bomb, time_freeze
- Should look like: Time mage with clock/hourglass motifs, aged look

**Arithmancer** (Tier 1) — Caster
- Sprite: `chibi_cursed_alchemist_1` | Female: `chibi_cursed_alchemist_1_f`
- HP ? | MP 14 | PAtk 7 | PDef 12 | MAtk 20 | MDef 20 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: recite, calculate
- Upgrades to: automaton, technomancer
- Should look like: Math mage with glowing equations, analytical look

**Automaton** (Tier 2) — Melee DPS
- Sprite: `chibi_golem_1` | Female: `chibi_golem_1_f`
- HP ? | MP 14 | PAtk 20 | PDef 17 | MAtk 16 | MDef 15 | Spd 13 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: servo_strike, program_defense, overclock
- Should look like: Golem/construct body, mechanical, gem core

**Technomancer** (Tier 2) — Melee DPS
- Sprite: `chibi_technomage_2` | Female: `chibi_technomage_2_f`
- HP ? | MP 14 | PAtk 18 | PDef 17 | MAtk 18 | MDef 15 | Spd 13 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: random_ability, program_defense, program_offense
- Should look like: Tech-magic hybrid in steampunk-ish gear

### Royal

**Prince** (Tier 0) — Fighter
- Sprite: `chibi_armored_knight_medieval_knight_royal` | Female: `chibi_amazon_warrior_1_royal`
- HP ? | MP 10 | PAtk 12 | PDef 11 | MAtk 12 | MDef 12 | Spd 11 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: royal_strike
- Should look like: Armored royal with crown, regal bearing, gold/blue

**Princess** (Tier 0) — Fighter
- Sprite: `chibi_amazon_warrior_1_royal` | Female: `chibi_amazon_warrior_1_royal`
- HP ? | MP 10 | PAtk 12 | PDef 11 | MAtk 12 | MDef 12 | Spd 11 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: royal_strike
- Should look like: Warrior princess with tiara, elegant yet battle-ready

## Enemies (78)

### Goblinoid

**Goblin** (Lv ?) — Mobile
- Sprite: `chibi_goblin_1`
- HP ? | MP 0 | PAtk 17 | PDef 6 | MAtk 2 | MDef 4 | Spd 14 | Mov 5 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: stab
- Should look like: Small green-skinned humanoid with crude dagger

**Goblin Archer** (Lv ?) — Melee DPS
- Sprite: `chibi_goblin_3`
- HP ? | MP 4 | PAtk 20 | PDef 5 | MAtk 3 | MDef 4 | Spd 13 | Mov 4 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: arrow_shot
- Should look like: Goblin with shortbow, sneaky posture

**Goblin Shaman** (Lv ?) — Healer, Support
- Sprite: `chibi_orc_shaman_shamans_1`
- HP ? | MP 10 | PAtk 4 | PDef 5 | MAtk 16 | MDef 8 | Spd 10 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: heal_chant, bolster, snare
- Should look like: Goblin with staff, tribal paint, magic glow

**Hobgoblin** (Lv ?) — Melee DPS
- Sprite: `chibi_orc_ogre_goblin_orc`
- HP ? | MP 6 | PAtk 21 | PDef 12 | MAtk 4 | MDef 8 | Spd 9 | Mov 4 | Jump 1 | Crit 5%
- Abilities: cleave
- Should look like: Larger, more disciplined goblin in better armor

### Beasts & Prowlers

**Wolf** (Lv ?) — Mobile DPS, Mobile
- Sprite: `chibi_gnoll_1`
- HP ? | MP 0 | PAtk 18 | PDef 6 | MAtk 2 | MDef 4 | Spd 15 | Mov 5 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: bite
- Should look like: Gray/black wolf, snarling, four-legged canine

**Shadow Hound** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_skeleton_hunter_1`
- HP ? | MP 0 | PAtk 46 | PDef 11 | MAtk 6 | MDef 8 | Spd 19 | Mov 5 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: lunge, terrify
- Should look like: Spectral dark wolf, glowing eyes, shadowy

**Wild Boar** (Lv ?) — Melee DPS
- Sprite: `chibi_minotaur_1`
- HP ? | MP 4 | PAtk 19 | PDef 14 | MAtk 2 | MDef 6 | Spd 7 | Mov 3 | Jump 1 | Crit 5%
- Abilities: gore
- Should look like: Tusked charging beast, bristly, bulky

**Bear** (Lv ?) — Melee DPS
- Sprite: `chibi_forest_guardian_1`
- HP ? | MP 0 | PAtk 18 | PDef 14 | MAtk 2 | MDef 8 | Spd 8 | Mov 3 | Jump 1 | Crit 5%
- Abilities: slash, cleave
- Should look like: Large brown/black bear, standing, claws bared

**Bear Cub** (Lv ?) — Fighter
- Sprite: `chibi_forest_guardian_2`
- HP ? | MP 0 | PAtk 17 | PDef 8 | MAtk 2 | MDef 5 | Spd 12 | Mov 4 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: slash
- Should look like: Smaller bear, less threatening but still clawed

**Night Prowler** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_dark_elves_1`
- HP ? | MP 8 | PAtk 47 | PDef 10 | MAtk 6 | MDef 8 | Spd 18 | Mov 5 | Jump 3 | Crit 15%, Dodge 15%
- Abilities: backstab, smoke_bomb
- Should look like: Stealthy dark humanoid predator, glowing eyes

**Dusk Prowler** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_dark_elves_2`
- HP ? | MP 10 | PAtk 65 | PDef 12 | MAtk 8 | MDef 11 | Spd 23 | Mov 5 | Jump 3 | Crit 15%, Dodge 15%
- Abilities: backstab, smoke_bomb
- Should look like: Twilight-hunting shadowy figure

**Dread Stalker** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_dark_elves_3`
- HP ? | MP 16 | PAtk 69 | PDef 28 | MAtk 14 | MDef 21 | Spd 26 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: rend, terrify
- Should look like: Elite dark hunter, menacing presence

**Cave Bat** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_orc_archer_1`
- HP ? | MP 6 | PAtk 48 | PDef 5 | MAtk 6 | MDef 9 | Spd 19 | Mov 5 | Jump 3 | Crit 10%, Dodge 15%
- Abilities: bite, screech
- Should look like: Winged cave-dwelling creature

### City Thugs

**Thug** (Lv ?) — Fighter
- Sprite: `chibi_archer_barbarian_mage_barbarian_warrior`
- HP ? | MP 4 | PAtk 12 | PDef 10 | MAtk 4 | MDef 6 | Spd 10 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: slash
- Should look like: Rough street criminal with club or knife

**Street Tough** (Lv ?) — Fighter
- Sprite: `chibi_4_characters_medieval_thug`
- HP ? | MP 6 | PAtk 14 | PDef 8 | MAtk 4 | MDef 8 | Spd 9 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: slash, stun_strike
- Should look like: Muscular gang enforcer, scarred, brass knuckles

**Hex Peddler** (Lv ?) — Caster
- Sprite: `chibi_skeleton_nobleman_1`
- HP ? | MP 12 | PAtk 6 | PDef 7 | MAtk 11 | MDef 10 | Spd 11 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: hex_bolt, curse
- Should look like: Shady dark merchant selling cursed goods

### Guards & Military

**Royal Guard** (Lv ?) — Support
- Sprite: `chibi_knight_2`
- HP ? | MP 6 | PAtk 12 | PDef 10 | MAtk 6 | MDef 9 | Spd 9 | Mov 4 | Jump 2 | Crit 5%
- Abilities: slash, guard
- Should look like: Royal guard in official knight armor

**Elite Royal Guard** (Lv ?) — Melee DPS, Support, Fast
- Sprite: `chibi_knight_3`
- HP ? | MP 15 | PAtk 24 | PDef 18 | MAtk 12 | MDef 16 | Spd 30 | Mov 4 | Jump 2 | Crit 5%
- Abilities: slash, guard
- Should look like: Elite royal guard, finer armor with insignia

**Court Mage** (Lv ?) — Caster
- Sprite: `chibi_magician_1_royal`
- HP ? | MP 13 | PAtk 10 | PDef 9 | MAtk 14 | MDef 12 | Spd 10 | Mov 3 | Jump 1 | Crit 5%
- Abilities: arcane_bolt
- Should look like: Royal court mage in official blue robes

**Elite Court Mage** (Lv ?) — Caster, Fast
- Sprite: `chibi_magician_demon_magician_2`
- HP ? | MP 32 | PAtk 20 | PDef 16 | MAtk 28 | MDef 22 | Spd 30 | Mov 3 | Jump 1 | Crit 5%
- Abilities: arcane_bolt
- Should look like: Senior court mage with powerful staff

**Royal Advisor** (Lv ?) — Caster
- Sprite: `chibi_old_hero_2_royal`
- HP ? | MP 10 | PAtk 6 | PDef 14 | MAtk 26 | MDef 12 | Spd 9 | Mov 3 | Jump 1 | Crit 5%
- Abilities: proof, energy_blast
- Should look like: Royal advisor in purple scholarly robes

**Herald Guard** (Lv ?) — Mobile
- Sprite: `chibi_villager_3`
- HP ? | MP 10 | PAtk 10 | PDef 9 | MAtk 11 | MDef 12 | Spd 12 | Mov 5 | Jump 2 | Crit 5%
- Abilities: sing, demoralize
- Should look like: Court herald/performer in civilian garb

**Commander** (Lv ?) — Melee DPS, Support, Fast
- Sprite: `chibi_warrior_heavy_armored_defender_knight`
- HP ? | MP 22 | PAtk 31 | PDef 22 | MAtk 11 | MDef 20 | Spd 19 | Mov 4 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: bulwark, shield_slam, inspire
- Should look like: Heavily armored military commander, gold trim

**Captain** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_skeleton_pirate_captain_1`
- HP ? | MP 45 | PAtk 37 | PDef 21 | MAtk 17 | MDef 15 | Spd 19 | Mov 4 | Jump 1 | Crit 15%, Dodge 5%
- Abilities: slash, smash
- Should look like: Pirate captain with tricorne, sword, coat

**Pirate** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_ghost_pirate_1`
- HP ? | MP 34 | PAtk 31 | PDef 21 | MAtk 17 | MDef 15 | Spd 20 | Mov 4 | Jump 1 | Crit 10%, Dodge 10%
- Abilities: slash, backstab
- Should look like: Seafaring raider with cutlass, bandana

### Imps & Small Demons

**Imp** (Lv ?) — Caster
- Sprite: `chibi_goblin_2`
- HP ? | MP 12 | PAtk 5 | PDef 6 | MAtk 28 | MDef 12 | Spd 14 | Mov 4 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: fire_spark
- Should look like: Tiny red-skinned demon, mischievous, wings

**Fiendling** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_blood_demon_1`
- HP ? | MP 6 | PAtk 46 | PDef 14 | MAtk 9 | MDef 11 | Spd 16 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: claw
- Should look like: Small blood-red demon, claws and fangs

**Fire Spirit** (Lv ?) — Caster
- Sprite: `chibi_blood_demon_2`
- HP ? | MP 17 | PAtk 9 | PDef 14 | MAtk 35 | MDef 20 | Spd 11 | Mov 3 | Jump 1 | Crit 5%
- Abilities: flame_wave, fire_spark, lava
- Should look like: Floating fire creature, ember body

### Nature Spirits

**Pixie** (Lv ?) — Caster, Fast, Mobile
- Sprite: `chibi_elemental_spirits_1`
- HP ? | MP 14 | PAtk 4 | PDef 4 | MAtk 36 | MDef 13 | Spd 18 | Mov 6 | Jump 3 | Crit 5%, Dodge 20%
- Abilities: dust_cloud, spirit_touch
- Should look like: Tiny glowing fairy with wings, nature magic

**Sprite** (Lv ?) — Caster, Fast, Mobile
- Sprite: `chibi_elemental_spirits_2`
- HP ? | MP 14 | PAtk 7 | PDef 5 | MAtk 35 | MDef 14 | Spd 16 | Mov 5 | Jump 3 | Crit 5%, Dodge 15%
- Abilities: bewitch, spirit_touch
- Should look like: Small forest spirit, leafy, green glow

**Wisp** (Lv ?) — Caster, Fast, Mobile
- Sprite: `chibi_elemental_spirits_3`
- HP ? | MP 12 | PAtk 3 | PDef 4 | MAtk 35 | MDef 14 | Spd 17 | Mov 5 | Jump 3 | Crit 5%, Dodge 15%
- Abilities: spirit_touch
- Should look like: Floating ball of ghostly light

### Nature / Fey Humanoids

**Satyr** (Lv ?) — Melee DPS
- Sprite: `chibi_satyr_1`
- HP ? | MP 12 | PAtk 43 | PDef 16 | MAtk 8 | MDef 10 | Spd 14 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: ram, battle_cry
- Should look like: Goat-legged fey with pipes, forest dweller

**Nymph** (Lv ?) — Caster
- Sprite: `chibi_elf_archer_archer_1`
- HP ? | MP 20 | PAtk 27 | PDef 8 | MAtk 38 | MDef 16 | Spd 14 | Mov 3 | Jump 1 | Crit 5%, Dodge 10%
- Abilities: natures_embrace, bewitch, undertow, spirit_touch
- Should look like: Beautiful nature spirit, bow, graceful

**Tide Nymph** (Lv ?) — Caster, Fast
- Sprite: `chibi_elf_archer_archer_2`
- HP ? | MP 22 | PAtk 31 | PDef 10 | MAtk 35 | MDef 20 | Spd 18 | Mov 3 | Jump 1 | Crit 5%, Dodge 10%
- Abilities: natures_embrace, bewitch, undertow, spirit_touch
- Should look like: Ocean variant nymph, blue/aqua, water motifs

**Siren** (Lv ?) — Caster, Fast
- Sprite: `chibi_medusa_1`
- HP ? | MP 32 | PAtk 13 | PDef 14 | MAtk 32 | MDef 22 | Spd 21 | Mov 3 | Jump 1 | Crit 5%, Dodge 10%
- Abilities: arcane_bolt, undertow
- Should look like: Aquatic enchantress with serpentine features

**Chanteuse** (Lv ?) — Caster, Fast, Mobile
- Sprite: `chibi_elf_archer_archer_3`
- HP ? | MP 30 | PAtk 12 | PDef 16 | MAtk 29 | MDef 16 | Spd 21 | Mov 5 | Jump 2 | Crit 10%, Dodge 15%
- Abilities: vocals, soothing_melody, sing
- Should look like: Fey performer with magical voice

### Spectral

**Shade** (Lv ?) — Caster
- Sprite: `chibi_ghost_knight_1`
- HP ? | MP 14 | PAtk 5 | PDef 6 | MAtk 35 | MDef 16 | Spd 14 | Mov 4 | Jump 2 | Crit 5%, Dodge 15%
- Abilities: drain, wither
- Should look like: Dark ghostly figure, floating, drain magic

**Dire Shade** (Lv ?) — Caster, Fast
- Sprite: `chibi_ghost_knight_2`
- HP ? | MP 14 | PAtk 9 | PDef 14 | MAtk 44 | MDef 22 | Spd 23 | Mov 4 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: drain, wither
- Should look like: Larger more dangerous dark ghost

**Wraith** (Lv ?) — Caster
- Sprite: `chibi_ghost_knight_3`
- HP ? | MP 20 | PAtk 8 | PDef 10 | MAtk 38 | MDef 21 | Spd 13 | Mov 3 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: soul_siphon, wither
- Should look like: Spectral undead in tattered armor, glowing

**Grave Wraith** (Lv ?) — Caster, Fast
- Sprite: `chibi_ghost_knight_2_ghost_knight_1`
- HP ? | MP 22 | PAtk 12 | PDef 15 | MAtk 47 | MDef 25 | Spd 18 | Mov 3 | Jump 2 | Crit 5%, Dodge 10%
- Abilities: soul_siphon, wither
- Should look like: Cemetery-bound wraith, gravestones

**Dread Wraith** (Lv ?) — Caster, Fast
- Sprite: `chibi_ghost_knight_2_ghost_knight_2`
- HP ? | MP 16 | PAtk 14 | PDef 18 | MAtk 46 | MDef 26 | Spd 25 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: soul_siphon, wither
- Should look like: Powerful wraith with fear aura

**Specter** (Lv ?) — Caster, Fast
- Sprite: `chibi_ghost_knight_2_ghost_knight_3`
- HP ? | MP 18 | PAtk 6 | PDef 8 | MAtk 30 | MDef 18 | Spd 18 | Mov 4 | Jump 2 | Crit 5%, Dodge 15%
- Abilities: ecto_blast
- Should look like: Translucent floating ghost, chilling presence

**Phantom Prowler** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_ghost_pirate_2`
- HP ? | MP 11 | PAtk 57 | PDef 15 | MAtk 6 | MDef 15 | Spd 26 | Mov 5 | Jump 3 | Crit 15%, Dodge 15%
- Abilities: backstab, smoke_bomb
- Should look like: Ghost that hunts the living, predatory

**Mirror Stalker** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_ghost_pirate_3`
- HP ? | MP 13 | PAtk 69 | PDef 24 | MAtk 12 | MDef 18 | Spd 20 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: rend, terrify
- Should look like: Reflective phantom, mirrors, illusions

### Undead Casters

**Witch** (Lv ?) — Caster
- Sprite: `chibi_skeleton_witch_1`
- HP ? | MP 23 | PAtk 9 | PDef 10 | MAtk 42 | MDef 21 | Spd 14 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: shadow_bolt, bewitch, curse
- Should look like: Skeleton witch with staff, dark magic

**Elder Witch** (Lv ?) — Caster, Fast
- Sprite: `chibi_skeleton_witch_2`
- HP ? | MP 27 | PAtk 14 | PDef 15 | MAtk 46 | MDef 26 | Spd 22 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: shadow_bolt, bewitch, curse
- Should look like: Powerful senior witch, more ornate

**Necromancer** (Lv ?) — Caster, Fast
- Sprite: `chibi_necromancer_shadow_necromancer_of_the_shadow_1`
- HP ? | MP 27 | PAtk 14 | PDef 12 | MAtk 39 | MDef 18 | Spd 19 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: death_touch, curse
- Should look like: Death mage in black robes, skulls, undead minions

**Warlock** (Lv ?) — Caster, Fast
- Sprite: `chibi_magician_undead_magician_2`
- HP ? | MP 30 | PAtk 22 | PDef 15 | MAtk 52 | MDef 18 | Spd 22 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: shadow_bolt
- Should look like: Dark pact caster, demonic symbols

**Psion** (Lv ?) — Caster, Fast
- Sprite: `chibi_magician_undead_magician_3`
- HP ? | MP 27 | PAtk 14 | PDef 12 | MAtk 47 | MDef 21 | Spd 25 | Mov 4 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: mind_blast
- Should look like: Psychic undead mage, mind powers, eerie glow

**Chaplain** (Lv ?) — Healer, Melee DPS, Fast
- Sprite: `chibi_orc_shaman_shamans_2`
- HP ? | MP 30 | PAtk 26 | PDef 17 | MAtk 24 | MDef 22 | Spd 16 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: restoration, smash, purify
- Should look like: Undead holy figure, corrupted vestments

**Shaman** (Lv ?) — Caster, Fast
- Sprite: `chibi_orc_shaman_shamans_3`
- HP ? | MP 27 | PAtk 30 | PDef 25 | MAtk 48 | MDef 21 | Spd 19 | Mov 3 | Jump 2 | Crit 5%, Dodge 5%
- Abilities: spirit_bolt
- Should look like: Nature-magic undead, tribal, bone totems

**Runewright** (Lv ?) — Caster, Fast
- Sprite: `chibi_skeleton_sorcerer_1`
- HP ? | MP 14 | PAtk 10 | PDef 21 | MAtk 49 | MDef 18 | Spd 22 | Mov 3 | Jump 1 | Crit 5%
- Abilities: proof, energy_blast
- Should look like: Undead rune caster, glowing rune symbols

### Undead Melee

**Zombie** (Lv ?) — Melee DPS
- Sprite: `chibi_zombie_villager_1`
- HP ? | MP 5 | PAtk 38 | PDef 14 | MAtk 4 | MDef 10 | Spd 10 | Mov 2 | Jump 1 | Crit 5%
- Abilities: slash, wither
- Should look like: Shambling undead villager, torn clothes

**Bone Sentry** (Lv ?) — Melee DPS
- Sprite: `chibi_skeleton_warrior_1`
- HP ? | MP 6 | PAtk 43 | PDef 21 | MAtk 3 | MDef 13 | Spd 9 | Mov 3 | Jump 1 | Crit 5%
- Abilities: shield_bash, stun_strike
- Should look like: Skeletal guard with sword and shield

**Cursed Peddler** (Lv ?) — Caster, Fast
- Sprite: `chibi_skeleton_nobleman_2`
- HP ? | MP 23 | PAtk 12 | PDef 11 | MAtk 44 | MDef 19 | Spd 19 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: hex_bolt, curse
- Should look like: Undead merchant, rotting noble clothes

### Wyrmlings

**Fire Wyrmling** (Lv ?) — Caster, Fast
- Sprite: `chibi_demon_archer_archer_1`
- HP ? | MP 22 | PAtk 20 | PDef 19 | MAtk 48 | MDef 22 | Spd 16 | Mov 3 | Jump 1 | Crit 10%
- Abilities: fire_breath, fire_spark, lava
- Should look like: Young fire dragon, small, flaming breath

**Frost Wyrmling** (Lv ?) — Caster, Terrain
- Sprite: `chibi_demon_archer_archer_2`
- HP ? | MP 22 | PAtk 20 | PDef 22 | MAtk 46 | MDef 26 | Spd 15 | Mov 3 | Jump 1 | Crit 5%
- Abilities: ice_breath, ice_wall
- Should look like: Young ice dragon, icy blue, frost breath

**Gloom Stalker** (Lv ?) — Melee DPS
- Sprite: `chibi_demon_archer_archer_3`
- HP ? | MP 11 | PAtk 49 | PDef 19 | MAtk 9 | MDef 14 | Spd 14 | Mov 4 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: rend, terrify
- Should look like: Dark dragon hatchling, shadow wings

### Constructs

**Arc Golem** (Lv ?) — Caster
- Sprite: `chibi_golem_2`
- HP ? | MP 25 | PAtk 8 | PDef 14 | MAtk 34 | MDef 15 | Spd 15 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: chain_lightning, energy_blast
- Should look like: Electrical construct, sparking, stone/metal body

**Ironclad** (Lv ?) — Melee DPS
- Sprite: `chibi_golem_3`
- HP ? | MP 22 | PAtk 31 | PDef 18 | MAtk 16 | MDef 26 | Spd 15 | Mov 3 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: smash, fortify, bulwark
- Should look like: Heavy iron golem, massive, slow, powerful

**Android** (Lv ?) — Caster, Terrain, Fast
- Sprite: `chibi_frost_knight_3`
- HP ? | MP 28 | PAtk 29 | PDef 15 | MAtk 31 | MDef 18 | Spd 22 | Mov 4 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: chain_lightning, wall, overclock
- Should look like: Mechanical humanoid, artificial, precise

**Machinist** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_skeleton_crusader_1`
- HP ? | MP 22 | PAtk 29 | PDef 18 | MAtk 20 | MDef 18 | Spd 21 | Mov 4 | Jump 1 | Crit 5%, Dodge 5%
- Abilities: demolish, fortify, servo_strike
- Should look like: Animated machine operator, gears and tools

### Demons

**Hellion** (Lv ?) — Melee DPS
- Sprite: `chibi_blood_demon_3`
- HP ? | MP 25 | PAtk 48 | PDef 19 | MAtk 38 | MDef 19 | Spd 15 | Mov 3 | Jump 1 | Crit 10%
- Abilities: hellfire, demon_strike, lava
- Should look like: Lesser demon, horns, fire, aggressive

**Arch Hellion** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_devil_hell_knight_succubus_hell_knight`
- HP ? | MP 27 | PAtk 68 | PDef 24 | MAtk 47 | MDef 21 | Spd 22 | Mov 3 | Jump 1 | Crit 10%
- Abilities: hellfire, demon_strike, lava
- Should look like: Greater demon in dark armor, massive presence

**Draconian** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_demon_of_darkness_demons_of_darkness_1`
- HP ? | MP 25 | PAtk 29 | PDef 17 | MAtk 29 | MDef 20 | Spd 22 | Mov 4 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: precise_strike, chain_lightning, bulwark
- Should look like: Dragon-descended humanoid fiend, scales and wings

**Ringmaster** (Lv ?) — Melee DPS, Fast
- Sprite: `chibi_halloween_skull_knight`
- HP ? | MP 22 | PAtk 36 | PDef 22 | MAtk 20 | MDef 18 | Spd 18 | Mov 3 | Jump 1 | Crit 10%, Dodge 5%
- Abilities: smash, demoralize
- Should look like: Carnival demon, skull-faced, whip and tricks

**Harlequin** (Lv ?) — Mobile DPS, Fast, Mobile
- Sprite: `chibi_halloween_pumpkin_head_guy`
- HP ? | MP 28 | PAtk 29 | PDef 16 | MAtk 26 | MDef 18 | Spd 21 | Mov 5 | Jump 3 | Crit 10%, Dodge 15%
- Abilities: smash, bewilderment, dash
- Should look like: Trickster demon with pumpkin head, chaotic

### Watchers & Moths

**Watcher Lord** (Lv ?) — Caster, Fast
- Sprite: `chibi_medusa_3`
- HP ? | MP 32 | PAtk 27 | PDef 22 | MAtk 42 | MDef 30 | Spd 23 | Mov 3 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: void_pulse
- Should look like: Multi-eyed observer entity, tentacles

**Void Watcher** (Lv ?) — Caster, Fast
- Sprite: `chibi_medusa_2`
- HP ? | MP 26 | PAtk 21 | PDef 18 | MAtk 35 | MDef 24 | Spd 17 | Mov 3 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: void_pulse
- Should look like: Cosmic watching entity, dark void motifs

**Seraph** (Lv ?) — Caster, Fast
- Sprite: `chibi_fallen_angel_s_1`
- HP ? | MP 30 | PAtk 34 | PDef 24 | MAtk 47 | MDef 21 | Spd 22 | Mov 3 | Jump 2 | Crit 10%, Dodge 5%
- Abilities: judgment
- Should look like: Corrupted angel with tattered wings

**Dusk Moth** (Lv ?) — Caster, Fast
- Sprite: `chibi_fallen_angel_s_3`
- HP ? | MP 14 | PAtk 6 | PDef 6 | MAtk 38 | MDef 16 | Spd 17 | Mov 4 | Jump 3 | Crit 5%, Dodge 15%
- Abilities: wing_dust, spirit_touch
- Should look like: Large moth-like creature of twilight

**Twilight Moth** (Lv ?) — Caster, Fast
- Sprite: `chibi_fallen_angel_s_2`
- HP ? | MP 16 | PAtk 8 | PDef 10 | MAtk 50 | MDef 22 | Spd 22 | Mov 4 | Jump 3 | Crit 5%, Dodge 15%
- Abilities: wing_dust, spirit_touch
- Should look like: Evening moth creature, luminous wings

### True Elementals (Prog 7)

**Fire Elemental** (Lv ?) — Caster, Fast
- Sprite: `chibi_elemental_s_1`
- HP ? | MP 50 | PAtk 20 | PDef 18 | MAtk 48 | MDef 25 | Spd 28 | Mov 3 | Jump 1 | Crit 10%
- Abilities: inferno, flame_wave
- Should look like: Pure fire entity, humanoid flame shape

**Water Elemental** (Lv ?) — Caster, Fast
- Sprite: `chibi_elemental_s_2`
- HP ? | MP 55 | PAtk 16 | PDef 25 | MAtk 36 | MDef 32 | Spd 23 | Mov 3 | Jump 1 | Crit 5%
- Abilities: tsunami, undertow
- Should look like: Pure water entity, flowing liquid form

**Air Elemental** (Lv ?) — Caster, Fast
- Sprite: `chibi_elemental_s_3`
- HP ? | MP 55 | PAtk 16 | PDef 14 | MAtk 40 | MDef 22 | Spd 32 | Mov 4 | Jump 2 | Crit 10%, Dodge 10%
- Abilities: hurricane, tornado
- Should look like: Pure air entity, swirling wind/cloud form

**Earth Elemental** (Lv ?) — Melee DPS, Terrain, Fast
- Sprite: `chibi_forest_guardian_3`
- HP ? | MP 35 | PAtk 40 | PDef 32 | MAtk 24 | MDef 22 | Spd 21 | Mov 2 | Jump 1 | Crit 5%
- Abilities: earth_stomp, wall
- Should look like: Pure earth entity, rock/crystal humanoid

### Bosses

**Kraken** (Lv ?) — Melee DPS
- Sprite: `chibi_orc_ogre_goblin_ogre`
- HP ? | MP 38 | PAtk 31 | PDef 21 | MAtk 26 | MDef 18 | Spd 14 | Mov 3 | Jump 1 | Crit 10%
- Abilities: undertow, tsunami
- Should look like: Massive tentacled sea beast, boss-sized

**The Stranger** (Lv ?) — Caster, Fast
- Sprite: `chibi_black_reaper_1`
- HP ? | MP 70 | PAtk 32 | PDef 22 | MAtk 56 | MDef 40 | Spd 34 | Mov 3 | Jump 2 | Crit 15%, Dodge 5%
- Abilities: arcane_surge
- Should look like: Mysterious dark reaper figure, final boss, ominous
