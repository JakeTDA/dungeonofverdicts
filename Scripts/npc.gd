class_name NPC
extends Resource
@export var npc_name : String
@export var sprite : Texture2D
@export var dialogue : String
@export_group("Agree")
@export var agree_dialogue : String
@export var agree_money : int
@export var agree_power : int
@export var agree_reputation: int
@export var agree_loyalty : int
@export_group("Disagree")
@export var disagree_dialogue : String
@export var disagree_money : int
@export var disagree_power : int
@export var disagree_reputation: int
@export var disagree_loyalty : int
