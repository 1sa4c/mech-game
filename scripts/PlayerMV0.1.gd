extends CharacterBody3D

var speed = 7
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
@onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var snap

var gravity_vec = Vector3()
var movement = Vector3()
	
@onready var interaction_storage = []
@onready var int_visual = $InteractionComps/InteracionLabel

func _ready():
	update_interactions()
	
func _physics_process(delta):
	#interaction input
	if Input.is_action_just_pressed("Interact"):
		execute_interaction()
	
	#get keyboard input
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.lerp(direction * speed, accel * delta)
	movement = velocity + gravity_vec
#	floor_snap_length = len(snap); 
	move_and_slide()
	
	

#area interaction enter n exit detection
func _on_interaction_area_area_entered(area):
	interaction_storage.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area):
	interaction_storage.erase(area)
	update_interactions()
	
#area interaction update
func update_interactions():
	if interaction_storage:
		int_visual.text = interaction_storage[0].int_default
	else:
		int_visual.text = ""
	pass
	
#user input interaction
func execute_interaction():
	if interaction_storage:
		var current_interaction = interaction_storage[0]
		match current_interaction.int_type:
			"print_text" : print(current_interaction.int_active)
	
