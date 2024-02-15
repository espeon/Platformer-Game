extends ParallaxBackground

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset = Vector2(0, 0)
	scroll_base_offset -= Vector2(20, 0) * delta
