extends Node2D

export(PackedScene) var source
export(NodePath) var spawnParentPath
export(int) var cooldownSec

var width
var height
var sourceInstance
var cooldown
var spawnParent

# Called when the node enters the scene tree for the first time.
func _ready():
	width = ProjectSettings.get_setting("display/window/size/width")
	height = ProjectSettings.get_setting("display/window/size/height")
	
	spawnParent = get_node(spawnParentPath)
	cooldown = cooldownSec
	
	sourceInstance = source.instance()
	sourceInstance.scale = Vector2(2,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cooldown -= delta
	if(cooldown <= 0):
		var node = sourceInstance.duplicate()
		node.global_position = Vector2(rand_range(0, width), rand_range(0,height))
		spawnParent.add_child(node)
		cooldown = cooldownSec
