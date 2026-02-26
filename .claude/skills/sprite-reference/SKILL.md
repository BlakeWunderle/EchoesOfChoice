---
name: sprite-reference
description: Regenerate sprite reference docs, contact sheets, and catalogs after sprite changes. Use when sprite assignments change, new palette swaps are added, or you want to visually verify class/enemy sprite mappings.
---

# Sprite Reference

Regenerate all sprite reference outputs so the user can visually verify which sprites are assigned to which classes and enemies.

## What It Generates

1. **`class_sprites.png`** -- Contact sheet of all 54 player classes with male (blue border) and female (pink border) sprites side-by-side, grouped by upgrade tree
2. **`enemy_sprites.png`** -- Contact sheet of all enemies with red borders
3. **`sprite_reference.md`** -- Markdown doc listing every class and enemy with their sprite IDs, stats, abilities, roles, and appearance notes
4. **`catalog_chibi.png`** -- Visual catalog of ALL Chibi sprites (green border = assigned, gray = available)
5. **`catalog_tiny_fantasy.png`** -- Visual catalog of ALL Tiny Fantasy sprites

## Running

From the workspace root, run both tools:

```bash
cd EchoesOfChoiceTactical && python tools/sprite_contact_sheet.py --all
```

```bash
cd EchoesOfChoiceTactical && python tools/generate_sprite_reference.py
```

## Outputs

All outputs are saved to the `EchoesOfChoiceTactical/` project root:

| File | Purpose |
|------|---------|
| `class_sprites.png` | Quick visual audit -- are the right sprites on the right classes? Male + female pairs side-by-side |
| `enemy_sprites.png` | Quick visual audit -- enemy sprite assignments |
| `sprite_reference.md` | Detailed text reference with stats, abilities, roles per class/enemy |
| `catalog_chibi.png` | Full CraftPix Chibi collection -- see what's assigned vs available |
| `catalog_tiny_fantasy.png` | Full Tiny Fantasy collection -- see what's assigned vs available |

## When to Run

- After changing `CLASS_SPRITE_IDS`, `CLASS_SPRITE_IDS_FEMALE`, or `ENEMY_SPRITE_IDS` in `set_sprite_ids.py`
- After creating new palette swaps or synthesizing new sprite packs
- After running `set_sprite_ids.py` to update `.tres` files
- When the user wants to visually verify sprite assignments

## Workflow

1. Run both generation commands above
2. Present the contact sheet PNGs to the user for visual review (use Read tool on the PNG files)
3. If changes are needed, update `set_sprite_ids.py` mappings, re-run `set_sprite_ids.py`, then regenerate

## Key Files

- `tools/sprite_contact_sheet.py` -- Generates class_sprites.png and enemy_sprites.png
- `tools/generate_sprite_reference.py` -- Generates sprite_reference.md, catalog_chibi.png, catalog_tiny_fantasy.png
- `tools/set_sprite_ids.py` -- Source of truth for sprite ID mappings (CLASS_SPRITE_IDS, CLASS_SPRITE_IDS_FEMALE, ENEMY_SPRITE_IDS)
