extends Area2D

var box_mapposition:Vector2i
var evi_enter :bool
# Called when the node enters the scene tree for the first time.
func _ready():
	evi_enter = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	box_mapposition = Vector2i(global_position/122)
	if !evi_enter:
		if box_mapposition == Vector2i(Mainer.char_position/122):
			evi_enter = true
			print("enter")


func _on_body_entered(body):
	Mainer.tool_num[0]+=10
	Mainer.tool_num[1]+=2
	pass # Replace with function body.
