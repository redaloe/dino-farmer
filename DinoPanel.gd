extends MarginContainer


var fname=""
var period=5
var clutch=1
var price_coefficient=1.1

onready var nameLabel=$Panel/HBoxContainer/VBoxContainer/Name
onready var profitLabel=$Panel/HBoxContainer/VBoxContainer/Profit
onready var priceLabel=$Panel/HBoxContainer/Price
onready var amountLabel=$Panel/HBoxContainer/Amount

func _ready():
		Game.dinos[fname]=0
		Game.eggs[fname]=0
		Game.stats["%s Eggs Produced" % fname]=0
		nameLabel.text=fname
	#	amountLabel.text=String(Game.dinos[fname])
		profitLabel.text="Produces "+String(clutch)+" eggs every "+String(period)+" seconds"
		profitLabel.bbcode_text="[center]Produces [color=yellow]%d[/color] eggs every [color=yellow]%d[/color] seconds[/center]" % [clutch,period]
		$Timer.wait_time=period

func _process(_delta):
	if !(fname in Game.dinos):
		print("zift")
		queue_free()
	else:
		if Game.current_dinos==1:
			$Panel/HBoxContainer/VBoxContainer2/Sell.hint_tooltip="Gives back 100% of original price"
		else:
			$Panel/HBoxContainer/VBoxContainer2/Sell.hint_tooltip="Gives back 75% of original price"
		amountLabel.text="Owned: "+String(Game.dinos[fname])
		priceLabel.text=Game.visually_pleasing(Game.dino_prices[fname])
		if (Game.money<Game.dino_prices[fname]):
			$Panel/HBoxContainer/VBoxContainer2/Buy.disabled=true
		else:
			$Panel/HBoxContainer/VBoxContainer2/Buy.disabled=false
		if (Game.dinos[fname]<1):
			$Panel/HBoxContainer/VBoxContainer2/Sell.disabled=true
		else:
			$Panel/HBoxContainer/VBoxContainer2/Sell.disabled=false
		
func _on_Sell_pressed():
	if(Game.dinos[fname]>=1):
		if Game.current_dinos==1:
			Game.money+=Game.dino_prices[fname]/price_coefficient
		else:
			Game.money+=Game.dino_prices[fname]*0.75
		Game.dinos[fname]-=1
		Game.current_dinos-=1
		amountLabel.text=String(Game.dinos[fname])
		Game.dino_prices[fname]=Game.dino_prices[fname]/price_coefficient
		priceLabel.text=String(ceil(Game.dino_prices[fname]))+"$"

func _on_Button_pressed():
	if(Game.money>=Game.dino_prices[fname]) and (Game.current_dinos<Game.upgrade_variables["max_dinos"]):
		Game.money-=Game.dino_prices[fname]
		Game.dinos[fname]+=1
		Game.current_dinos+=1
		amountLabel.text=String(Game.dinos[fname])
		Game.dino_prices[fname]=Game.dino_prices[fname]*price_coefficient
		priceLabel.text=Game.visually_pleasing(Game.dino_prices[fname])
	else:
		print(Game.upgrade_variables["max_dinos"])

func _on_Timer_timeout():
	if(Game.current_eggs<Game.upgrade_variables["max_eggs"]):
		Game.eggs[fname]+=clutch*Game.dinos[fname]
		Game.stats["%s Eggs Produced" % fname]+=clutch*Game.dinos[fname]
		Game.stats["Eggs Produced (all-time)"]+=clutch*Game.dinos[fname]
		Game.current_eggs+=clutch*Game.dinos[fname]
