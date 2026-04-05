extends Control

var next_scene_path: String = "res://scenes/game_scene/levels/night.tscn"

var new_run: RunData
var hero_start_stats_dict: Dictionary[String, HeroData]
var unlocked_heroes: Array[String]

func _ready() -> void:
    #level_state = GameState.  get_level_state(scene_file_path)
    print_debug("Starting new run")
    new_run = RunData.new()
    new_run.org_moral = 10
    unlocked_heroes = GameState.get_all_heroes()
    #hero_start_stats_dict = GameState.get_hero_start_stats_dict()
    var new_hero: HeroData = GameState.get_hero_start_data(unlocked_heroes[0])
    #new_hero.name = "Hero1"
    #new_hero.max_hp = 10
    #new_hero.starting_hp = 10
    #new_hero.current_hp = 10
    #new_hero.speed = 1
    #new_hero.strength = 2
    #new_hero.brains = 3
    #new_hero.charm = 4
    
    new_run.roster[new_hero.name] = new_hero
    update_roster_label()
    # save run data?
    
    for hero_name in unlocked_heroes:
        # create a buton? for each hero
        var hero_button: Button = Button.new()
        hero_button.text = hero_name
        hero_button.pressed.connect(add_hero_to_roster.bind(hero_name))
        %SelectionContainer.add_child(hero_button)
    


func _on_button_start_run_pressed() -> void:
    GameState.start_run(new_run)
    SceneLoader.load_scene(next_scene_path)


func add_hero_to_roster(hero_name: String):
    # TODO: Differentiate class and name?
    if new_run.roster.has(hero_name):
        new_run.roster[hero_name+"2"] = GameState.get_hero_start_data(hero_name)
    else:
        new_run.roster[hero_name] = GameState.get_hero_start_data(hero_name)
    update_roster_label()
    pass
    

func update_roster_label():
    var label_string: String = "[b]Roster:[/b]\n"
    for heor_name in new_run.roster:
        label_string += heor_name + "\n"
    %RosterLabel.text = label_string
    
    
func remove_hero_from_roster():
    update_roster_label()
    pass
