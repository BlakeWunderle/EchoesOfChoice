# Story Hooks Reference

## Checklist

- [ ] **Hook types**: For each transition A → B, the reason is in A’s description (rumor, road, event) or B’s description (what the party finds).
- [ ] **Reason in A or B**: No “dead” transition; every next_node is motivated.
- [ ] **branch_group**: Mutually exclusive options share the same branch_group and at least one prev_node; choosing one locks siblings for that run.
- [ ] **When to change battle theme**: If a battle has no natural hook, reframe the encounter in the description or adjust the battle’s enemies (making-battle-configs) to match.

## Existing Nodes: Strong Hooks vs To Review

**Strong hooks (reason clear in description or flow):**

- **castle** → city_street: “Thugs roam the streets outside the castle walls” (immediate threat).
- **forest_village**: “Villagers speak of a cave in the nearby hills” (rumor for cave).
- **clearing**: “A storm drives the party toward the cave the villagers mentioned” (event + rumor).
- **crossroads_inn**: “Three roads lead out: the coast, the old cemetery…, and the encampment at the lab” (rest stop then choice).
- **city_street**: “Thugs roam…” (encounter clear).
- **ruins**: “Shades cling to the crumbling stonework” (encounter clear).

**To review (ensure hook is explicit or theme matches):**

- Any node whose description doesn’t yet explain why the party goes to its next_nodes, or why they came from prev_nodes.
- Battles that feel disconnected from the previous node’s description — add one sentence or align enemies with the hook.

## branch_group Usage

- **forest_branch**: smoke, deep_forest, clearing, ruins (same prev_nodes: forest_village). Choosing one locks the other three.
- **post_inn**: shore, cemetery_battle, army_battle (same prev_nodes: crossroads_inn). Choosing one locks the other two.
- **return_branch**: return_city_1–4 (same prev_nodes: gate_town). Choosing one gate locks the other three.

Empty `branch_group` means no locking; the player can eventually reach all next_nodes (e.g. cave and portal both lead to crossroads_inn).
