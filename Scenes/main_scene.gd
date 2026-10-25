extends Node2D



var money = 40
var power = 20
var rep = 0
var loyalty = 20
var kills = 0
var day = 1


@onready var demon = load("res://Resources/demon.tres") # 0
@onready var demonmerchant = load("res://Resources/demonmerchant.tres") # 1
@onready var eyeball = load("res://Resources/eyeball.tres") # 2
@onready var monstercommander = load("res://Resources/monstercommander.tres") # 4
@onready var skeleton = load("res://Resources/skeleton.tres") # 5
@onready var slime = load("res://Resources/slime.tres") # 6
@onready var spider = load("res://Resources/spider.tres") # 7
@onready var witch = load("res://Resources/witch.tres") # 8
@onready var zombie = load("res://Resources/zombie.tres") # 9
@onready var npclist = [demon,eyeball,monstercommander,skeleton,slime,spider,zombie]
@onready var specialnpclist = [witch,demonmerchant]

var npc_state : String = "next_npc_ready"
var game_state : String = "normal"
var adventurers = [0,-3,-6,-9,-11,-15]

var current_npc : Resource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Response Image/AnimationPlayer".play("Wiggle")
	npc_appear()
	print(day)
	print(money)
	print(power)
	print(rep)
	print(loyalty)
	print(kills)


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
	if day > 1:
		adventurer()
	var i = RandomNumberGenerator.new()
	var rng : int = i.randi_range(0,6)
	current_npc = npclist[rng]
	if day % 4 == 0:
		current_npc = demonmerchant
	elif day % 7 == 0:
		current_npc = witch
	print(current_npc.npc_name)
	
	npc_state = "entering"
	$NPC/Sprite2D.frame = current_npc.sprite_frame
	$NPC/AnimationPlayer.play("Enter")
	# l is index of frame, change sprite using the index, look at npclist for the list
	
func accept():
	npc_state = "exit_dialouge"
	$"NPC/Dialogue Timer".start()	
	$"Response Image/Sprite2D".frame = 0
	money += current_npc.agree_money
	power += current_npc.agree_power
	rep += current_npc.agree_reputation
	loyalty += current_npc.agree_loyalty
	kills += current_npc.agree_kills
	day += 1
	print(day)
	print(money)
	print(power)
	print(rep)
	print(loyalty)
	print(kills)
	
func decline():
	npc_state = "exit_dialouge"
	$"NPC/Dialogue Timer".start()
	$"Response Image/Sprite2D".frame = 1
	money += current_npc.agree_money
	power += current_npc.agree_power
	rep += current_npc.agree_reputation
	loyalty += current_npc.agree_loyalty
	kills += current_npc.agree_kills
	day += 1
	print(day)
	print(money)
	print(power)
	print(rep)
	print(loyalty)
	print(kills)

func adventurer():
	var rng = RandomNumberGenerator.new()
	if rep < 40:
		power -= adventurers[rng.rand_weighted([1,53,30,10,5,1])]
	elif rep < 80:
		power -= adventurers[rng.rand_weighted([1,38,30,16,11,4])]
	elif rep < 120:
		power -= adventurers[rng.rand_weighted([1,18,30,24,19,8])]
	elif rep < 160:
		power -= adventurers[rng.rand_weighted([1,1,28,32,26,12])]
	elif rep < 200:
		power -= adventurers[rng.rand_weighted([1,1,8,40,34,16])]
	else:
		power -= adventurers[rng.rand_weighted([1,1,1,30,45,21])]

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
