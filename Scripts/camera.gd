extends Camera3D

@export var smooth_speed: float = 10.0

var smoothed_transform: Transform3D
var target: Transform3D

func _ready():
	smoothed_transform = global_transform

func _process(delta: float) -> void:
	# Always follow the SpringArm AFTER it updates
	var parent_arm := get_parent() as SpringArm3D
	if parent_arm == null:
		return

	target = parent_arm.global_transform

	# Smooth position
	smoothed_transform.origin = smoothed_transform.origin.lerp(
		target.origin,
		delta * smooth_speed
	)

	# Smooth rotation (with orthonormalization)
	var new_basis := smoothed_transform.basis.slerp(
		target.basis,
		delta * smooth_speed
	).orthonormalized()

	smoothed_transform.basis = new_basis

	# Apply the smoothed transform
	global_transform = smoothed_transform
