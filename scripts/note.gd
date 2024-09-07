extends PanelContainer

@onready var ingredient = preload("res://scenes/ingredient.tscn")
@onready var chk = preload("res://icons/Check.png")
@onready var dlt = preload("res://icons/Delete.png")



func set_title(title):
	%Title.text = title
	
func get_title():
	return %Title.text
	
func add_ingredient(text, check = false):
	ingredient = preload("res://scenes/ingredient.tscn")
	var newi = ingredient.instantiate()
	newi.set_text(text)
	if check: newi.switch()
	$VBoxContainer/HBoxContainer/MarginText/List.add_child(newi)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_edit_note_pressed():
	var newi = ingredient.instantiate()
	$VBoxContainer/HBoxContainer/MarginText/List.add_child(newi)


func _on_title_button_pressed():
	%TitleEdit.text = %Title.text
	%Title.visible = false
	%Editor.visible = true
	%TitleButton.visible = false
	%Editor.grab_focus()

func _on_title_edit_text_changed():
	if %TitleEdit.text == "":
		%CheckBox.get_child(0).texture = dlt
	else:
		%CheckBox.get_child(0).texture = chk


func _on_check_box_pressed():
	if %TitleEdit.text == "":
		$".".queue_free()
	set_title(%TitleEdit.text)
	%Title.visible = true
	%Editor.visible = false
	%TitleButton.visible = true


