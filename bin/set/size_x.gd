extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "X:"+str(Mainer.size.x)
	pass


func _on_button_pressed():
	Mainer.size.x+=1


func _on_button_2_pressed():
	Mainer.size.x -= 1
