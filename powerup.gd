extends Area2D

var kind = "shield" # main.gd sets this before adding it

func _ready():
	$Sprite2D.texture = load("res://art/powerup_" + kind + ".png")

func _on_area_entered(area):
	# the player is the only area (only player gets a powerup, never a mosquito) with this function
	if area.has_method("apply_powerup") and area.visible:
		area.apply_powerup(kind)
		queue_free()
