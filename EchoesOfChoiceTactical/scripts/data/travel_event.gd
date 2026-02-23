class_name TravelEventData
extends Resource

@export var event_type: String = "story"  # story / rumor / rest / merchant / ambush
@export var title: String = ""
@export var dialogue: Array[Dictionary] = []
@export var trigger_chance: float = 0.2
@export var node_range: Array[String] = []  # empty = any node


# Static event pool. OverworldMap rolls against this on each node entry.
# Each entry mirrors the exported fields above, stored as plain dictionaries
# so events can be defined here without creating .tres files.
const EVENTS: Array = [
	{
		"event_type": "story",
		"title": "The Stranger",
		"trigger_chance": 0.25,
		"node_range": ["forest", "deep_forest", "clearing"],
		"dialogue": [
			{"speaker": "", "text": "A figure stands motionless at the tree line. Hooded. Watching."},
			{"speaker": "", "text": "When you look again, they are gone — but a folded note lies on the path."},
			{"speaker": "", "text": "It reads: 'You are not the only ones heading for the city. Be careful what you let through.'"},
		],
	},
	{
		"event_type": "rumor",
		"title": "Overheard at Camp",
		"trigger_chance": 0.2,
		"node_range": ["smoke", "ruins", "portal"],
		"dialogue": [
			{"speaker": "", "text": "Two soldiers sit at a fire, unaware of you. Their voices carry."},
			{"speaker": "Soldier", "text": "The encampment at the lab is a holding action. Whatever is inside that lab, command wants it protected."},
			{"speaker": "Soldier", "text": "The cemetery road is faster. Less organized. I would take that if I were running from something."},
		],
	},
	{
		"event_type": "rest",
		"title": "A Quiet Hollow",
		"trigger_chance": 0.3,
		"node_range": ["forest", "forest_village", "cave", "crossroads_inn"],
		"dialogue": [
			{"speaker": "", "text": "A sheltered hollow off the main path. Soft ground, still air. No sounds of pursuit."},
			{"speaker": "Lyris", "text": "Five minutes. Just five minutes."},
			{"speaker": "", "text": "The party rests. The silence is a small mercy."},
		],
	},
	{
		"event_type": "rumor",
		"title": "The Lookout's Warning",
		"trigger_chance": 0.2,
		"node_range": ["cave", "portal", "crossroads_inn"],
		"dialogue": [
			{"speaker": "", "text": "A woman watches the crossroads from a high rock, a spyglass in hand."},
			{"speaker": "Lookout", "text": "Three roads ahead. The shore road is faster but the sirens are active — I lost count of the ships."},
			{"speaker": "Lookout", "text": "The cemetery path is quieter until the graves start moving. Your call."},
		],
	},
	{
		"event_type": "story",
		"title": "What Came Through",
		"trigger_chance": 0.25,
		"node_range": ["mirror_battle", "gate_town", "return_city_1", "return_city_2", "return_city_3", "return_city_4"],
		"dialogue": [
			{"speaker": "", "text": "At the Mirror crossing, the air still crackles with something that did not go back through."},
			{"speaker": "Aldric", "text": "Whatever stirred those elementals — it came from inside the city, not outside."},
			{"speaker": "Elara", "text": "Then we are not ending this journey. We are finishing what someone else started."},
		],
	},
	{
		"event_type": "merchant",
		"title": "Wandering Merchant",
		"trigger_chance": 0.15,
		"node_range": [],
		"merchant_items": ["phoenix_feather", "elixir", "shadow_cloak"],
		"dialogue": [
			{"speaker": "Merchant", "text": "A lucky crossing for both of us. I carry things you will not find in any settled market."},
			{"speaker": "Merchant", "text": "Take a look. I move on before sunrise."},
		],
	},
	{
		"event_type": "ambush",
		"title": "Ambush!",
		"trigger_chance": 0.12,
		"node_range": [],
		"gold_reward": 60,
		"dialogue": [
			{"speaker": "", "text": "Footsteps behind. Too fast, too close. Bandits step out from the shadows."},
			{"speaker": "", "text": "The fight is quick and brutal — but you come out ahead. They were carrying coin."},
			{"speaker": "", "text": "Gold +60"},
		],
	},
]
