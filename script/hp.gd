extends Control

@onready var hp_bar: TextureProgressBar = $hp_bar


func update_healthbar(current_hp:int ,max_hp:int):
	hp_bar.value = current_hp / float(max_hp)
