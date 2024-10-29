@tool
extends VBoxContainer

@export var text : String = "value"
@export var Target : Control
@export var IsPanel : bool = false
@export var target_values : Array
@export var value_c : Color
@export var value_i : int

var hide_it = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		$text.text = text
		$CBtn.color = value_c
		var CP : ColorPicker = $CBtn.get_picker()
		var PP : PopupPanel = $CBtn.get_popup()
		CP.scale = Vector2(1, 1)
		CP.custom_minimum_size = Vector2(800, 600)
		#PP.get_child(4).get_child(4).get_child(1).hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$text.text = text
		$CBtn.color = value_c
	if hide_it:
		DisplayServer.virtual_keyboard_hide()
		


func _on_c_btn_color_changed(color):
	DisplayServer.virtual_keyboard_hide()
	hide_it = false
	value_c = color
	if IsPanel:
		var m : StyleBoxFlat = Target.get_theme_stylebox("panel").duplicate()
		Target.remove_theme_stylebox_override("panel")
		for str in target_values:
			m.set(str, color)
		Target.add_theme_stylebox_override("panel", m)
	else:
		for str in target_values:
			Target.remove_theme_color_override(str)
			Target.add_theme_color_override(str, color)
			
func get_value():
	return value_c
	
func set_value(value):
	$CBtn.color = value
	_on_c_btn_color_changed(value)
	


func _on_c_btn_pressed():
	#DisplayServer.virtual_keyboard_hide()
	#DisplayServer.virtual_keyboard_show("", Rect2(0,0,0,0), 0)
	pass


func _on_c_btn_toggled(toggled_on):
	if toggled_on:
		hide_it = true
	else:
		hide_it = false
