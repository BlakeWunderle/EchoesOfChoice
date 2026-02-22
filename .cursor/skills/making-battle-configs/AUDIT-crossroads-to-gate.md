# Audit: Crossroads → Gate Town vs Skills

Battles: **shore**, **beach**, **cemetery_battle**, **box_battle**, **army_battle**, **lab_battle**, **mirror_battle**.

---

## 1. Making-battle-configs

| Requirement | Shore | Beach | Cemetery | Box | Army | Lab | Mirror |
|-------------|-------|-------|----------|-----|------|-----|--------|
| **Count 4–5** | ✓ 5 | ✓ 5 | ✓ 5 | ✓ 5 | ✓ 5 | ✓ 5 | ✓ 5 |
| **Variety (max 3 per type, prefer 2)** | ⚠ 3 sirens (at limit) | ✓ 3 pirate, 1 captain, 1 kraken | ✓ 2+2+1 | ✓ 2+2+1 | ✓ 2+2+1 | ✓ 2+2+1 | ✓ 2+1+1+1 |
| **Progression / level from node** | ✓ lvl 4 | ✓ lvl 4 | ✓ lvl 4 | ✓ lvl 4 | ✓ lvl 4 | ✓ lvl 4 | ✓ lvl 5 |
| **C# / reference types only** | ✓ siren, nymph | ✓ captain, pirate, kraken | ✓ bone_sentry, shade, wraith | ✓ ringmaster, harlequin, chanteuse | ✓ commander, draconian, chaplain | ✓ android, machinist, ironclad | ✓ shadow types |
| **Unique names (no generic labels)** | ✓ Lorelei, Thalassa, Ligeia, Nerida, Coralie | ✓ Greybeard, Flint, Bonny, Redeye, Abyssal | ✓ Mortis, Ravenna, Duskward, Hollow, Joris | ✓ Gaspard, Louis, Erembour, Colombine, Pierrot | ✓ Varro, Theron, Cristole, Sentinel, Vestal | ✓ Deus, Ananiah, Acrid, Unit Seven, Cog | ✓ Vesper, Umbra, Noctis, Dusk, Tenebris |
| **Lead at rear/center** | ✓ Lorelei (9,3) | ✓ Greybeard, Abyssal (9,2)/(9,3) | ✓ Joris (9,3) | ✓ Gaspard (9,3) | ✓ Varro (9,3) | ✓ Acrid (9,3) | ✓ Tenebris (13,4) |
| **Uniqueness across stretch** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ (no type shared) |
| **Grid size (reference)** | ✓ 10×8 | ✓ 10×8 | ✓ 10×8 | ✓ 10×8 | ✓ 10×8 | ✓ 10×8 | ✓ 14×10 |
| **Registered in _config_creators** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

**Optional:** Shore uses 3 sirens; skill says “prefer at most 2”. Acceptable for C# (3 Sirens); could add a fourth type if desired.

---

## 2. Map-terrain-elevation

| Battle | Terrain overrides in get_terrain_overrides | Setting fit |
|--------|-------------------------------------------|------------|
| shore | ✓ Water (blocking), rough sand (cost 2) | ✓ Shore = water edge, sand |
| beach | ✓ Sand (rough), wreckage (blocking) | ✓ Beach = sand, wreckage |
| cemetery_battle | ✓ Tombstones (blocking) | ✓ Cemetery |
| box_battle | ✓ Tents (walls), stage (elevation 1) | ✓ Circus = tents, stage |
| army_battle | ✓ Barricades (blocking) | ✓ Encampment |
| lab_battle | ✓ Walls, destructible crate (15 HP) | ✓ Lab = walls, machinery |
| mirror_battle | ✓ Pillars (blocking), 14×10 | ✓ Arena-style |

Spawn positions are excluded from overrides. Objects on flat or consistent elevation (no crates on cliff lips). **All suffice.**

---

## 3. Story-hooks

| Node | Description matches encounter? | prev/next and branch |
|------|--------------------------------|------------------------|
| crossroads_inn | ✓ Foreshadows three roads (coast, cemetery/carnival, encampment/lab) | ✓ next: shore, cemetery_battle, army_battle; branch_group post_inn for those three |
| shore | ❌ Says “sirens **and pirates**” — shore has no pirates (pirates on beach) | ✓ |
| beach | ✓ “Past the sirens… pirate crew drops down” | ✓ |
| cemetery_battle | ✓ “Dead refuse to stay buried” | ✓ |
| box_battle | ✓ “Ringmaster and his troupe” | ✓ |
| army_battle | ✓ “Commander marshals the forces” | ✓ |
| lab_battle | ❌ Says “head tinker and **guards**” — lab has androids, machinist, ironclad (constructs) | ✓ |
| mirror_battle | ✓ “Shadows and gloom stalk the crossing” | ✓ |
| gate_town | ✓ “Choose which gate to assault” | ✓ |

**Fixes applied:**  
- **Shore:** Description updated so it does not mention pirates (sirens + aquatic only).  
- **Lab:** Description updated to constructs (androids, machinist, ironclad) instead of “head tinker and guards”.

---

## Summary

- **Making-battle-configs:** All seven battles satisfy the skill (C# types, names, progression, uniqueness, grid, registration). Only minor note: shore has 3 sirens (at “max 3”, prefer 2).
- **Map-terrain-elevation:** All seven have thematic terrain; no changes needed.
- **Story-hooks:** Two description mismatches fixed (shore: no pirates; lab: constructs not guards). Flow and branch_group are correct.

Crossroads → gate town **now suffices for all skills** after the two description edits.
