extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dino_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Dinos
onready var egg_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Eggs
onready var egg_panel=load("res://EggPanel.tscn")
onready var dino_panel= load("res://DinoPanel.tscn")
onready var money_label=$MainScreen/Panel/HBoxContainer/Money
onready var dino_grid=$MainScreen/Panel/MarginContainer/DinoGrid
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var dino_list=File.new()
	dino_list.open("res://dinos.json", File.READ)
	var r= parse_json(dino_list.get_as_text())
	Game.dino_list=r
	Game.main=self
	add_dino_button("Eoraptor",10,1)
	
	Game.money=10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	money_label.text="Money: "+String(Game.money)+"$"
	for dino in Game.dino_list:
		if !(dino in Game.dinos):
			if Game.money >= (Game.dino_list[dino]["price"])*0.8:
				add_dino_button(dino)
		
func add_sprite(sprite):
	var c=Container.new()
	var spr= Sprite.new()
	spr.texture=load(sprite)
	spr.scale.x=0.1
	spr.scale.y=0.1
	c.add_child(spr)
	dino_grid.add_child(c)
	print(dino_grid.get_children())
	
func add_dino_button(fname:String):
	var tri= dino_panel.instance()
	tri.fname=fname
	tri.price=price
	dino_list.add_child(tri)
	var bi= egg_panel.instance()
	bi.fname=fname
	bi.price=price
	egg_list.add_child(bi)
	

			

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
