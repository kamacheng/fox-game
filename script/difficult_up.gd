extends Label

var tween: Tween

func animate_label_vertical(start_pos: Vector2, float_height: float = 100.0, duration: float = 1.0):

	position = start_pos
	visible = true
	modulate.a = 1.0
	
	# 如果已有tween，先杀死
	if tween:
		tween.kill()
	
	# 创建新的Tween
	tween = create_tween()
	tween.set_parallel(true)  # 设置并行动画
	
	# 竖直上移动画：改变position.y
	tween.tween_property(self, "position:y", start_pos.y - float_height, duration)
	
	# 渐隐动画：改变透明度
	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	# 动画结束后隐藏Label（可选）或释放资源
	tween.finished.connect(_on_tween_finished)



func _on_tween_finished():
	visible = false
