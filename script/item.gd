extends Area2D

@export var is_damage_up: bool
@export var heal_hp: int
@export var is_special_attack: bool
@export var item_score: int


signal heal_player
signal get_score
signal special_attack
signal damage_up

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		heal_player.connect(player._on_heal)
		damage_up.connect(player._on_damage_up)
	
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer != null:
		get_score.connect(ui_layer._get_score)
		
	# 强制连接body_entered信号
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("检测到CharacterBody2D: ", body.name)
		pick_up()


func pick_up():
	if is_damage_up:
		damage_up.emit()
	if is_special_attack:
		special_attack.emit()
	if heal_hp > 0:
		heal_player.emit(heal_hp)
	if item_score > 0:
		get_score.emit(item_score)
	queue_free()
