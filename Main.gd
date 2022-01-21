extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dino_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Dinos
onready var upgrade_panels=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Upgrades
onready var egg_list=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Eggs
onready var egg_panel=load("res://EggPanel.tscn")
onready var dino_panel= load("res://DinoPanel.tscn")
onready var mystery_panel= load("res://MysteryPanel.tscn")
onready var money_label=$MainScreen/Panel/HBoxContainer/Money
onready var timer_label=$MainScreen/Panel/HBoxContainer/TimerLabel
#onready var dino_grid=$MainScreen/Panel/MarginContainer/DinoGrid
var starter_dino="Eoraptor"
# Called when the node enters the scene tree for the first time.
func _ready():
	var r
	var p
	var d_list=File.new()
	d_list.open("res://dinos.json", File.READ)
	if !validate_json(d_list.get_as_text()):
		r= parse_json(d_list.get_as_text())
	else:
		print("Invalid Dinos.json")
	d_list.open("res://upgrades.json", File.READ)
	if !validate_json(d_list.get_as_text()):
		p=parse_json(d_list.get_as_text())
	else:
		print("Invalid Upgrades.json")
	d_list.close()
	Game.dino_list=r
	Game.upgrade_list=p
	Game.main=self
	Game.money=r[starter_dino]["price"]
	add_dino_button(starter_dino)
	add_unknown_panel()
	#load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	money_label.text="Money: "+Game.visually_pleasing(Game.money)
	timer_label.text="Egg market updates in: %02d" % ($MarketTimer.time_left+1)
	update_stats()
	
	for dino in Game.dino_list:
			if !(dino in Game.dinos):
				if Game.stats["Money (all-time)"] >= (Game.dino_list[dino]["unlock_price"]):
					add_dino_button(dino)
	
	for upgrade in Game.upgrade_list:
		if !(upgrade in Game.unlocked_upgrades or upgrade in Game.completed_upgrades):
			check_upgrade_condition(upgrade)

#func add_sprite(sprite):
#	var c=Container.new()
#	var spr= Sprite.new()
#	spr.texture=load(sprite)
#	spr.scale.x=0.1
#	spr.scale.y=0.1
#	c.add_child(spr)
#	dino_grid.add_child(c)
#	print(dino_grid.get_children())

func add_dino_button(fname:String):
	var d=Game.dino_list[fname]
	var tri= dino_panel.instance()
	tri.fname=fname
	Game.dino_prices[fname]=d["price"]
	tri.period=d["period"]
	tri.clutch=d["clutch"]
	dino_list.add_child(tri)
	var bi= egg_panel.instance()
	bi.fname=fname
	bi.price=d["egg_price"]
	egg_list.add_child(bi)
	add_unknown_panel()

func add_upgrade_panel(fname:String):
	var p= load("res://UpgradePanel.tscn")
	var d= Game.upgrade_list[fname]
	var tri= p.instance()
	tri.display_name=d["name"]
	tri.fname=fname
	tri.price=d["price"]
	tri.description=d["description"]
#	tri.clutch=d["clutch"]
	upgrade_panels.add_child(tri)

func switch_panel(node:Control):
	var a=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer
	for b in a.get_children():
		b.hide()
	node.show()


func _on_DinoTab_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Dinos)


func _on_EggTab_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Eggs)


func _on_SettingTab_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Settings)

func _on_TutTab_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Tut)

func _on_Stats_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Stats)

func save_game():
	var s= File.new()
	var button=get_node("MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Settings/HBoxContainer2/1").group.get_pressed_button().name
	print(button)
	if !(s.open("res://save%s.sav"%button, File.WRITE)):
		var save_data=[Game.dinos,Game.eggs,Game.money,Game.market,Game.stats,Game.dino_prices,Game.completed_upgrades,Game.unlocked_upgrades,Game.upgrade_variables]
		print("saving")
		s.store_var(save_data)
		s.close()
	else:
		print("Saving failed!")

func load_game():
	var s= File.new()
	var button=get_node("MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Settings/HBoxContainer2/1").group.get_pressed_button().name
	if !(s.open("res://save%s.sav"%button, File.READ)):
		var a=s.get_var()
		print("loading")
		for dino in a[0]: # this HAS to be before game.dinos=a[0] or else it wont work
			if !(dino in Game.dinos):
				add_dino_button(dino)
		Game.dinos=a[0]
		Game.dino_prices=a[5]
		Game.eggs=a[1]
		Game.money=a[2]
		Game.market=a[3]
		Game.stats=a[4]
		Game.completed_upgrades=a[6]
#		Game.unlocked_upgrades=[]
		if a.size()==8:
			Game.unlocked_upgrades=a[7]
		if a.size()==9:
			Game.upgrade_variables=a[8]
			
		s.close()
	else:
		print("Loading Failed!")

func _on_Save_pressed():
	save_game()

func _on_Load_pressed():
	load_game()


func _on_MarketTimer_timeout():
	for d in Game.market:
		var correction=(Game.dino_list[d]["egg_price"]-Game.market[d])*0.375
		if abs(Game.dino_list[d]["egg_price"]-(Game.market[d]+correction))>0.25:
		#if the difference between base price and corrected price is less than 0.5, just set price to base price
		#to prevent zeno's paradox
			Game.market[d]+=correction
		else:
			Game.market[d]=Game.dino_list[d]["egg_price"]
	if Game.autosave:
		save_game()

func add_unknown_panel():
	if Game.mystery_panel != null:
		Game.mystery_panel.queue_free()
	var p_array=[]
	for d in Game.dino_list:
		if !(d in Game.dinos.keys()):
			p_array.append(Game.dino_list[d]["unlock_price"])
	p_array.sort()
	if p_array.size()>0:
		var tri= mystery_panel.instance()
		tri.price=p_array[0]
		dino_list.add_child(tri)

func update_stats():
	var stat_label=$MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Stats/StatLabel
	stat_label.bbcode_text=""
	for stat in Game.stats:
		stat_label.append_bbcode("%s: [color=gold]%s[/color] \n" % [stat,floor(Game.stats[stat])])

func check_upgrade_condition(fname):
	var conditions={"money":Game.money,"total_money":Game.stats["Money (all-time)"],"total_eggs":Game.stats["Eggs Produced (all-time)"]}
	var u=Game.upgrade_list[fname]
	var cond=u["unlock_condition"]
	var am=u["unlock_amount"]
	if conditions[cond]>=am:
		add_upgrade_panel(fname)
		Game.unlocked_upgrades.append(fname)

		

func _on_Autosave_toggled(button_pressed):
	Game.autosave=button_pressed




func _on_Upgrades_pressed():
	switch_panel($MainScreen/MarginContainer2/Panel/VBoxContainer/ScrollContainer/Upgrades)
	Game.money+=50
