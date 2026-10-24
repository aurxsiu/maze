extends Node2D
var mapcontent:Array
var dir:Array = [Vector2i(0,-1),Vector2i(0,1),Vector2i(-1,0),Vector2i(1,0)]
var enemy_mapposition:Vector2i
var enemy_position:Vector2
var char_mapposition:Vector2i
#chase
var switch_chase:bool
var chase_mode:bool
var advance:bool
var next_step:int
var target_position:Vector2
func _ready():
	mapcontent = Mainer.map_content
	####print(enemy_mapposition,position,enemy_position)
	
	switch_chase = false
	chase_mode = false
	advance = false
func chase_switch():
	if $rest.time_left:
		return false
	else:
		enemy_position = global_position
		char_mapposition = (Mainer.char_position+Vector2(61,61))/122
		enemy_mapposition = (enemy_position+Vector2(61,61))/122
		if abs(enemy_mapposition.x-char_mapposition.x)<=4 and abs(enemy_mapposition.y-char_mapposition.y)<=4:
			print("chase")
			return true
		else:
			return false
func go(machine_position:Vector2i,entrance:int):
	for r in range(4):
		if r != 1-2*(entrance%2)+entrance:
			if mapcontent[machine_position.x][machine_position.y][r+1]:
				machine_position += dir[r]
				if machine_position == char_mapposition:
					return true
				else:
					if go(machine_position,r):
						return true
				machine_position -= dir[r]
	return false
func judge_nextstep():
	enemy_position = global_position
	char_mapposition = (Mainer.char_position+Vector2(61,61))/122
	enemy_mapposition = (enemy_position+Vector2(61,61))/122
	#print(enemy_mapposition,position,enemy_position,char_mapposition)#####
	if char_mapposition == enemy_mapposition:
		return -1
	else:
		var machine_position = enemy_mapposition
		for i in range(4):
			if mapcontent[enemy_mapposition.x][enemy_mapposition.y][i+1]:
				machine_position += dir[i]
				if machine_position == char_mapposition:
					return i
				else:
					if go(machine_position,i):
						return i
				machine_position -= dir[i]
	####注意当char和enemy重合会爆
func _physics_process(delta):
	if !switch_chase:
		switch_chase = chase_switch()
	else:
		if chase_mode == false:
			$Timer.start(10)
			chase_mode = true
		else:
			if $Timer.time_left:
				#print($Timer.time_left)##########
				if !advance:
					next_step = judge_nextstep()
					if next_step == -1:
						get_tree().change_scene_to_file("res://START/control.tscn")
					advance = true
					target_position = global_position + Vector2(dir[next_step]*122)
				else:
					var distance = target_position - global_position
					var back = false
					if next_step == 0:
						if global_position.y > target_position.y:
							global_position += Vector2(dir[next_step])*delta*600
							#print(global_position)#####
						else:
							back = true
					elif next_step == 1:
						if global_position.y < target_position.y:
							global_position += Vector2(dir[next_step])*delta*600
							#print(global_position)#######
						else:
							back = true
					elif next_step == 2:
						if global_position.x > target_position.x:
							global_position += Vector2(dir[next_step])*delta*600
							#print(global_position)#####
						else:
							back = true
					else:
						if global_position.x < target_position.x:
							global_position += Vector2(dir[next_step])*delta*600
							#print(global_position)#######
						else:
							back = true
					if back:
						global_position = target_position
						advance = false
			else:
				switch_chase = false
				chase_mode = false
				advance = false
				global_position = Vector2i(global_position/122)*122
				$rest.start(5)
		
		
	
