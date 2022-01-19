extends MarginContainer


var fname=""
var price=10
var period=5
var clutch=1

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
	priceLabel.text=String(price)+"$"
	amountLabel.text=String(Game.dinos[fname])
	profitLabel.text="Produces "+String(clutch)+" eggs every "+String(period)+" seconds"
	#profitLabel.bbcode_text="[center]Produces [color=purple]%d[/color] eggs every [color=purple]%d[/color] seconds[/center]" % [clutch,period]
	$Timer.wait_time=period

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	amountLabel.text="Owned: "+String(Game.dinos[fname])



func _on_Button_pressed():
	if(Game.money>=price):
		Game.money-=price
		Game.dinos[fname]+=1
		amountLabel.text=String(Game.dinos[fname])
		price=ceil(price*1.1)
		priceLabel.text=String(price)+"$"



func _on_Timer_timeout():
	Game.eggs[fname]+=clutch*Game.dinos[fname]
	Game.stats["%s Eggs Produced" % fname]+=clutch*Game.dinos[fname]
	Game.stats["Eggs Produced (all-time)"]+=clutch*Game.dinos[fname]
