extends Resource
class_name HeroStartingStats
# Tier 1 heros' skills sum to 30? 
@export var hero_starting_stats_dict: Dictionary[String, HeroData] = {
    "Ex-Cop": HeroData.new("Ex-Cop", 10, 10, 10, 5, 10, 5, 5, 5),
    "Ex-FBI": HeroData.new("Ex-FBI", 10, 10, 10, 5, 8, 7, 5, 5),
    "Star Athlete": HeroData.new("Star Athlete", 10, 10, 10, 5, 8, 5, 7, 5),

}
