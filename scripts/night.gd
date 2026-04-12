extends Control

var scene_path: String = "res://scenes/game_scene/levels/night.tscn"

var hero_label_format: String = "%s:\n    hp: %d, brains: %d, charm: %d, speed: %d, spirit: %d strength: %d, toughness: %d\n"

func _ready() -> void:
    var roster: Dictionary[String, HeroData] = GameState.get_active_run().roster
    %OutputLabel.text = "[b]Roster:[/b]\n"
    for hero in roster:
        print_debug(roster[hero])
        %OutputLabel.text += hero_label_format % [hero, roster[hero].current_hp,
                                                        roster[hero].brains,
                                                        roster[hero].charm,
                                                        roster[hero].speed,
                                                        roster[hero].spirit, 
                                                        roster[hero].strength,
                                                        roster[hero].toughness]

    GameState.set_current_level_path(scene_path)
    GameState.set_checkpoint_level_path(scene_path)
    #print_debug(GameState.get_checkpoint_level_path())
