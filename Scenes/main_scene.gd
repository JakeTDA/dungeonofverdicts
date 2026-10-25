extends Node2D



var money = 40
var power = 20
var rep = 0
var loyalty = 20
var kills = 0
var day = 10


@onready var demon = load("res://Resources/demon.tres") # 0
@onready var demonmerchant = load("res://Resources/demonmerchant.tres") # 1
@onready var eyeball = load("res://Resources/eyeball.tres") # 2
@onready var monstercommander = load("res://Resources/monstercommander.tres") # 4
@onready var skeleton = load("res://Resources/skeleton.tres") # 5
@onready var slime = load("res://Resources/slime.tres") # 6
@onready var spider = load("res://Resources/spider.tres") # 7
@onready var witch = load("res://Resources/witch.tres") # 8
@onready var zombie = load("res://Resources/zombie.tres") # 9
@onready var monstercommanderevent = load("res://Resources/monstercommanderevent.tres")
@onready var npclist = [demon,eyeball,monstercommander,skeleton,slime,spider,zombie]
var npc_state : String = "next_npc_ready"
var adventurers = [0,-3,-6,-9,-11,-15]
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
		if Input.is_action_just_pressed("accept") or Input.is_action_just_pressed("decline"):
			$NPC/AnimationPlayer.play("Exit")
			$"Response Image".visible = false
			$"NPC/Dialogue Container".visible = false
			$"Response Image/AnimationPlayer".speed_scale = 1
			npc_state = "exiting"
	elif npc_state == "next_npc_ready":
		npc_appear()
	
	
func npc_appear():
	if day > 1:
		adventurer()
	var i = RandomNumberGenerator.new()
	var npc_num : int = i.randi_range(0,6)
	current_npc = npclist[npc_num]
	if robberyevent == true:
		print("robbery event on")
		current_npc.npc_name = "Suspect"
		current_npc.dialogue = "Wait, I'm not guilty, please let me go!"
		current_npc.agree_dialogue = "Thank you.. Thank you!"
	elif day == 10:
		current_npc = monstercommanderevent
	elif day % 4 == 0:
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
	if robberyevent == true:
		var rng = RandomNumberGenerator.new()
		var luck = rng.randi_range(0,1)
		if luck == 0:
			current_npc.agree_power = -20
			current_npc.agree_loyalty = -20
		elif luck == 1:
			current_npc.agree_money = 50
			current_npc.agree_power = 10	
		robberyevent = false	
		print("robberyevent off")
	if day == 10:
		robberyevent = true
		
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
	if current_npc.npc_name == "Demon":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Dungeon Master, I have discovered an ancient temple of the Serpent Lodge beneath the dungeon. Give me gold to awaken the temple, and I shall forge powerful demons for your army!"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "Let's see what those snakes are up to!"
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = "What a dissapointment..."
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Dungeon Master, I have discovered an adventurer camp filled with gold. Let me raid it before they return, and we can claim their treasure!"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "Score! They'll never know what hit em!"
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = "Aw man, I was really looking forward to that..."
	
	if current_npc.npc_name == "Demon Merchant":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Ah, Dungeon Master! I have rare artifacts, cursed weapons, and enchanted armor. Everything has a price. Care to make a deal? Only 40 gold!"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "I have a very fine cursed weapon here for you! Very powerful, and equally famous. This one will write your name in the history books!"
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = "Ah well, I'm sure there are more than enough people who would be happy to take this."
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Hello again! Is it ok if I can set up a shop near this dungeon? I’ll pay you 50 gold for the opportunity!"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "I'll set up right outside, they'll be able to see the shop from miles away!"
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = "What a shame. There was enough money in it for the both of us. Ever heard of a win-win?"
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Hello Dungeon Master! Would you like to try this new drink I acquired from the human world?"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "Fortune favors the bold! He-he-he..."
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = "You never know what you're missing until you try..."
	
	if current_npc.npc_name == "Eyeball":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Master, I have spotted a powerful adventurer party approaching our dungeon. Allow me to study their weaknesses, and I shall guide our monsters to victory!"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "Affirmative master! You won't regret this!"
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = "Are you sure master? They're coming whether I study them or not..."
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Master, I’ve been having trouble seeing lately. May I humbly request some money for a monocle?"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "Master, your generocity knows no bounds! I will serve you until my last blink!"
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = "I'll try my best to do without master...but I may not be able to perform as well"
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = "Master! I have detected a secret chamber beneath the dungeon. There may be an enormous treasure hidden inside, but the entrance is protected by an unknown ancient magic. Shall we investigate?"
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = "We'll get to the bottom of that chamber if it's the last thing we do!"
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = "Some things are better off staying secret. After all, ignorance is bliss!"
	
	if current_npc.npc_name == "Monster Commander":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	if current_npc.npc_name == "Skeleton":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	if current_npc.npc_name == "Slime":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	if current_npc.npc_name == "Spider":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	if current_npc.npc_name == "Witch":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	if current_npc.npc_name == "Zombie":
		if request_num == 1:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 2:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
				
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
		
		if request_num == 3:
			if npc_state == "enter_dialogue":
				$"NPC/Dialogue Container/Dialogue".text = ""
				
			elif npc_state == "exit_dialogue":
				if affirmative_response:
					$"NPC/Dialogue Container/Dialogue".text = ""
					
				else:
					$"NPC/Dialogue Container/Dialogue".text = ""
	
	
	$"NPC/Dialogue Container/Dialogue".visible_ratio = 0.0
	$"NPC/Dialogue Container/Dialogue Timer".start()
