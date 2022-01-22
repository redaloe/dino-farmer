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
func _process(_delta):
	if Game.upgrade_variables["sell_100"]==1:
		$Panel/HBoxContainer/Buy100.show()
	else:
		$Panel/HBoxContainer/Buy100.hide()
	if Game.upgrade_variables["sell_all"]==1:
		$Panel/HBoxContainer/BuyAll.show()
	else:
		$Panel/HBoxContainer/BuyAll.hide()
	if !(fname in Game.dinos):
		print("zift")
		queue_free()
	else:
		amountLabel.text="Owned: "+String(Game.eggs[fname])
		priceLabel.text=Game.visually_pleasing(Game.market[fname])
		if(Game.eggs[fname]<1):
			$Panel/HBoxContainer/Buy.disabled=true
			$Panel/HBoxContainer/Buy100.disabled=true
			$Panel/HBoxContainer/BuyAll.disabled=true
		else:
			$Panel/HBoxContainer/Buy.disabled=false
			$Panel/HBoxContainer/Buy100.disabled=false
			$Panel/HBoxContainer/BuyAll.disabled=false

func _on_Button_pressed():
	if(Input.is_key_pressed(KEY_SHIFT)):
		if(Game.eggs[fname]>=10):
			print("meep")
			Game.add_money(Game.market[fname]*10)
			Game.market[fname]=Game.market[fname]/1.1
			Game.stats["Eggs Sold (all-time)"]+=10
			Game.eggs[fname]-=10
			Game.current_eggs-=10
		elif(Game.eggs[fname]<10):
			Game.add_money(Game.market[fname]*Game.eggs[fname])
			Game.market[fname]=Game.market[fname]/((Game.eggs[fname]/100)+1)
			Game.stats["Eggs Sold (all-time)"]+=Game.eggs[fname]
			Game.eggs[fname]=0
			Game.current_eggs=0
	elif(Game.eggs[fname]>0):
		Game.add_money(Game.market[fname])
		Game.market[fname]=Game.market[fname]/(1.004)
		Game.stats["Eggs Sold (all-time)"]+=1
		Game.eggs[fname]-=1
		Game.current_eggs-=1

		
func _on_Buy100_pressed():
	if(Game.eggs[fname]>=100):
		Game.add_money(Game.market[fname]*100)
		Game.market[fname]=Game.market[fname]/((1)+1)
		Game.stats["Eggs Sold (all-time)"]+=100
		Game.eggs[fname]-=100
		Game.current_eggs-=100
	elif(Game.eggs[fname]<100):
		Game.add_money(Game.market[fname]*Game.eggs[fname])
		Game.market[fname]=Game.market[fname]/((Game.eggs[fname]/100)+1)
		Game.stats["Eggs Sold (all-time)"]+=Game.eggs[fname]
		Game.eggs[fname]=0
		Game.current_eggs=0
		
func _on_BuyAll_pressed():
	if(Game.eggs[fname]>0):
		Game.add_money(Game.market[fname]*Game.eggs[fname])
		Game.market[fname]=Game.market[fname]/((Game.eggs[fname]/100)+1)
		Game.stats["Eggs Sold (all-time)"]+=Game.eggs[fname]
		Game.eggs[fname]=0
		Game.current_eggs=0



	
