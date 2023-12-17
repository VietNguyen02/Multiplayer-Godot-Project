extends RigidBody3D

var _sphere_location : Vector3 = Vector3.ZERO

# The threshold value for the z-axis to switch scenes
const Z_THRESHOLD = -25.0
const Z_THRESHOLD_2 = 25.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the sphere location variable with its current position
	_sphere_location = global_transform.origin

	# Check if the sphere has reached the threshold in the z-axis
	if _sphere_location.z < Z_THRESHOLD:
		# Call a function to change the scene or perform any other action
		switch_win_scene()
	elif _sphere_location.z > Z_THRESHOLD_2:
		switch_lose_scene()

# Getter function to access sphereLocation
func get_sphere_location() -> Vector3:
	return _sphere_location

# Function to switch the scene
func switch_win_scene():
	# Replace "res://new_scene.tscn" with the path to your new scene
	get_tree().change_scene_to_file("res://win_screen.tscn")

# Function to switch the scene
func switch_lose_scene():
	# Replace "res://new_scene.tscn" with the path to your new scene
	get_tree().change_scene_to_file("res://game_over_screen.tscn")
