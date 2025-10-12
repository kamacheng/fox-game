extends Node


@export var enmey_normal: PackedScene
@export var enmey_elite: PackedScene
@export var enmey_boss: PackedScene

@export var min_spawn_time: float = 1
@export var max_spawn_time: float = 3

@onready var level_timer:Timer = $LevelTimer

var spawn_timer: Timer
var enemy_node: Node
var recycle_node: Node
var spawn_elite_cd: int = 5
var spawn_boss_cd: int =15

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	start_spawn_timer()
	level_timer.start()

func start_spawn_timer() -> void:
	var wait_time = randf_range(min_spawn_time,max_spawn_time)
	spawn_timer.wait_time = wait_time
	spawn_timer.start()
	#print("敌人生成时间: ",wait_time)


func _on_spawn_timer_timeout() -> void:
	start_spawn_timer()
	spawn_enemy()


# 生成敌人
func spawn_enemy() -> void:
	#if spawn_boss_cd == 0:
		#enemy_node = enmey_boss.instantiate()
		#enemy_node.position = Vector2(1300,randi_range(90,600))
		#get_tree().current_scene.add_child(enemy_node)
		#spawn_boss_cd = 15
		#spawn_elite_cd -= 1
		#print("boss")
		#return
	if spawn_elite_cd == 0:
		enemy_node = enmey_elite.instantiate()
		enemy_node.position = Vector2(1300,randi_range(90,600))
		get_tree().current_scene.add_child(enemy_node)
		spawn_elite_cd = 5
		#spawn_boss_cd -= 1
		print("elite")
		return
	else :
		enemy_node = enmey_normal.instantiate()
		enemy_node.position = Vector2(1300,randi_range(90,600))
		get_tree().current_scene.add_child(enemy_node)
		#spawn_boss_cd -= 1
		spawn_elite_cd -= 1
		print("normal")


#  生成速度随时间变化
func _on_level_timer_timeout() -> void:
	if min_spawn_time >= 0.4:
		min_spawn_time -= 0.2
	if max_spawn_time >= 1.2:
		max_spawn_time -= 0.2

func increase_difficulty():
	pass
