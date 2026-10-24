extends Node2D



var money = 0
var power = 0
var loyalty = 0
var rep = 0
var kills = 0
@onready var demon = load("res://Resources/demon.tres") # 0
@onready var demonmerchant = load("res://Resources/demonmerchant.tres") # 1
@onready var eyeball = load("res://Resources/eyeball.tres") # 2
@onready var humantrader = load("res://Resources/humantrader.tres") # 3
@onready var monstercommander = load("res://Resources/monstercommander.tres") # 4
@onready var skeleton = load("res://Resources/skeleton.tres") # 5
@onready var slime = load("res://Resources/slime.tres") # 6
@onready var spider = load("res://Resources/spider.tres") # 7
@onready var witch = load("res://Resources/witch.tres") # 8
@onready var zombie = load("res://Resources/zombie.tres") # 9
@onready var npclist = [demon,demonmerchant,eyeball,humantrader,monstercommander,skeleton,slime,spider,witch,zombie]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_appear()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		accept()
	if Input.is_action_just_pressed("decline"):
		decline()
	pass
	
func npc_appear():
	var i = RandomNumberGenerator.new()
	var rng : int = i.randi_range(0,8)
	var l = npclist[rng]
	
	print(l.npc_name)
	pass
	
func accept():
	#if npc_name == "" and int == 0:
	pass
	
func decline():
	pass
