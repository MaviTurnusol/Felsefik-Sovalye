extends Camera2D

var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
var NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
var SHAKE_DECAY_RATE: float = 5.0

var rand = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()

var noise_i: float = 0.0

var shake_strength: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	position = Vector2(320, 140)
	UnlimitedRulebook.cam = self
	pass # Replace with function body.

func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	offset = get_noise_offset(delta)
	position = (Vector2(320, 140)+Vector2(320, 140)+Vector2(320, 140)+UnlimitedRulebook.player.global_position)/4
	pass

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
