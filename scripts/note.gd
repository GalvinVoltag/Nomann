extends PanelContainer

@onready var ingredient = preload("res://scenes/ingredient.tscn")
@onready var chk = preload("res://icons/Check.png")
@onready var dlt = preload("res://icons/Delete.png")

@export var AllSettings: Array[Control]



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

func set_setting(index: int, value):
	AllSettings[index].set_value(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	var m : StyleBox = %Head.get_theme_stylebox("Panel")
	var mm = m.get_property_list()
	var mmm = 0
	var i = 0
	for z in mm:
		if z["name"] == "shadow_color":
			mmm = i
		i += 1
	print_rich("[color=red]", mmm , "   " , mm[mmm])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_edit_note_pressed():
	var newi = ingredient.instantiate()
	$VBoxContainer/HBoxContainer/MarginText/List.add_child(newi)
	Global.Refresh()


func _on_title_button_pressed():
	%TitleEdit.text = %Title.text
	%Title.visible = false
	%Editor.visible = true
	%TitleButton.visible = false
	%TitleEdit.set_caret_column(%TitleEdit.text.length())
	%TitleEdit.grab_focus()
	%TitleEdit.start_action(TextEdit.ACTION_TYPING)

	

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
	Global.Refresh()




func _on_more_toggled(toggled_on):
	%more_sett.visible = toggled_on


func _on_dn_pressed():
	get_node("/root/Control").carry_note_down(get_index())


func _on_up_pressed():
	get_node("/root/Control").carry_note_up(get_index())


func _on_rst_pressed():
	var i = 0
	for stg in AllSettings:
		stg.set_value(Global.DefaultColors[i])
		i += 1
	Global.Refresh()
