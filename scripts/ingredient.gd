extends HBoxContainer

@onready var pen = preload("res://icons/Edit.png")
@onready var chk = preload("res://icons/Check.png")
@onready var dlt = preload("res://icons/Delete.png")

func get_text():
	return $Element.text
	
func get_check():
	return $Left/CheckBox/Check.visible

func switch():
	$Left/CheckBox/Check.visible = !$Left/CheckBox/Check.visible
	
func set_text(new_text):
	$TextEdit.text = new_text
	$Element.text = new_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if $TextEdit.visible:
		if $TextEdit.text == "":
			$".".queue_free()
		$Element.text = $TextEdit.text
		%icon.texture = pen
	else:
		%icon.texture = chk
		$TextEdit.set_caret_column($TextEdit.text.length())
		$TextEdit.grab_focus()
		$TextEdit.start_action(TextEdit.ACTION_TYPING)
	$TextEdit.visible = !$TextEdit.visible
	$Element.visible = !$Element.visible
	Global.Refresh()


func _on_check_box_pressed():
	$Left/CheckBox/Check.visible = !$Left/CheckBox/Check.visible
	Global.Refresh()


func _on_text_edit_text_changed():
	if $TextEdit.text == "":
		%icon.texture = dlt
	else:
		%icon.texture = chk
