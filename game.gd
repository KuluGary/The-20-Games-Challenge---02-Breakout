extends Node2D

const GRID_GAP = 2
var lives = 3

var grid = []
var score = 0
var block_colors = ["#FFF", "#878787", "#595959"]

@onready var block_scene: PackedScene = preload("res://block.tscn")
@onready var extra_life_scene: PackedScene = preload("res://life.tscn")
@onready var label: Label = get_node("Score") 
@onready var ball: Ball = get_node("Ball")
@onready var paddle: Paddle = get_node("Paddle")
@onready var defeat_menu = get_node("DefeatMenu")
@onready var block_container = get_node("Blocks")
@onready var extra_life_container = get_node("Control/HBoxContainer")

func _ready():
	_generate_grid()
	_place_blocks()
	
	for i in range(lives):
		extra_life_container.add_child(extra_life_scene.instantiate())

func _generate_grid():
	for row in range(3):
		grid.append([])
		grid[row] = []
		for cell in range(4):
			grid[row].append([])
			grid[row][cell] = 1

func _place_blocks():
	var next_block_position = Vector2(-3, 5)
	var row_index = 0
	for row in grid:
		var block_color = block_colors[row_index]
		
		for cell in row:
			var block = block_scene.instantiate()
			var block_sprite: Sprite2D = block.get_node("Sprite2D")
			var block_width = 32
			
			block.global_position = Vector2(next_block_position.x, next_block_position.y)
			block_sprite.modulate = block_color
			
			next_block_position = Vector2(block.global_position.x + block_width + GRID_GAP, block.global_position.y)
			block_container.add_child(block)
		next_block_position = Vector2(-3, next_block_position.y + 16 + GRID_GAP)
		row_index += 1

func _reset_state():
		paddle.global_position = Vector2(80, 112)
		ball.global_position = Vector2(80, 96)
		ball.velocity = Vector2(0.2, -1)
		
func on_break_block():
	score += 100
	label.text = str(score)
	
	if block_container.get_child_count() - 1 == 0:
		_place_blocks()
		paddle.get_node("Sprite2D").scale.x = 0.8
		_reset_state()


func _on_defeat_zone_body_entered(body):
	if body is Ball:
		if lives > 0:
			lives -= 1
			extra_life_container.remove_child(extra_life_container.get_children()[0])
			ball.speed = 100
			_reset_state()
		else:
			paddle.can_move = false
			defeat_menu.show()
			defeat_menu.button.grab_focus()
			pass
