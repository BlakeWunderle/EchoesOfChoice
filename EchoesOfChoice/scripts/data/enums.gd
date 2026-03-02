class_name Enums

## Stat types matching C# StatEnum. Used for ability targeting and stat modification.
enum StatType {
	PHYSICAL_ATTACK,
	PHYSICAL_DEFENSE,
	MAGIC_ATTACK,
	MAGIC_DEFENSE,
	ATTACK,       ## Both physical + magic attack
	DEFENSE,      ## Both physical + magic defense
	SPEED,
	HEALTH,       ## Used for DoT effects
	MIXED_ATTACK, ## Average of physical + magic
	TAUNT,
	DODGE_CHANCE,
}

enum Team {
	PLAYER,
	ENEMY,
}
