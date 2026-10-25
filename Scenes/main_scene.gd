extends Node2D



var money = 40
var power = 20
var rep = 0
var loyalty = 20
var kills = 0
var day = 1


@onready var demon = preload("res://Resources/demon.tres") # 0
@onready var demon2 = preload("res://Resources/demon2.tres")
@onready var demon3 = preload("res://Resources/demon3.tres")
@onready var eyeball = preload("res://Resources/eyeball.tres") # 2
@onready var eyeball2 = preload("res://Resources/eyeball2.tres")
@onready var eyeball3 = preload("res://Resources/eyeball3.tres")
@onready var monstercommander = preload("res://Resources/monstercommander.tres") # 4
@onready var monstercommander2 = preload("res://Resources/monstercommander2.tres")
@onready var skeleton = preload("res://Resources/skeleton.tres") # 5
@onready var skeleton2 = preload("res://Resources/skeleton2.tres")
@onready var slime = preload("res://Resources/slime.tres") # 6
@onready var slime2 = preload("res://Resources/slime2.tres")
@onready var slime3 = preload("res://Resources/slime3.tres")
@onready var spider = preload("res://Resources/spider.tres") # 7
@onready var zombie = preload("res://Resources/zombie.tres") # 9
@onready var zombie2 = preload("res://Resources/zombie2.tres")

@onready var demonmerchant = preload("res://Resources/demonmerchant.tres") 
@onready var demonmerchant2 = preload("res://Resources/demonmerchant2.tres")
@onready var demonmerchant3 = preload("res://Resources/demonmerchant3.tres")
@onready var witch = preload("res://Resources/witch.tres") 
@onready var witch2 = preload("res://Resources/witch2.tres") 

@onready var npclist = [demon,demon2,demon3,eyeball,eyeball2,eyeball3,monstercommander,monstercommander2,skeleton,skeleton2,slime,slime2,slime3,spider,zombie,zombie2]
@onready var demonmerchantlist = [demonmerchant,demonmerchant2,demonmerchant3]
@onready var witchlist = [witch,witch2]
#@onready var npclist = [demon,eyeball,monstercommander,skeleton,slime,spider,zombie]
var npc_state : String = "next_npc_ready"
var adventurers = [0,-1,-2,-4,-6,-8]
var robberyevent = false
var warringevent = false

var current_npc : Resource

var request_num : int

var affirmative_response : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Response Image/AnimationPlayer".play("Wiggle")
	$"Stats Box/AnimationPlayer".play("Bob")
	npc_appear()
	print(day)
	print(money)
	print(power)
	print(rep)
	print(loyalty)
	print(kills)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"Stats Box/Money Display".text = " [wave]" + str(money)
	$"Stats Box/Power Display".text = " [shake]" + str(power)
	$"Stats Box/Loyalty Display".text = " [rainbow]" + str(loyalty)
	$"Stats Box/Kills Display".text = " [pulse]" + str(kills)
	$"Stats Box/Reputation Display".text = " [wave]" + str(rep)
	
	if npc_state == "enter_dialogue":
		$"NPC/Dialogue Container/Dialogue".visible_ratio = 1.1 - $"NPC/Dialogue Container/Dialogue Timer".time_left / $"NPC/Dialogue Container/Dialogue Timer".wait_time
	elif npc_state == "exit_dialogue":
		$"NPC/Dialogue Container/Dialogue".visible_ratio = 1.1 - $"NPC/Dialogue Container/Dialogue Timer".time_left / $"NPC/Dialogue Container/Dialogue Timer".wait_time
	
	
	if npc_state == "waiting_for_response":
		if Input.is_action_just_pressed("accept"):
			accept()
		elif Input.is_action_just_pressed("decline"):
			decline()
	if npc_state == "waiting_to_leave":
		if Input.is_anything_pressed():
			$NPC/AnimationPlayer.play("Exit")
			$"Response Image".visible = false
			$"NPC/Dialogue Container".visible = false
			$"Response Image/AnimationPlayer".speed_scale = 1
			npc_state = "exiting"
	elif npc_state == "next_npc_ready":
		npc_appear()
	
	
func npc_appear():
	if power < 0:
		get_tree().change_scene_to_file("res://Scenes/lose_screen_1.tscn")
	elif loyalty < 0 or money < 0:
		get_tree().change_scene_to_file("res://Scenes/lose_screen_2.tscn")
	elif day >= 30:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		pass
	if day > 1:
		adventurer()
	var i = RandomNumberGenerator.new()
	var npc_num : int = i.randi_range(0,15)
	
	current_npc = npclist[npc_num]
	if day % 4 == 0:
		current_npc = demonmerchant
	elif day % 7 == 0:
		current_npc = witch
	request_num = i.randi_range(1, 3)
	
	print(current_npc.npc_name)
	print(current_npc.dialogue)
	
	npc_state = "entering"
	$"NPC/NPC Sprite".frame = current_npc.sprite_frame
	$NPC/AnimationPlayer.play("Enter")
	# l is index of frame, change sprite using the index, look at npclist for the list
	
func accept():
		
	npc_state = "exit_dialouge"
	$"NPC/Dialogue Container/Dialogue Timer".start()	
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
	
	npc_state = "exit_dialogue"
	$"Response Image/AnimationPlayer".speed_scale = 5.0
	affirmative_response = true
	$"Response Image/Sprite2D".frame = 0
	$"Response Image/Agree Sound".play()
	_set_dialogue()
	

func decline():
	if robberyevent == true:
		robberyevent = false
	npc_state = "exit_dialogue"
	$"Response Image/AnimationPlayer".speed_scale = 5.0
	affirmative_response = false
	$"Response Image/Sprite2D".frame = 1
	$"Response Image/Disagree Sound".play()
	
	money += current_npc.disagree_money
	power += current_npc.disagree_power
	rep += current_npc.disagree_reputation
	loyalty += current_npc.disagree_loyalty
	kills += current_npc.disagree_kills
	day += 1
	print(day)
	print(money)
	print(power)
	print(rep)
	print(loyalty)
	print(kills)
	_set_dialogue()
	

func adventurer():
	var rng = RandomNumberGenerator.new()
	if rep < 40:
		power += adventurers[rng.rand_weighted([1,53,30,10,5,1])]
	elif rep < 80:
		power += adventurers[rng.rand_weighted([1,38,30,16,11,4])]
	elif rep < 120:
		power += adventurers[rng.rand_weighted([1,18,30,24,19,8])]
	elif rep < 160:
		power += adventurers[rng.rand_weighted([1,1,28,32,26,12])]
	elif rep < 200:
		power += adventurers[rng.rand_weighted([1,1,8,40,34,16])]
	else:
		power += adventurers[rng.rand_weighted([1,1,1,30,45,21])]

func _on_npc_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Enter":
		npc_state = "enter_dialogue"
		_set_dialogue()
		$"NPC/Dialogue Container".visible = true
		
	if anim_name == "Exit":
		npc_state = "next_npc_ready"


func _on_dialogue_timer_timeout() -> void:
	
	if npc_state == "enter_dialogue":
		$"Response Image/Sprite2D".frame = 2
		$"Response Image".visible = true
		npc_state = "waiting_for_response"
	
	elif npc_state == "exit_dialogue":
		npc_state = "waiting_to_leave"




func _set_dialogue():
	if npc_state == "enter_dialogue":
		$"NPC/Dialogue Container/Dialogue".text = current_npc.dialogue
	elif npc_state == "exit_dialogue":
		if affirmative_response:
			$"NPC/Dialogue Container/Dialogue".text = current_npc.agree_dialogue
		else:
			$"NPC/Dialogue Container/Dialogue".text = current_npc.disagree_dialogue
	
	$"NPC/Dialogue Container/Dialogue".visible_ratio = 0.0
	$"NPC/Dialogue Container/Dialogue Timer".start()
