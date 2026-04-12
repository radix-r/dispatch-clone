extends Control
class_name RosterElement


var default_texture: Texture2D = load("res://assets/godot_engine_logo/logo_vertical_color_dark.png")

@onready var brains_spin_box: SpinBox = %BrainsSpinBox
@onready var brains_original_value_label: RichTextLabel = %BrainsOriginalValueLabel
@onready var charm_spin_box: SpinBox = %CharmSpinBox
@onready var charm_original_value_label: RichTextLabel = %CharmOriginalValueLabel
@onready var speed_spin_box: SpinBox = %SpeedSpinBox
@onready var speed_original_value_label: RichTextLabel = %SpeedOriginalValueLabel
@onready var spirit_spin_box: SpinBox = %SpiritSpinBox
@onready var spirit_original_value_label: RichTextLabel = %SpiritOriginalValueLabel
@onready var strength_spin_box: SpinBox = %StrengthSpinBox
@onready var strength_original_value_label: RichTextLabel = %StrengthOriginalValueLabel
@onready var toughness_spin_box: SpinBox = %ToughnessSpinBox
@onready var toughness_original_value_label: RichTextLabel = %ToughnesssOriginalValueLabel

var hero_data: HeroData
var hero_detail_label_template

func _ready() -> void:
    # Set hero portrate as button image
    %Button.icon = default_texture
    %Button.size = Vector2(40, 40)
    
    if hero_data:
        %HeroDetailLabel.text = hero_data.name
        upadate_details()
    # move panel to center screne
    #%HeroDetailContainer.set_global_position((get_viewport_rect().size / 2) - global_position - position)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        %HeroDetailPanel.hide()


func _on_button_pressed() -> void:
    # Open stats popup
    %HeroDetailPanel.show()
    %HeroDetailPanel.set_global_position(get_viewport_rect().size / 2 - %HeroDetailPanel.size / 2)

## Not right. Close on click outside of button and panel
func _on_button_focus_exited() -> void:
    # Close stats popup
    #%HeroDetailPanel.hide()
    pass




func _on_focus_exited() -> void:
    pass
    #%HeroDetailPanel.hide()


func _on_close_button_pressed() -> void:
    SignalManager.on_roster_element_close.emit(hero_data.name)
    pass # Replace with function body.


func _on_detail_confirm_button_pressed() -> void:
    # Get values from spinBoxes
    ## Key: skill name, Value: new value
    var changes_dict: Dictionary[String, int]
    changes_dict["brains"] = brains_spin_box.value
    changes_dict["charm"] = charm_spin_box.value
    changes_dict["speed"] = speed_spin_box.value
    changes_dict["spirit"] = spirit_spin_box.value
    changes_dict["strength"] = strength_spin_box.value
    changes_dict["toughness"] = toughness_spin_box.value
    
    hero_data.brains = brains_spin_box.value
    hero_data.charm = charm_spin_box.value
    hero_data.speed = speed_spin_box.value
    hero_data.spirit = spirit_spin_box.value
    hero_data.strength = strength_spin_box.value
    hero_data.toughness = toughness_spin_box.value
    
    SignalManager.on_hero_stats_updated.emit(hero_data.name, changes_dict)
    upadate_details()
    

func upadate_details():
    
    brains_spin_box.value = hero_data.brains
    # get base value?
    brains_spin_box.min_value = hero_data.brains
    brains_original_value_label.text = str(hero_data.brains)
    
    charm_spin_box.value = hero_data.charm
    # get base value?
    charm_spin_box.min_value = hero_data.charm
    charm_original_value_label.text = str(hero_data.charm)
    
    speed_spin_box.value = hero_data.speed
    # get base value?
    speed_spin_box.min_value = hero_data.speed
    speed_original_value_label.text = str(hero_data.speed)
    
    spirit_spin_box.value = hero_data.spirit
    # get base value?
    spirit_spin_box.min_value = hero_data.spirit
    spirit_original_value_label.text = str(hero_data.spirit)
    
    strength_spin_box.value = hero_data.strength
    # get base value?
    strength_spin_box.min_value = hero_data.strength
    strength_original_value_label.text = str(hero_data.strength)
    
    toughness_spin_box.value = hero_data.toughness
    # get base value?
    toughness_spin_box.min_value = hero_data.toughness
    toughness_original_value_label.text = str(hero_data.toughness)
