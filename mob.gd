extends RigidBody2D

var base_velocity = Vector2.ZERO # normal speed, used to undo the slow power-up

func _ready():
	$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited():
	# remove from the list of instances when leaves the visible screen
	queue_free()
