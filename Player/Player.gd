extends KinematicBody2D

const Speed = 350

var movedir = Vector2(0,0)
var facing = Vector2(0,1)

var castLength = 5

var lightAttackPower = 5
var heavyAttackPower = 10

func _ready():
	$RayCast2D.cast_to = facing * castLength;

func _physics_process(delta):
	controls_loop()
	movement_loop()
	action_loop()

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
	
func action_loop():
	var cast = $RayCast2D
	
	#If the cast doesn't point in the same direction as we move, change where the cast points
	if(cast.cast_to.normalized() != movedir && movedir != Vector2.ZERO):
		cast.cast_to = movedir * castLength
		cast.force_raycast_update()
		
	#If the cast has found an object and the object can be attacked, attack it
	var attackPower = 0;
	if(Input.is_action_just_pressed("light_attack")):
		attackPower = lightAttackPower;
	elif(Input.is_action_just_pressed("heavy_attack")):
		attackPower = heavyAttackPower;
	
	if(attackPower != 0 && cast.get_collider() != null):
		var col = cast.get_collider()
		if(col.has_method("receive_attack")):
			col.receive_attack(self, lightAttackPower)
	