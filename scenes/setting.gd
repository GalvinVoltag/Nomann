extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(1).toggled.connect(_on)

func _on(state):
	Global.AppData["Settings"][get_child(0).text] = state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
