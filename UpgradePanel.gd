extends MarginContainer

var fname
var description
var price
onready var name_label=$Panel/HBoxContainer/VBoxContainer/Name
onready var desc_label=$Panel/HBoxContainer/Description
onready var price_label=$Panel/HBoxContainer/Price

func _ready():
	name_label.text=fname
	desc_label.text=description
	price_label.text=Game.visually_pleasing(price)

