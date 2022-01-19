extends Node

var dino_list
var mystery_panel
var main
var money=0
var dinos={}
var eggs={}
var market={}
var dino_prices={}
var stats={"Money (all-time)":0,"Eggs Produced (all-time)":0,"Eggs Sold (all-time)":0}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func add_money(amount:float):
	money+=amount
	stats["Money (all-time)"]+=amount
