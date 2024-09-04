extends Sprite

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var projectile_container

var target:Node2D
var should_fire = true

func _ready():
	fire_timer.connect("timeout", self, "fire_at_player")
	

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func _physics_process(delta):
	# Knows if exist something between the torret and target
	if(target):
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, target.global_position)
		if(result && result.collider is Wall):
			should_fire = false
		else:
			should_fire = true
			

func fire_at_player():
	if(should_fire):
		var proj_instance = projectile_scene.instance()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))


func _on_DetectionArea_body_entered(body):
	if target == null && !(body is Wall):
		target = body
		fire_timer.start()


func _on_DetectionArea_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == target:
		target = null
		fire_timer.stop()


func hit():
	# Don't work
	print("damaged torret!!")
	
