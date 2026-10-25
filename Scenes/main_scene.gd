extends Node2D



var money = 40
var power = 20
var loyalty = 0
var rep = 0
var kills = 0
var turn = 0
@onready var current_dialogue = $NPC/Label
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

var npc_in : bool
var current_npc : Resource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_appear()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if npc_in == false:
		npc_appear()
	if Input.is_action_just_pressed("accept"):
		print("hi")
		accept()
	elif Input.is_action_just_pressed("decline"):
		decline()
	pass
	
func npc_appear():
	var i = RandomNumberGenerator.new()
	var rng : int = i.randi_range(0,8)
	current_npc = npclist[0]
	print(current_npc.npc_name)
	current_dialogue.text = current_npc.dialogue
	npc_in = true
	# l is index of frame, change sprite using the index, look at npclist for the list
	pass
	
func accept():
	current_dialogue.text = current_npc.agree_dialogue
	await get_tree().create_timer(2.0).timeout
	npc_in = false
	#if npc_name == "" and int == 0:
	pass
	
func decline():
	current_dialogue.text = current_npc.disagree_dialogue
	await get_tree().create_timer(2.0).timeout
	npc_in = false
	pass
