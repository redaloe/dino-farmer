extends MarginContainer


var fname=""
var current_price=10
var price=10

onready var nameLabel=$Panel/HBoxContainer/VBoxContainer/Name
onready var profitLabel=$Panel/HBoxContainer/VBoxContainer/Profit
onready var priceLabel=$Panel/HBoxContainer/Price
onready var amountLabel=$Panel/HBoxContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	nameLabel.text=fname+" Egg"
	current_price=price
	priceLabel.text=String(price)+"$"
	amountLabel.text=String(Game.eggs[fname])
	Game.dinos[fname]=0
	Game.eggs[fname]=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	amountLabel.text=String(Game.eggs[fname])



func _on_Button_pressed():
	if(Game.eggs[fname]>0):
		Game.money+=current_price*Game.eggs[fname]
		current_price-=current_price*0.01*Game.eggs[fname]
		Game.eggs[fname]=0
		amountLabel.text=String(Game.eggs[fname])
		priceLabel.text=String(round(current_price))+"$"


func _on_Timer_timeout():
	current_price+=(price-current_price)*0.5
	priceLabel.text=String(round(current_price))+"$"
