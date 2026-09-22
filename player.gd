extends Area2D
signal hit # custom hit signal indicating the goat is out of health
signal health_changed(health)
signal powerup_picked(kind)

# how fast a player would move (in pixels per sec)
@export var speed = 400
@export var max_health = 3
var screen_size # size of the game window
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # player's movement vector
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ = get_node() - a shortcut
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# the goat faces right, so flip it when going left
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_body_entered(body: Node2D) -> void:
	if health <= 0:
		return
	# shield kills the mosquito
	if not $ShieldTimer.is_stopped():
		body.queue_free()
		return
	# can't get hit again right after a bite
	if not $HurtTimer.is_stopped():
		return

	health -= 1
	health_changed.emit(health)
	body.queue_free()

	if health > 0:
		$HurtTimer.start()
		modulate.a = 0.5
	else:
		hide() # player disappears after the last bite
		hit.emit()
		# should be disabled because we can't change physics props on a physics callback
		$CollisionShape2D.set_deferred("disabled", true)

func apply_powerup(kind):
	if kind == "shield":
		$ShieldTimer.start()
		modulate = Color(0.5, 0.8, 1.0)
	if kind == "shrink":
		$ShrinkTimer.start()
		scale = Vector2(0.25, 0.25)
	if kind == "heart" and health < max_health:
		health += 1
		health_changed.emit(health)
	powerup_picked.emit(kind)

func _on_shield_timer_timeout():
	modulate = Color(1, 1, 1)

func _on_shrink_timer_timeout():
	scale = Vector2(0.5, 0.5)

func _on_hurt_timer_timeout():
	modulate.a = 1.0

# func to reset the player when starting a new game session
func start(pos):
	position = pos
	health = max_health
	health_changed.emit(health)
	$ShieldTimer.stop()
	$ShrinkTimer.stop()
	$HurtTimer.stop()
	modulate = Color(1, 1, 1)
	scale = Vector2(0.5, 0.5)
	show()
	$CollisionShape2D.disabled = false
