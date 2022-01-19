extends MarginContainer


var fname=""
var period=5
var clutch=1
var price_coefficient=1.1

onready var nameLabel=$Panel/HBoxContainer/VBoxContainer/Name
onready var profitLabel=$Panel/HBoxContainer/VBoxContainer/Profit
onready var priceLabel=$Panel/HBoxContainer/Price
onready var amountLabel=$Panel/HBoxContainer/Amount

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.dinos[fname]=0
	Game.eggs[fname]=0
	Game.stats["%s Eggs Produced" % fname]=0
	nameLabel.text=fname
	priceLabel.text=String(Game.dino_prices[fname])+"$"
	amountLabel.text=String(Game.dinos[fname])
	profitLabel.text="Produces "+String(clutch)+" eggs every "+String(period)+" seconds"
	#profitLabel.bbcode_text="[center]Produces [color=purple]%d[/color] eggs every [color=purple]%d[/color] seconds[/center]" % [clutch,period]
	$Timer.wait_time=period

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	amountLabel.text="Owned: "+String(Game.dinos[fname])

func _on_Sell_pressed():
	if(Game.dinos[fname]>=1):
		Game.money+=Game.dino_prices[fname]*0.75
		Game.dinos[fname]-=1
		amountLabel.text=String(Game.dinos[fname])
		Game.dino_prices[fname]=Game.dino_prices[fname]/price_coefficient
		priceLabel.text=String(ceil(Game.dino_prices[fname]))+"$"

func _on_Button_pressed():
	if(Game.money>=Game.dino_prices[fname]):
		Game.money-=Game.dino_prices[fname]
		Game.dinos[fname]+=1
		amountLabel.text=String(Game.dinos[fname])
		Game.dino_prices[fname]=Game.dino_prices[fname]*price_coefficient
		priceLabel.text=String(ceil(Game.dino_prices[fname]))+"$"



func _on_Timer_timeout():
	Game.eggs[fname]+=clutch*Game.dinos[fname]
	Game.stats["%s Eggs Produced" % fname]+=clutch*Game.dinos[fname]
	Game.stats["Eggs Produced (all-time)"]+=clutch*Game.dinos[fname]
