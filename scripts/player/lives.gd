extends CanvasLayer

#@onready var player = find_parent("world").find_child("Player")
@onready var player = find_parent("Player")

# Number of hearts in a row
const HEART_ROW_SIZE = 8

# space between hearts (including heart width)
const HEART_OFFSET = 8

func _ready():
	for i in player.max_lives:
		new_heart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# find the heart that might not be full.
	#print(player.lives)
	var last_heart = floor(player.lives)

	
	for heart in $hearts.get_children():
		var index = heart.get_index()

		if index >= last_heart:
			heart.frame = 1 
		elif index < last_heart:
			heart.frame = 0

func new_heart():
	var newheart = Sprite2D.new()
	newheart.texture = $hearts.texture
	newheart.hframes = $hearts.hframes
	$hearts.add_child(newheart)
	var index = newheart.get_index()
	var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
	var y = floor(index / HEART_ROW_SIZE) * HEART_OFFSET
	newheart.position = Vector2(x, y)
