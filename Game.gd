extends Node

var version=2
var dino_list
var upgrade_list
var mystery_panel
var main
var unlocked_upgrades=[]
var completed_upgrades=[]
var money=0
var current_dinos=0
var current_eggs=0
var dinos={}
var eggs={}
var market={}
var dino_prices={}
var stats={"Money (all-time)":0,"Eggs Produced (all-time)":0,"Eggs Sold (all-time)":0}
var upgrade_variables={"sell_100":0,"sell_all":0,"max_eggs":100,"max_dinos":20,"autosellers":0,"sell_more":1}
var autosave=true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func visually_pleasing(number:int) -> String:
	var suffixes={3:"k",6:"m",9:"b",12:"t"}
	var result
	for p in suffixes:
		if number/pow(10,p)>=1:
			if p!=suffixes.keys()[suffixes.keys().size()-1] and number/pow(10,p+3)>=1:
				continue
			else:
				result="%.2f%s$" % [(number/pow(10,p)),suffixes[p]]
				return result
		else:
			return "%d$" % number
	return "oopsie doopsie woopsie you made a fuckie wuckie uwu"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func add_money(amount:float):
	money+=amount
	stats["Money (all-time)"]+=amount

func autosell():
	var e=[] # check if there are any eggs to prevent stack overflow
	for d in Game.eggs:
		if Game.eggs[d]>0:
			e.append(d)
	if e.size()>0:
		for x in range(0,upgrade_variables["autosellers"]):
			var randint=randi()%e.size()
			var fname=e[randint]
			if eggs[fname]>0:
				add_money(market[fname])
				market[fname]=market[fname]/(1.004)
				stats["Eggs Sold (all-time)"]+=1
				eggs[fname]-=1
				current_eggs-=1
			else:
				autosell()
	
