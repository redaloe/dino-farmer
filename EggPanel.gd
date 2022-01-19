extends MarginContainer


var fname=""
var price=10

onready var nameLabel=$Panel/HBoxContainer/VBoxContainer/Name
onready var profitLabel=$Panel/HBoxContainer/VBoxContainer/Profit
onready var priceLabel=$Panel/HBoxContainer/Price
onready var amountLabel=$Panel/HBoxContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	nameLabel.text=fname+" Egg"
	Game.market[fname]=price
	priceLabel.text=String(price)+"$"
	amountLabel.text=String(Game.eggs[fname])
	Game.dinos[fname]=0
	Game.eggs[fname]=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	amountLabel.text="Owned: "+String(Game.eggs[fname])
	priceLabel.text="%.2f$" % Game.market[fname]


func _on_Button_pressed():
	if(Game.eggs[fname]>0):
		Game.add_money(Game.market[fname]*Game.eggs[fname])
		Game.market[fname]=Game.market[fname]/((Game.eggs[fname]/100)+1)
		Game.stats["Eggs Sold (all-time)"]+=Game.eggs[fname]
		Game.eggs[fname]=0



	
