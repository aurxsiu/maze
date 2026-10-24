extends Node2D
var size :Vector2i
var mapcontent:Array = [];
var map_has_marked:Array = []
var dir:Array = [Vector2(0,-1),Vector2(0,1),Vector2(-1,0),Vector2(1,0)]
var walls_scene = preload("res://迷宫/static_body_2d.tscn")
var char_scene = preload("res://迷宫/character_body_2d.tscn")
var enemy_scene = preload("res://迷宫/enemy.tscn")
var box_scene = preload("res://tools/box.tscn")
#角色创建
func build_char():
	var character = char_scene.instantiate()
	add_child(character)
	character.global_position = Vector2(0,0)
func build_enemy():
	randomize()
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = 122*Vector2(randi()%int(size.x),randi()%int(size.y))
	Mainer.enemy_position = enemy.global_position
	print(enemy.global_position)
#地图创建
func getsize():
	return Mainer.size
func start_map():#初始化mapcontent
	size = getsize()
	for i in range(size.x):
		mapcontent.append([])
		for r in range(size.y):
			mapcontent[i].append([])
			for e in range(5):#上下左右
				mapcontent[i][r].append(false)
func get_surround(room_position:Vector2):#判断地图边界
	var i_group:Array = [true,true,true,true]
	if room_position.x == 0:
		i_group[2] = false
	if room_position.x == size.x-1:
		i_group[3] = false
	if room_position.y == 0:
		i_group[0] = false
	if room_position.y == size.y-1:
		i_group[1] = false
	return i_group
	##返回i_group
func count_map():#查找地图中可通向未开放区域的开放区域
	var avalible_room:Array =[]
	for i in range(size.x):
		for r in range(size.y):
			if(mapcontent[i][r][0]):
				var surround = get_surround(Vector2(i,r))
				for e in range(4):
					if surround[e]:
						if !mapcontent[i+dir[e].x][r+dir[e].y][0]:
							avalible_room.append(Vector2(i,r))
							break
	return avalible_room
	##返回所有的可通向未开放区域的开放区域Array
#func get_wall(room_position:Vector2):
	#var i_group = get_surround(room_position)
	#for i in range(4):
		#if i_group[i]:
			#if !mapcontent[room_position.x][room_position.y][i+1]:
				#pass
func count_exit(room_position:Vector2):#判断是否能够继续破墙
	var i_group:Array = get_surround(room_position)
	var walls_to_open:Array = []
	for i in range(1,5):
		if i_group[i-1]: 
			if !mapcontent[room_position.x][room_position.y][i]:
				if !mapcontent[room_position.x+dir[i-1].x][room_position.y+dir[i-1].y][0]:
					walls_to_open.append(i)
	return walls_to_open
	##返回可开墙的标记walls_to_open(1-4)
func wall_oppsite(wall:int):#返回墙的对面(1-4)
	return wall+wall%2
func build_map():#构造地图
	var machine_position:Vector2
	mapcontent[0][0][0] = true
	var waitdevelop_room = count_map()
	while waitdevelop_room:
		randomize()
		machine_position = waitdevelop_room[randi()%waitdevelop_room.size()]
		###print(machine_position)######################################################################
		var walls_to_open:Array = count_exit(machine_position)
		while walls_to_open:
			randomize()
			var wall_to_open :int = walls_to_open[randi()%walls_to_open.size()]
			#print(wall_to_open)########################################################################
			mapcontent[machine_position.x][machine_position.y][wall_to_open] = true
			mapcontent[machine_position.x+dir[wall_to_open-1].x][machine_position.y+dir[wall_to_open-1].y][0] = true
			mapcontent[machine_position.x+dir[wall_to_open-1].x][machine_position.y+dir[wall_to_open-1].y][wall_to_open+wall_to_open%2*2-1] = true
			machine_position += dir[wall_to_open-1]
			#print(machine_position)######################################################################
			walls_to_open = count_exit(machine_position)
		#print("go")######################################################
		waitdevelop_room = count_map()
func show_wall(wall:int,room_position:Vector2):
	var wall_scene = walls_scene.instantiate()
	if wall<2:
		add_child(wall_scene)
		wall_scene.rotation += PI/2
		if wall==0:
			wall_scene.global_position = room_position + Vector2(0,-58)
		else:
			wall_scene.global_position = room_position - Vector2(0,-58)
	else:
		add_child(wall_scene)
		if wall==2:
			wall_scene.global_position = room_position + Vector2(-58,0)
		else:
			wall_scene.global_position = room_position - Vector2(-58,0)
	pass
func show_map():
	var room_size = 58
	var room_position:Vector2 = Vector2(0,0)
	for i in range(size.x):
		room_position.y = 0
		for r in range(size.y):
			for e in range(4):
				if !mapcontent[i][r][e+1]:
					#print(room_position)#########################
					show_wall(e,room_position)
			room_position+=Vector2(0,122)
		room_position+=Vector2(122,0)
	var under_map_size:int
	if size.x>size.y:
		under_map_size = size.x*5
	else:
		under_map_size = size.y*5
	$Sprite2D.scale *= under_map_size
#道具创建
var tools:Array
func build_box():
	var store_num:int = size.x*size.y/20/20*10
	for i in range(store_num):
		randomize()
		var box = box_scene.instantiate()
		add_child(box)
		box.global_position = 122*Vector2(randi()%size.x,int(randi())%size.y)
		print(box.global_position,"0000")
	pass
func tool_box_show():
	build_box()
	pass
func tool_func(tool_rank:int):
	if Mainer.tool_num[tool_rank-1]>0:
		if tool_rank == 1:
			var tool_scene = preload("res://tools/light_tool.tscn")
			var light_tool = tool_scene.instantiate()
			add_child(light_tool)
			light_tool.global_position = Mainer.char_position
			Mainer.tool_num[0]-=1
		elif tool_rank == 2:
		#var char_mapposition:Vector2i
		#char_mapposition.x = int(Mainer.char_position.x/122)
		#char_mapposition.y = int(Mainer. char_position.y/122)
			Mainer.is_func2_on = true
			Mainer.tool_num[1]-=1
			pass
	
func _ready():
	build_char()
	start_map()
	build_map()
	show_map()
	build_box()
	Mainer.map_content = mapcontent
	if Mainer.enemy_mode:
		var enemy_num:int = size.x*size.y/400
		for i in range(enemy_num):
			build_enemy()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tool_name:Array = ["place_a_light","use_hammer"]
	for i in range(Mainer.tool_ranknum):
		if Input.is_action_just_pressed(tool_name[i]):
			tool_func(i+1)
			pass
		pass
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	pass
