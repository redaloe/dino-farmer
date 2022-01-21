extends MarginContainer

var fname
var display_name
var description
var price
onready var name_label=$Panel/HBoxContainer/VBoxContainer/Name
onready var desc_label=$Panel/HBoxContainer/Description
onready var price_label=$Panel/HBoxContainer/Price

func _ready():
	name_label.text=display_name
	desc_label.text=description
	price_label.text=Game.visually_pleasing(price)

func _process(_delta):
	if !(fname in Game.unlocked_upgrades):
		print("zift")
		queue_free()
	if fname in Game.completed_upgrades:
		print("zift2")
		queue_free()
	
	else:
		if (Game.money<Game.upgrade_list[fname]["price"]):
			$Panel/HBoxContainer/VBoxContainer2/Buy.disabled=true
		else:
			$Panel/HBoxContainer/VBoxContainer2/Buy.disabled=false


func _on_Button_pressed():
	var effects={"money":Game.money}
	var u=Game.upgrade_list[fname]
	var eff=u["effect"]
	var am=u["effect_amount"]
	if Game.money>=price:
		Game.money-=price
		if eff=="money":
			Game.money+=am
		else:
			effects[eff]+=am
	Game.completed_upgrades.append(fname)
	Game.unlocked_upgrades.pop_at(Game.unlocked_upgrades.find(fname))
	queue_free()
