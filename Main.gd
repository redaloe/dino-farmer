extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dino_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/DinoContainer
onready var dino_panel= load("res://DinoPanel.tscn")
onready var money_label=$MainScreen/MarginContainer2/Panel/VBoxContainer/Money
onready var dino_grid=$MainScreen/Panel/MarginContainer/DinoGrid
# Called when the node enters the scene tree for the first time.
func _ready():
	Game.main=self
	addDinoButton("Eoraptor",10,1)
	
	Game.money=10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	money_label.text="Money: "+String(Game.money)+"$"
	if Game.money>100 and !("Velociraptor" in Game.dinos):
		addDinoButton("Velociraptor",100,10)
	if Game.money>1000 and !("Triceratops" in Game.dinos):
		addDinoButton("Triceratops",1000,100)
		
func add_sprite(sprite):
	var c=Container.new()
	var spr= Sprite.new()
	spr.texture=load(sprite)
	spr.scale.x=0.1
	spr.scale.y=0.1
	c.add_child(spr)
	dino_grid.add_child(c)
	print(dino_grid.get_children())
func addDinoButton(fname:String,price:int,profit:int):
	var tri= dino_panel.instance()
	tri.fname=fname
	tri.profit=profit
	tri.price=price
	dino_list.add_child(tri)
