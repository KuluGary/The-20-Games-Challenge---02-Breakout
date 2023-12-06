extends Control

@onready var button: Button = get_node("Button")

func _on_button_pressed():
	get_tree().reload_current_scene()
