extends KinematicBody2D

const Speed = 350

var movedir = Vector2(0,0)

func _physics_process(delta):
	controls_loop()
	movement_loop()

func controls_loop():
	var Left = Input.is_action_pressed("ui_left")
	var Right = Input.is_action_pressed("ui_right")
	var Up = Input.is_action_pressed("ui_up")
	var Down = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(Left) + int(Right)
	movedir.y = -int(Up) + int(Down) 
	
func movement_loop():
	var motion = movedir.normalized() * Speed
	move_and_slide(motion, Vector2(0,0))
	