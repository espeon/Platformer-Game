extends CanvasLayer

@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var tilemap: TileMap = $"../../TileMap"
@onready var player: Node2D = $"../../Player"

func _ready():
	if tilemap:
		var tilemap_dup: TileMap = tilemap.duplicate()
		sub_viewport.add_child(tilemap_dup)
		
	#for node in get_tree().get_root().get_child(0).get_children():
		#print(node)
		#if !(node is Player):
			#print(node)
			#var dup = node.duplicate()
			#sub_viewport.add_child(dup)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
