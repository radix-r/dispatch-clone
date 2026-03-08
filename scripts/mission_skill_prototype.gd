extends Control

const SKILLS_LIST: Array[String] = ["SkillA", "SkillB", "SkillC"]

var hero_skills_dict: Dictionary[String, int] = {}
var hero_skills_input_dict: Dictionary[String, SpinBox] = {}
var mission_difficulty_dict: Dictionary[String, int] = {}
var mission_difficulty_input_dict: Dictionary[String, SpinBox] = {}
func _ready() -> void:
    #var skills_dict: Dictionary = generate_skill_spread(SKILLS_LIST, 10)
    
    #var mission_dict: Dictionary = generate_skill_spread(SKILLS_LIST, 10)
    
    

    hero_skills_dict = init_dict_keys_to_0(SKILLS_LIST)
    mission_difficulty_dict = init_dict_keys_to_0(SKILLS_LIST)
    
    var input_grid: GridContainer = generate_input_grid(SKILLS_LIST)
    $MarginContainer/VBoxContainer/HBoxContainer.add_child(input_grid)
    
    var output_grid: GridContainer = generate_output_grid(SKILLS_LIST)
    
    
    # connect signals
    for key in hero_skills_input_dict:
        hero_skills_input_dict[key].value_changed.connect(update_hero_skill_dict)
    # Should have same keys. Can prob do at same time
    for key in mission_difficulty_input_dict:
        mission_difficulty_input_dict[key].value_changed.connect(update_mission_difficulty_dict)


func calc_percent_success(skills_dict: Dictionary, mission_dict: Dictionary) -> float:
    var count_uncovered: int = 0
    var mission_level: int = 0
    
    for skill in mission_dict.keys():
        mission_level += mission_dict[skill] 
        if mission_dict[skill] - skills_dict[skill] > 0:
            count_uncovered += mission_dict[skill] - skills_dict[skill]
    #print_debug(str(count_uncovered) + "/" + str(mission_level))
    if mission_level <= 0:
        return 1
    else:
        return 1 - count_uncovered/float(mission_level)
    
    
func generate_skill_spread(skills_list: Array[String], level: int) -> Dictionary:
    var return_dict: Dictionary = {}
    
    # init keys to 0
    return_dict = init_dict_keys_to_0(skills_list)
    
    # distribute skills
    var skill_count: int = len(skills_list)
    for i in range(level):
        var rand_int: int = randi_range(0, skill_count-1)
        return_dict[skills_list[rand_int]] += 1
    
    return return_dict
    
    
func print_mission_output(skills_dict: Dictionary, mission_dict: Dictionary):
    print_debug("Skills: " + str(skills_dict))
    print_debug("Mission: " + str(mission_dict))
    
    # 1.0 = 100% chance of success. 0 = 0% cance of sucess
    var percent_success: float = calc_percent_success(skills_dict, mission_dict)
    
    print_debug(str(percent_success * 100) + "% chance sucess")


func generate_input_grid(skills_list: Array[String]) -> GridContainer:
    var return_contriner = GridContainer.new()
    return_contriner.columns = 1 + len(skills_list)
    
    # Skill Names
    var skill_row_label = Label.new()
    skill_row_label.text = "Skill Names"
    return_contriner.add_child(skill_row_label)
    for skill in skills_list:
        var skill_label = Label.new()
        skill_label.text = skill
        return_contriner.add_child(skill_label)
        
    # Hero Skill Inputs
    var hero_input_row_label = Label.new()
    hero_input_row_label.text = "Hero Skill Value"
    return_contriner.add_child(hero_input_row_label)
    for skill in skills_list:
        var skill_input: SpinBox = SpinBox.new()
        skill_input.value = hero_skills_dict[skill]
        hero_skills_input_dict[skill] = skill_input
        return_contriner.add_child(skill_input)
        
    # Mission Skill Difficulty
    var mission_input_row_label = Label.new()
    mission_input_row_label.text = "Mission Skill Difficulty"
    return_contriner.add_child(mission_input_row_label)
    for skill in skills_list:
        var difficulty_input: SpinBox = SpinBox.new()
        difficulty_input.value = mission_difficulty_dict[skill]
        mission_difficulty_input_dict[skill] = difficulty_input
        return_contriner.add_child(difficulty_input)
        
    # Single Skill CheckBox
    var checkbox_label = Label.new()
    checkbox_label.text = "Single Skill Check"
    return_contriner.add_child(checkbox_label)
    
    return return_contriner
    

func generate_output_grid(skills_list: Array[String]) -> GridContainer:
    var return_contriner = GridContainer.new()
    return_contriner.columns = 1 + len(skills_list)
    
    # Skill Names
    var skill_row_label = Label.new()
    skill_row_label.text = "Skill Names"
    return_contriner.add_child(skill_row_label)
    for skill in skills_list:
        var skill_label = Label.new()
        skill_label.text = skill
        return_contriner.add_child(skill_label)
    
    return return_contriner
    
    
func init_dict_keys_to_0(keys:Array[String]) -> Dictionary[String, int]:
    var return_dict: Dictionary[String, int] = {}
    for key in keys:
        return_dict[key] = 0
    return return_dict


func update_hero_skill_dict(_value):
    for skill in hero_skills_dict:
        hero_skills_dict[skill] = hero_skills_input_dict[skill].value
    print_mission_output(hero_skills_dict, mission_difficulty_dict)


func update_mission_difficulty_dict(_value):
    for skill in mission_difficulty_dict:
        mission_difficulty_dict[skill] = mission_difficulty_input_dict[skill].value
        print_mission_output(hero_skills_dict, mission_difficulty_dict)
