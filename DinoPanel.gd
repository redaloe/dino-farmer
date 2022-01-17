extends MarginContainer


var fname=""
var price=10
var amount=0
var profit=1

onready var nameLabel=$Panel/HBoxContainer/VBoxContainer/Name
onready var profitLabel=$Panel/HBoxContainer/VBoxContainer/Profit
onready var priceLabel=$Panel/HBoxContainer/Price
onready var amountLabel=$Panel/HBoxContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	nameLabel.text=fname
	priceLabel.text=String(price)+"$"
	amountLabel.text=String(amount)
	profitLabel.text=String(profit)+"$/s"
	Game.dinos[fname]=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Button_pressed():
	if(Game.money>=price):
		Game.money-=price
		amount+=1
		amountLabel.text=String(amount)
		Game.dinos[fname]+=1
		print(Game.dinos)


func _on_Timer_timeout():
	Game.money+=profit*amount
