extends Control

const SKILLS_LIST: Array[String] = ["SkillA", "SkillB", "SkillC"]

var hero_skills_dict: Dictionary[String, int] = {}
var hero_skills_input_dict: Dictionary[String, SpinBox] = {}
var mission_difficulty_dict: Dictionary[String, int] = {}
var mission_difficulty_input_dict: Dictionary[String, SpinBox] = {}
var single_skill_checkbox_dict: Dictionary[String, CheckBox] = {}
## Previous state of button. used to toggle off if in on state
var single_skill_checkbox_prev_dict: Dictionary[String, bool] = {}

var difference_lable_dict: Dictionary[String, Label] = {}

@onready var outputLabel: Label = $MarginContainer/VBoxContainer/HBoxProbabilityContainer/OutputLabel
var outputTextTemplate: String = "Mission Level: %.1f\nDeficit: %.1f\nProbability of Success: %.1f%s"

var single_skill_selected: String = ""

func _ready() -> void:
    #var skills_dict: Dictionary = generate_skill_spread(SKILLS_LIST, 10)
    
    #var mission_dict: Dictionary = generate_skill_spread(SKILLS_LIST, 10)
    
    

    hero_skills_dict = init_dict_keys_to_0(SKILLS_LIST)
    mission_difficulty_dict = init_dict_keys_to_0(SKILLS_LIST)
    

    
    var input_grid: GridContainer = generate_input_grid(SKILLS_LIST)
    $MarginContainer/VBoxContainer/HBoxContainer.add_child(input_grid)
    
    var output_grid: GridContainer = generate_output_grid(SKILLS_LIST)
    $MarginContainer/VBoxContainer/HBoxProbabilityContainer.add_child(output_grid)
    
    #var heroSkillChart: Chart = Chart.new()
    
    
    update_output_labels()
    
    # connect signals
    for key in hero_skills_input_dict:
        hero_skills_input_dict[key].value_changed.connect(update_hero_skill_dict)
    # Should have same keys. Can prob do at same time
    for key in mission_difficulty_input_dict:
        mission_difficulty_input_dict[key].value_changed.connect(update_mission_difficulty_dict)
    # single skill buttons
    for key in single_skill_checkbox_dict:
        single_skill_checkbox_dict[key].pressed.connect(on_single_skill_button_pressed.bind(key))


func calc_dict_sum(dict: Dictionary) -> float:
    var sum: float = 0
    for key in dict.keys():
        sum += dict[key]
    return sum 


func calc_percent_success(skills_dict: Dictionary, mission_dict: Dictionary) -> float:
    var count_uncovered: float = calc_uncovered(skills_dict, mission_dict)
    var mission_level: float = calc_dict_sum(mission_dict)
    
    if mission_level <= 0:
        return 100
    else:
        return (1 - count_uncovered/mission_level) * 100

## Retruns the probabilities of success, mixed, and failed outcomes. generates 2 ints between 1
## and 6. Their sum plus the mod determines outcome. Both ints being 1 is automaticaly a failure. 
## Both being 6 is automaticaly a success. A sum of 10 or higher is a success, a sum of 7 to 9 is
## a mixed success, a sum of 6 or lower is a failure.
func calc_probs_single_skill(mod: int) -> Array[float]:
    # key: sum, value: count 
    var outcome_prob_dist_2d6: Dictionary[int, int] = {
        2: 1,
        3: 2,
        4: 3,
        5: 4,
        6: 5,
        7: 6,
        8: 5,
        9: 4,
        10: 3,
        11: 2,
        12: 1
    }
    
    var sucess_threshold: int = 10
    var mixed_threshold: int  = 7
    
    var success_prob: float = 0
    var mixed_prob: float = 0
    var fail_prob: float = 0
    
    # roll 2 1's is always a fail
    var count_outcomes_fail = 0
    var count_outcomes_mixed = 0
    var count_outcomes_success = 0
    
    for outcome in outcome_prob_dist_2d6:
        # 2 and 12 special cases
        if outcome == 2:
            count_outcomes_fail += 1
            continue
        elif outcome == 12:
            count_outcomes_success += 1
            continue
        else:
            var sum = outcome + mod
            
            if sum >= sucess_threshold:
                count_outcomes_success += outcome_prob_dist_2d6[outcome]
            elif sum >= mixed_threshold:
                count_outcomes_mixed += outcome_prob_dist_2d6[outcome]
            else:
                count_outcomes_fail += outcome_prob_dist_2d6[outcome]
            
    success_prob = float(count_outcomes_success)/calc_dict_sum(outcome_prob_dist_2d6)
    mixed_prob = float(count_outcomes_mixed)/calc_dict_sum(outcome_prob_dist_2d6)
    fail_prob = float(count_outcomes_fail)/calc_dict_sum(outcome_prob_dist_2d6)

    #var int1 = randf_range(1,6)
    #var int2 = randf_range(1,6)
    print_debug(calc_dict_sum(outcome_prob_dist_2d6)," ", count_outcomes_success, " ", count_outcomes_mixed," ", count_outcomes_fail)
    # Should sum to 1
    return [success_prob, mixed_prob, fail_prob]


func calc_uncovered(skills_dict: Dictionary, mission_dict: Dictionary) -> float:
    var count_uncovered: float = 0
    for skill in mission_dict.keys():
        if mission_dict[skill] - skills_dict[skill] > 0:
            count_uncovered += mission_dict[skill] - skills_dict[skill]
            
    return count_uncovered
    

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
    
    print_debug(str(percent_success) + "% chance sucess")


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
    var single_skill_button_group: ButtonGroup = ButtonGroup.new() 
    for skill in skills_list:
        var checkbox: CheckBox = CheckBox.new()
        checkbox.button_group = single_skill_button_group
        single_skill_checkbox_dict[skill] = checkbox
        return_contriner.add_child(checkbox)
        single_skill_checkbox_prev_dict[skill] = checkbox.button_pressed
        
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
    
    # Difference
    var diff_row_label: Label = Label.new()
    diff_row_label.text = "Diff"
    return_contriner.add_child(diff_row_label)
    for skill in skills_list:
        var diff_label: Label = Label.new()
        # TODO maybe have skills be floats? for easy fractional mult ex x1.5
        var diff: int = hero_skills_dict[skill] - mission_difficulty_dict[skill]
        diff_label.text = str(diff)
        return_contriner.add_child(diff_label)
        difference_lable_dict[skill] = diff_label
        
    
    # Bars
    #for skill in skills_list:
        
    
    return return_contriner
    
    
func init_dict_keys_to_0(keys:Array[String]) -> Dictionary[String, int]:
    var return_dict: Dictionary[String, int] = {}
    for key in keys:
        return_dict[key] = 0
    return return_dict


func on_single_skill_button_pressed(skill: String):
    # if button clicked and already on, toggle off
    #print_debug(single_skill_checkbox_dict[skill].name + " Prev: " + str(single_skill_checkbox_prev_dict[skill]) + " Current: " + str(single_skill_checkbox_dict[skill].button_pressed))
    single_skill_selected = skill
    if single_skill_checkbox_prev_dict[skill]:
        single_skill_checkbox_dict[skill].button_pressed = false
        single_skill_selected = ""
    # need to set all other prev to false
    for key in single_skill_checkbox_prev_dict:
        single_skill_checkbox_prev_dict[key] = false
    single_skill_checkbox_prev_dict[skill] = single_skill_checkbox_dict[skill].button_pressed
    update_diff_labels()
    #update_single_skill_output(skill)


func update_diff_labels():
    for key in difference_lable_dict.keys():
        difference_lable_dict[key].text = str(hero_skills_dict[key] - mission_difficulty_dict[key])
    if single_skill_selected != "":
        %HBoxSingleSkill.show()
        update_single_skill_output(single_skill_selected)
    else:
        %HBoxSingleSkill.hide()


func update_hero_skill_dict(_value):
    for skill in hero_skills_dict:
        hero_skills_dict[skill] = hero_skills_input_dict[skill].value
    #print_mission_output(hero_skills_dict, mission_difficulty_dict)
    update_output_labels()


func update_mission_difficulty_dict(_value):
    for skill in mission_difficulty_dict:
        mission_difficulty_dict[skill] = mission_difficulty_input_dict[skill].value
    #print_mission_output(hero_skills_dict, mission_difficulty_dict)
    update_output_labels()


func update_output_labels():
    update_diff_labels()
    outputLabel.text = outputTextTemplate % [
        calc_dict_sum(mission_difficulty_dict), 
        calc_uncovered(hero_skills_dict, mission_difficulty_dict), 
        calc_percent_success(hero_skills_dict, mission_difficulty_dict),
        "%"
    ]


func update_single_skill_output(skill: String):
    var diff: int = hero_skills_dict[skill] - mission_difficulty_dict[skill]
    %skillTitleLabel.text = "Skill: " + skill
    %SkilDiffLabel.text = "Diff: " + str(diff)
    print_debug(calc_probs_single_skill(diff))
