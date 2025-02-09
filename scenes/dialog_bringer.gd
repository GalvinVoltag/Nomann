extends MarginContainer

signal done

var popped = false
var answer = false

func set_text(text):
	$Mrg/V/dialogue.text = text

func popup():
	size.y = 0
	position.y = -size.y
	visible = true
	popped = true

func _yes_pressed():
	popped = false
	visible = false
	answer = true
	done.emit()

func _no_pressed():
	popped = false
	visible = false
	answer = false
	done.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mrg/V/H/Yes.pressed.connect(_yes_pressed)
	$Mrg/V/H/No.pressed.connect(_no_pressed)
	visible = false
	size.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		position.y = (position.y*24 + 0) / 25
