extends Area2D

var box_mapposition:Vector2i
var evi_has_entered:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if !evi_has_entered:
		$AudioStreamPlayer2D.playing = true
		Mainer.tool_num[0]+=10
		Mainer.tool_num[1]+=2
		evi_has_entered = true
	pass # Replace with function body.
