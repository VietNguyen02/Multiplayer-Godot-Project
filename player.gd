extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $PlayerInput

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera3D.current = true
	# Only process on the server.
	# EDIT: Left the client simulate player movement too to compensate for network latency.
	# set_physics_process(multiplayer.is_server())

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if input.jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset jump state.
	input.jumping = false

	# Handle movement.
	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	rotate_with_keys(delta)

	move_and_slide()

# Rotate the body based on the 'A' and 'D' keys.
func rotate_with_keys(delta):
	# Check 'A' key for left rotation.
	if Input.is_action_pressed("ui_rotate_left"):
		rotate_y_axis(ROTATION_SPEED * delta)
	# Check 'D' key for right rotation.
	elif Input.is_action_pressed("ui_rotate_right"):
		rotate_y_axis(-ROTATION_SPEED * delta)

# Rotate the body around the Y-axis.
func rotate_y_axis(angle):
	var current_rotation = atan2(-transform.basis[0].z, transform.basis[0].x)
	var new_rotation = current_rotation + angle
	transform.basis = Basis(Vector3(0, 1, 0), new_rotation)
