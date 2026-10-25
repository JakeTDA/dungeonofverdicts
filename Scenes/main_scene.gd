extends Node2D



var money = 40
var power = 20
var loyalty = 0
var rep = 0
var kills = 0
var turn = 0

@onready var demon = load("res://Resources/demon.tres") # 0
@onready var demonmerchant = load("res://Resources/demonmerchant.tres") # 1
@onready var eyeball = load("res://Resources/eyeball.tres") # 2
@onready var monstercommander = load("res://Resources/monstercommander.tres") # 4
@onready var skeleton = load("res://Resources/skeleton.tres") # 5
@onready var slime = load("res://Resources/slime.tres") # 6
@onready var spider = load("res://Resources/spider.tres") # 7
@onready var witch = load("res://Resources/witch.tres") # 8
@onready var zombie = load("res://Resources/zombie.tres") # 9
@onready var npclist = [demon,demonmerchant,eyeball,monstercommander,skeleton,slime,spider,witch,zombie]

var npc_state : String = "next_npc_ready"

var current_npc : Resource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Response Image/AnimationPlayer".play("Wiggle")
	npc_appear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if npc_state == "waiting_for_response":
		if Input.is_action_just_pressed("accept"):
			accept()
		elif Input.is_action_just_pressed("decline"):
			decline()
	elif npc_state == "next_npc_ready":
		npc_appear()
	
	
func npc_appear():
	var i = RandomNumberGenerator.new()
	var rng : int = i.randi_range(0,8)
	current_npc = npclist[rng]
	print(current_npc.npc_name)
	
	npc_state = "entering"
	$NPC/Sprite2D.frame = current_npc.sprite_frame
	$NPC/AnimationPlayer.play("Enter")
	# l is index of frame, change sprite using the index, look at npclist for the list


	
func accept():
	npc_state = "exit_dialouge"
	$"NPC/Dialogue Timer".start()
	$"Response Image/Sprite2D".frame = 0


func decline():
	npc_state = "exit_dialouge"
	$"NPC/Dialogue Timer".start()
	$"Response Image/Sprite2D".frame = 1



func _on_npc_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Enter":
		npc_state = "enter_dialouge"
		$"NPC/Dialogue Timer".start()
		
	if anim_name == "Exit":
		npc_state = "next_npc_ready"


func _on_dialogue_timer_timeout() -> void:
	print("time")
	if npc_state == "enter_dialouge":
		$"Response Image/Sprite2D".frame = 2
		$"Response Image".visible = true
		npc_state = "waiting_for_response"
	
	
	elif npc_state == "exit_dialouge":
		$NPC/AnimationPlayer.play("Exit")
		$"Response Image".visible = false
		npc_state = "exiting"
