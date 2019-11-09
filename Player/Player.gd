extends KinematicBody2D

const Speed = 350

var movedir = Vector2(0,0)
var facing = Vector2(0,1)

var light_attack_power = 5
var heavy_attack_power = 10

var attack_target

func _ready():
	copy_area($AttackAreas/Down, $AttackArea)

func _physics_process(delta):
	controls_loop()
	facing_update()
	movement_loop()
	action_loop()

func controls_loop():
	var Left = Input.is_action_pressed("ui_left")
	var Right = Input.is_action_pressed("ui_right")
	var Up = Input.is_action_pressed("ui_up")
	var Down = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(Left) + int(Right)
	movedir.y = -int(Up) + int(Down) 
	
#Checks if the player should be faced in another direction based on movement
func facing_update():
	if(movedir != Vector2.ZERO && !(movedir.x != 0 && movedir.y != 0) && facing != movedir):
		facing = movedir;
		match_attack_area(facing)
	
func movement_loop():
	var motion = movedir.normalized() * Speed
	move_and_slide(motion, Vector2(0,0))
	
func action_loop():
	var attack_power = 0;
	if(Input.is_action_just_pressed("light_attack")):
		attack_power = light_attack_power;
	elif(Input.is_action_just_pressed("heavy_attack")):
		attack_power = heavy_attack_power;
	
	#If there is something to attack and an attack button has been clicked: ATTACK!
	if(attack_power != 0 && attack_target != null):
		attack_target.receive_attack(self, attack_power)
		
#Changes the attackzone so that it matches the way the player faces
func match_attack_area(var facing):
	attack_target = null
	match facing:
		Vector2.UP:
			copy_area($AttackAreas/Up, $AttackArea)
		Vector2.RIGHT:
			copy_area($AttackAreas/Right, $AttackArea)
		Vector2.DOWN:
			copy_area($AttackAreas/Down, $AttackArea)
		Vector2.LEFT:
			copy_area($AttackAreas/Left, $AttackArea)
			
#Copies position, scale and shape of an area to another area
func copy_area(var source, var destination):
	destination.position = source.position
	destination.scale = source.scale
	destination.find_node("CollisionShape2D").shape = source.find_node("CollisionShape2D").shape
	
#Called through a signal when an area has entered the attackzone
func _area_entered_attackzone(var area):
	if(area != $Hitbox && area.is_in_group("hitboxes")):
		var areaParent = area.get_parent()
		if(areaParent.has_method("receive_attack")):
			attack_target = areaParent
		
#Called through a signal when an area has exited the attackzone
func _area_exited_attackzone(var area):
	if(attack_target == area.get_parent()):
		attack_target = null