extends CharacterBody2D
var input_name:Array = ['i','k','j','l']
var input_action :Array = [Vector2(0,-1),Vector2(0,1),Vector2(-1,0),Vector2(1,0)]
func _ready():
	print($CollisionShape2D.is_in_group("char"))
	print($CollisionShape2D)
	print($Area2D/CollisionShape2D)
func _process(delta):
	for i in range(4):
		if Input.get_action_strength(input_name[i]):
			velocity += input_action[i]*50
			if $AudioStreamPlayer2D.playing == false:
				$AudioStreamPlayer2D.playing = true
	if velocity.x > 500 :
		velocity.x = 500
	if velocity.y > 500 :
		velocity.y = 500
	velocity *= 0.9
	move_and_slide()
	Mainer.char_position = self.global_position
	if Mainer.is_func2_on:
		for i in $Area2D.get_overlapping_bodies():
			if !i.is_in_group("char"):
				i.queue_free()
			
		Mainer.is_func2_on = false


func _on_timer_timeout():
	$CollisionShape2D/Sprite2D.frame += 1
	if $CollisionShape2D/Sprite2D.frame == 4:
		$CollisionShape2D/Sprite2D.frame = 0


