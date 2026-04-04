extends Control

var next_scene_path: String = "res://scenes/game_scene/levels/night.tscn"

func _ready() -> void:
    #level_state = GameState.  get_level_state(scene_file_path)
    print_debug("Starting new run")
    var new_run: RunData = RunData.new()
    new_run.org_moral = 10
    var new_hero: HeroData = HeroData.new()
    new_hero.name = "Hero1"
    new_hero.max_hp = 10
    new_hero.starting_hp = 10
    new_hero.current_hp = 10
    new_hero.speed = 1
    new_hero.strength = 2
    new_hero.brains = 3
    new_hero.charm = 4
    
    new_run.heroes[new_hero.name] = new_hero
    # save run data?
    GameState.start_run(new_run)


func _on_button_start_run_pressed() -> void:
    SceneLoader.load_scene(next_scene_path)
