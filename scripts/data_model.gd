## Savable state of game
extends Resource
class_name DataModel


# wtf do I want in the data model
var num_successes: int = 0:
    set(value):
        num_successes = value
        changed.emit()
var num_fails: int = 0:
    set(value):
        num_fails = value
        changed.emit()
var num_mixed: int = 0:
    set(value):
        num_mixed = value
        changed.emit()
var num_missions: int = 0:
    set(value):
        num_mixed = value
        changed.emit()

# TODO: Heros, skills, speed, hp
