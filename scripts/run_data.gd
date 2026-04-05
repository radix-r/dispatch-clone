class_name RunData
extends Resource

## Heroes that can be deployable or in the safehouse
@export var roster: Dictionary[String, HeroData] = {}

@export var night: int = 0

@export var org_moral: int
@export var inventory: Dictionary[String, ItemData] = {}
