extends Node


@export var enmey_scene: PackedScene
@export var min_spawn_time: float = 1
@export var max_spawn_time: float = 3


var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	start_spawn_timer()



func start_spawn_timer() -> void:
	var wait_time = randf_range(min_spawn_time,max_spawn_time)
	spawn_timer.wait_time = wait_time
	spawn_timer.start()
	print("敌人生成时间: ",wait_time)



func _on_spawn_timer_timeout() -> void:
	start_spawn_timer()
	var enmey_node = enmey_scene.instantiate()
	enmey_node.position = Vector2(1300,randi_range(90,600))
	get_tree().current_scene.add_child(enmey_node)


# 还没写
func _spawn_time_change() -> void:
	if min_spawn_time >= 0.4:
		min_spawn_time -= 0.2
	if max_spawn_time >= 1.2:
		max_spawn_time -= 0.2
