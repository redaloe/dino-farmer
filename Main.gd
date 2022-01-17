extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dino_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/DinoContainer
onready var dino_panel= load("res://DinoPanel.tscn")
onready var money_label=$MainScreen/MarginContainer2/Panel/VBoxContainer/Money
# Called when the node enters the scene tree for the first time.
func _ready():
	addDinoButton("Triceratops",10,1)
	
	Game.money=10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	money_label.text="Money: "+String(Game.money)+"$"
	if Game.money>50 and !("Velociraptor" in Game.dinos):
		addDinoButton("Velociraptor",50,2)\
		
func addDinoButton(fname:String,price:int,profit:int):
	var tri= dino_panel.instance()
	tri.fname=fname
	tri.profit=profit
	tri.price=price
	dino_list.add_child(tri)
