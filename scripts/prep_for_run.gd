extends Control

var next_scene_path: String = "res://scenes/game_scene/levels/night.tscn"

var roster_element_scene: PackedScene = load("res://scenes/menus/roster_element.tscn")

var new_run: RunData
var hero_start_stats_dict: Dictionary[String, HeroData]
var unlocked_heroes: Array[String]

var roster_elements: Dictionary[String, RosterElement] = {}


func _ready() -> void:
    #level_state = GameState.  get_level_state(scene_file_path)
    
    
    
    new_run = RunData.new()
    new_run.org_moral = 10
    unlocked_heroes = GameState.get_all_heroes()
    #hero_start_stats_dict = GameState.get_hero_start_stats_dict()
    #var new_hero: HeroData = GameState.get_hero_start_data(unlocked_heroes[0])
    #new_hero.name = "Hero1"
    #new_hero.max_hp = 10
    #new_hero.starting_hp = 10
    #new_hero.current_hp = 10
    #new_hero.speed = 1
    #new_hero.strength = 2
    #new_hero.brains = 3
    #new_hero.charm = 4
    
    #new_run.roster[new_hero.name] = new_hero
    update_roster_label()
    # save run data?
    
    for hero_name in unlocked_heroes:
        # create a buton? for each hero
        var hero_button: Button = Button.new()
        hero_button.text = hero_name
        hero_button.pressed.connect(add_hero_to_roster.bind(hero_name))
        %SelectionContainer.add_child(hero_button)
    
    # conect signals
    SignalManager.on_roster_element_close.connect(remove_hero_from_roster)
    SignalManager.on_hero_stats_updated.connect(update_hero_stats)

func _on_button_start_run_pressed() -> void:
    print_debug("Starting new run")
    GameState.start_run(new_run)
    SceneLoader.load_scene(next_scene_path)


func add_hero_to_roster(hero_name: String):
    # TODO: Differentiate class and name?
    if new_run.roster.has(hero_name):
        print_debug("Hero " + hero_name + " already in roster")
    else:
        new_run.roster[hero_name] = GameState.get_hero_start_data(hero_name)
        var new_roster_element: RosterElement = roster_element_scene.instantiate()
        new_roster_element.hero_data = new_run.roster[hero_name]
        roster_elements[hero_name] = new_roster_element
        %RosterGrid.add_child(new_roster_element)
    update_roster_label()
    pass
    

func update_hero_stats(name: String, changes: Dictionary):
    new_run.roster[name].apply_stat_changes(changes)

func update_roster_label():
    var label_string: String = "[b]Roster:[/b]\n"
    for heor_name in new_run.roster:
        label_string += heor_name + "\n"
    %RosterLabel.text = label_string
    
    
func remove_hero_from_roster(hero_name: String):
    if new_run.roster.erase(hero_name):
        roster_elements[hero_name].queue_free()
        roster_elements.erase(hero_name)
        print_debug(hero_name, " removed from roster")
    else:
        print_debug(hero_name, " not in roster")
    update_roster_label()
    pass
