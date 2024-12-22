class_name PlayerState extends State

const IDLE := "Idle"
const MOVE := "Move"
const DIG := "Dig"
const THUMP := "Thump"
const HIDE := "Hide"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The player state type must be used only in the player scene. It needs the owner to be a player node.")
