extends Sprite

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var projectile_container

var target:Node2D
var walls:Array = []

func _ready():
	fire_timer.connect("timeout", self, "fire_at_player")
	

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container


#func _exist_wall():
#	var target_direction = fire_position.global_position.direction_to(target.global_position)
#	var exist = false
#	for wall in walls:
#		var wall_direction = fire_position.global_position.direction_to(wall.global_position)
#		if wall_direction == target_direction:
#			exist = true
#			break
#	return exist

func fire_at_player():
#	if(!_exist_wall()):
		var proj_instance = projectile_scene.instance()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
#	else:
#		fire_timer.stop()

func _on_DetectionArea_body_entered(body):
	if(body is Wall):
		walls.push_back(body)
	elif target == null:
		target = body
		fire_timer.start()


func _on_DetectionArea_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == target:
		target = null
		fire_timer.stop()
		
