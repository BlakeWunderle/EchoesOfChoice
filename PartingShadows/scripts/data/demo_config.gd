class_name DemoConfig

const DEMO_FINAL_BATTLES: Array[String] = [
	"HighlandBattle", "DeepForestBattle", "ShoreBattle"
]


static func is_demo() -> bool:
	return OS.has_feature("demo")


static func is_demo_final(battle_id: String) -> bool:
	return battle_id in DEMO_FINAL_BATTLES
