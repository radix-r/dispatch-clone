class_name HeroData
extends Resource



# Hard code skills?
@export var name: String
@export var max_hp: int
@export var starting_hp: int
@export var current_hp: int
@export var speed: int 
@export var strength: int
@export var brains: int
@export var charm: int
@export var spirt: int

# Archetype? P.I, ex-cop, cryptid?

func _init(
        _name: String = "",
        _max_hp: int = 0,
        _starting_hp: int = 0,
        _current_hp: int = 0,
        _speed: int = 0,
        _strength: int = 0,
        _brains: int = 0,
        _charm: int = 0,
        _spirit: int = 0) -> void:
    name = _name
    max_hp = _max_hp
    starting_hp = _starting_hp
    current_hp = _current_hp
    speed = _speed
    strength = _strength
    brains = _brains
    charm = _charm
    spirt = _spirit
