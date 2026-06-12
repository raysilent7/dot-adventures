class_name InputComponent extends Node

var dir: Vector2 = Vector2.ZERO

func readInputs():
	dir = Vector2.ZERO

	if Input.is_action_just_pressed("up"):
		dir = Vector2(0, -1)
	elif Input.is_action_just_pressed("down"):
		dir = Vector2(0, 1)
	elif Input.is_action_just_pressed("left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_just_pressed("right"):
		dir = Vector2(1, 0)
