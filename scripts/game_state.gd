class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://scripts/game_state.gd"

@export var level_states : Dictionary = {}
@export var current_level_path : String
@export var checkpoint_level_path : String
@export var total_runs_started : int
@export var play_time : int
@export var total_time : int

@export var active_run: RunData:
    set(value):
        active_run = value
        changed.emit() 
@export var hero_starting_stats: HeroStartingStats = HeroStartingStats.new()
# wtf do I want in the data model
@export var num_successes: int = 0:
    set(value):
        num_successes = value
        changed.emit()
@export var num_fails: int = 0:
    set(value):
        num_fails = value
        changed.emit()
@export var num_mixed: int = 0:
    set(value):
        num_mixed = value
        changed.emit()
@export var num_missions: int = 0:
    set(value):
        num_mixed = value
        changed.emit()

# TODO: Heros, skills, speed, hp


static func get_level_state(level_state_key : String) -> LevelState:
    if not has_game_state(): 
        return
    var game_state := get_or_create_state()
    if level_state_key.is_empty() : return
    if level_state_key in game_state.level_states:
        return game_state.level_states[level_state_key] 
    else:
        var new_level_state := LevelState.new()
        game_state.level_states[level_state_key] = new_level_state
        GlobalState.save()
        return new_level_state

static func has_game_state() -> bool:
    return GlobalState.has_state(STATE_NAME)


static func get_active_run() -> RunData:
    var game_state := get_or_create_state()
    return game_state.active_run

static func get_all_heroes() -> Array[String]:
    var game_state := get_or_create_state()
    return game_state.hero_starting_stats.hero_starting_stats_dict.keys()


static func get_or_create_state() -> GameState:
    return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_current_level_path() -> String:
    if not has_game_state(): 
        return ""
    var game_state := get_or_create_state()
    return game_state.current_level_path

static func get_checkpoint_level_path() -> String:
    if not has_game_state(): 
        return ""
    var game_state := get_or_create_state()
    return game_state.checkpoint_level_path


static func get_hero_start_data(hero_name: String) -> HeroData:
    var game_state := get_or_create_state()
    #game_state.hero_starting_stats.reset_stats()
    if game_state.hero_starting_stats.hero_starting_stats_dict.has(hero_name):
        return game_state.hero_starting_stats.hero_starting_stats_dict[hero_name].duplicate()
    else:
        push_error(hero_name, " not in hero starting data dict")
        return null

static func get_levels_reached() -> int:
    if not has_game_state(): 
        return 0
    var game_state := get_or_create_state()
    return game_state.level_states.size()

static func get_unlocked_heroes() -> Array[String]:
    var game_state := get_or_create_state()
    # TODO filter on who is unlocked
    return game_state.hero_starting_stats.hero_starting_stats_dict.keys()

static func set_checkpoint_level_path(level_path : String) -> void:
    var game_state := get_or_create_state()
    game_state.checkpoint_level_path = level_path
    get_level_state(level_path)
    GlobalState.save()

static func set_current_level_path(level_path : String) -> void:
    var game_state := get_or_create_state()
    game_state.current_level_path = level_path
    GlobalState.save()

static func start_run(run_data: RunData) -> void:
    var game_state := get_or_create_state()
    game_state.total_runs_started += 1
    game_state.active_run = run_data
    GlobalState.save()

static func continue_game() -> void:
    var game_state := get_or_create_state()
    game_state.current_level_path = game_state.checkpoint_level_path
    GlobalState.save()

static func reset() -> void:
    var game_state := get_or_create_state()
    game_state.level_states = {}
    game_state.current_level_path = ""
    game_state.checkpoint_level_path = ""
    game_state.play_time = 0
    game_state.total_time = 0
    GlobalState.save()
