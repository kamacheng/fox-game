extends Area2D

@export var is_damage_up: bool
@export var heal_hp: int
@export var is_special_attack: bool
@export var item_score: int
@export var is_up_max_hp: bool

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var disappear_timer: Timer = $DisappearTimer

var is_pick_up: bool = false

signal heal_player
signal add_max_hp
signal get_score
signal special_attack
signal damage_up

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		heal_player.connect(player._on_heal)
		damage_up.connect(player._on_damage_up)
		add_max_hp.connect(player._add_max_hp)
	
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer != null:
		get_score.connect(ui_layer._get_score)
		
	# 强制连接body_entered信号
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		pick_up()

func _process(delta: float) -> void:
	if disappear_timer.is_stopped():
		queue_free()

func pick_up():
	if is_damage_up:
		damage_up.emit()
		is_pick_up = true
	if is_special_attack:
		special_attack.emit()
		is_pick_up = true
	if heal_hp > 0:
		heal_player.emit(heal_hp)
		is_pick_up = true
	if item_score > 0:
		get_score.emit(item_score)
		is_pick_up = true
	if is_up_max_hp:
		add_max_hp.emit()
		is_pick_up = true
	
	
	if is_pick_up:
		audio_stream_player_2d.play()
		visible = false
		self.set_deferred("monitoring",false)
		self.set_deferred("monitorable",false)
		
		await  audio_stream_player_2d.finished
		queue_free()
