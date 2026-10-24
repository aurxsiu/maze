extends Node
#map
var size :Vector2 = Vector2(20,20)
var map_content:Array
#char
var char_position :Vector2
#mode
var enemy_mode:bool = true
var enemy_position:Vector2

var tool_ranknum = 2
var tool_num:Array = [10,2]
#放置灯//破墙
var is_func2_on:bool = false
