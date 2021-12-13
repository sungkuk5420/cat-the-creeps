extends Area2D
signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
# Add this variable to hold the clicked position.
var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	
var isMobile = false;

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		target = event.position
		speed = 800 
		isMobile = true

func _process(delta):
	var velocity = Vector2()
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10 and isMobile:
		velocity = target - position
	
	if(velocity[0] == 0 and velocity[1] == 0) :
		isMobile = false

# Remove keyboard controls.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		speed = 400 
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		speed = 400 
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		speed = 400 
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		speed = 400 
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	print(body)
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
