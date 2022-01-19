extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dino_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Dinos
onready var egg_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Eggs
onready var egg_panel=load("res://EggPanel.tscn")
onready var dino_panel= load("res://DinoPanel.tscn")
onready var mystery_panel= load("res://MysteryPanel.tscn")
onready var money_label=$MainScreen/Panel/HBoxContainer/Money
onready var timer_label=$MainScreen/Panel/HBoxContainer/TimerLabel
#onready var dino_grid=$MainScreen/Panel/MarginContainer/DinoGrid
var starter_dino="Eoraptor"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var dino_list=File.new()
	dino_list.open("res://dinos.json", File.READ)
	var r= parse_json(dino_list.get_as_text())
	dino_list.close()
	Game.dino_list=r
	Game.main=self
	Game.money=r[starter_dino]["price"]
	create_unknown_panel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	money_label.text="Money: "+String(floor(Game.money))+"$"
	timer_label.text="Egg market updates in: %02d" % ($MarketTimer.time_left+1)
	for dino in Game.dino_list:
			if !(dino in Game.dinos):
				if Game.money >= (Game.dino_list[dino]["unlock_price"]):
					add_dino_button(dino)
	
#func add_sprite(sprite):
#	var c=Container.new()
#	var spr= Sprite.new()
#	spr.texture=load(sprite)
#	spr.scale.x=0.1
#	spr.scale.y=0.1
#	c.add_child(spr)
#	dino_grid.add_child(c)
#	print(dino_grid.get_children())
	
func add_dino_button(fname:String):
	var d=Game.dino_list[fname]
	var tri= dino_panel.instance()
	tri.fname=fname
	tri.price=d["price"]
	tri.period=d["period"]
	tri.clutch=d["clutch"]
	dino_list.add_child(tri)
	var bi= egg_panel.instance()
	bi.fname=fname
	bi.price=d["egg_price"]
	egg_list.add_child(bi)
	create_unknown_panel()
	

			

func _on_DinoTab_pressed():
	var a=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer
	for b in a.get_children():
		b.hide()
	$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Dinos.show()


func _on_EggTab_pressed():
	var a=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer
	for b in a.get_children():
		b.hide()
	$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Eggs.show()


func _on_SettingTab_pressed():
	var a=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer
	for b in a.get_children():
		b.hide()
	$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Settings.show()


func _on_TutTab_pressed():
	var a=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer
	for b in a.get_children():
		b.hide()
	$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Tut.show()


func _on_Save_pressed():
	var s= File.new()
	if !(s.open("res://save.dat", File.WRITE)):
		var save_data=[Game.dinos,Game.eggs,Game.money,Game.market]
		print(save_data)
		s.store_var(save_data)
		s.close()
	else:
		print("Saving failed!")

func _on_Load_pressed():
	var s= File.new()
	if !(s.open("res://save.dat", File.READ)):
		var a=s.get_var()
		print(a)
		for dino in a[0]:
			if !(dino in Game.dinos):
				add_dino_button(dino)
		Game.dinos=a[0]
		Game.eggs=a[1]
		Game.money=a[2]
		Game.market=a[3]
		s.close()
	else:
		print("Loading Failed!")


func _on_MarketTimer_timeout():
	for d in Game.market:
		var correction=(Game.dino_list[d]["egg_price"]-Game.market[d])*0.375
		if abs(Game.dino_list[d]["egg_price"]-(Game.market[d]+correction))>0.5:
		#if the difference between base price and corrected price is less than 0.5, just set price to base price
		#to prevent zeno's paradox 
			Game.market[d]+=correction
		else:
			Game.market[d]=Game.dino_list[d]["egg_price"]
			
func create_unknown_panel():
	if Game.mystery_panel != null:
		Game.mystery_panel.queue_free()
	var p_array=[]
	for d in Game.dino_list:
		if !(d in Game.dinos.keys()):
			p_array.append(Game.dino_list[d]["unlock_price"])
	p_array.sort()
	if p_array.size()>0:
		var tri= mystery_panel.instance()
		tri.price=p_array[0]
		dino_list.add_child(tri)
