extends CharacterBody2D
class_name Ball

@export var speed = 100

@onready var collision_sound: AudioStreamPlayer2D = get_node("SFX/BumpSound")
@onready var defeat_sound: AudioStreamPlayer2D = get_node("SFX/DefeatSound")

func _ready():
	velocity = Vector2(0.2, -1)

func _physics_process(delta):
	var collision_info: KinematicCollision2D = move_and_collide(velocity * speed * delta)
	
	if collision_info:
		collision_sound.play()
		var collider = collision_info.get_collider()
		var collision_normal = collision_info.get_normal()
		
		if collider is Block:
			speed += 5
			collider.destroy()
			get_parent().on_break_block()
		
		velocity = velocity.bounce(collision_normal.normalized())
