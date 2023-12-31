extends CharacterBody3D

var speed = 4;
var player_chase = false;
@onready var player = get_node("/root/BSC/player")

func _physics_process(delta):
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector3(0, 0, 0)) 

func _on_detection_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == player:
		player_chase = true;


func _on_detection_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == player:
		player_chase = false;
