extends Control

var scene_path: String = "res://scenes/game_scene/levels/night.tscn"

var hero_label_format: String = "%s:\n    hp: %d, speed: %d,  strength: %d"

func _ready() -> void:
    var heroes: Dictionary[String, HeroData] = GameState.get_active_run().heroes
    
    for hero in heroes:
        print_debug(heroes[hero])
        %OutputLabel.text = hero_label_format % [hero, heroes[hero].current_hp, heroes[hero].speed, heroes[hero].strength]

    GameState.set_current_level_path(scene_path)
    GameState.set_checkpoint_level_path(scene_path)
    print_debug(GameState.get_checkpoint_level_path())
