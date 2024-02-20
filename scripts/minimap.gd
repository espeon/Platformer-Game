extends CanvasLayer

# This is the camera in the subviewport
@onready var camera = $SubViewportContainer/SubViewport/Camera2D
# TODO: The tilemap that will be viewed in the minimap
@onready var tilemap: TileMap = $"../../TileMap"
# The tileset that will be used in the minimap
@export var tileset : TileSet

# The node to focus on
@onready var player: Node2D = $"../../Player"

func _ready():
	var duped: TileMap = tilemap.duplicate()
	$SubViewportContainer/SubViewport.add_child(duped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
