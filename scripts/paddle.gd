extends CharacterBody2D
class_name Paddle

const SPEED = 120
var can_move = true

func _physics_process(delta):
	if can_move:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity.x = input_direction.x * SPEED

		move_and_slide()
