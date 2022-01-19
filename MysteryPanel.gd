extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var price=69

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.mystery_panel=self
	$Panel/HBoxContainer/Price.bbcode_text="[center]Unlocks after you've made [color=purple]%d$[/color][/center]" % price

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
