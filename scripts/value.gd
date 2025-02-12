@tool
extends VBoxContainer

@export var text : String = "value"
@export var Targets : Array
@export var IsPanel : bool = false
@export var target_values : Array
@export var value_c : Color
@export var value_i : int
@export var does_save : bool = false
@export var global_save : bool = false

var hide_it = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		$text.text = text
		$CBtn.color = value_c
		#$CBtn.get_picker().visible = false
		var CP : ColorPicker = $CBtn.get_picker()
		var PP : PopupPanel = $CBtn.get_popup()
		#PP.borderless = false
		#PP.unresizable = false
		#PP.size = Vector2i(1200, 1200)
		var alphaslider = HSlider.new()
		alphaslider.tick_count = 32
		alphaslider.max_value = 255
		alphaslider.rounded = true
		alphaslider.custom_minimum_size = Vector2(0, 64)
		var vbx = VBoxContainer.new()
		vbx.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbx.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		PP.add_child(vbx)
		var panelcontainer = PanelContainer.new()
		panelcontainer.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		panelcontainer.custom_minimum_size = Vector2(0, 512)
		panelcontainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		PP.get_child(1).add_child(panelcontainer)
		PP.get_child(1).add_child(alphaslider)
		CP.offset_right = 256
		CP.scale = Vector2(2, 2)
		CP.sampler_visible = false
		CP.color_modes_visible = false
		CP.sliders_visible = false
		CP.hex_visible = false
		CP.presets_visible = false
		CP.picker_shape = ColorPicker.SHAPE_HSV_WHEEL
		CP.custom_minimum_size = Vector2(512, 612)
		CP.pivot_offset = Vector2(256 ,0)
		CP.scale = Vector2(2, 2)
		var al : HSlider = PP.get_child(1).get_child(1)
		al.set_position(Vector2(0, 500))
		al.value_changed.connect(_on_alpha_slider_change)
		al.drag_ended.connect(_on_slpha_slider_stop)
		#al.pivot_offset = Vector2(0,200)
		#al.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		if does_save:
			if Global.AppData.has(text):
				value_c = Color(Global.AppData[text])
	await Global.appdata_loading_done
	if global_save:
		if !Global.AppData.has("Colors"): Global.AppData["Colors"] = {}
		if !Global.AppData["Colors"].has(text): Global.AppData["Colors"][text] = value_c.to_html()
		set_value(Color(Global.AppData["Colors"][text]))
		print_rich("[color=#" + Global.AppData["Colors"][text] + "]" + Global.AppData["Colors"][text] + " ---> " + text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$text.text = text
		$CBtn.color = value_c
	if hide_it:
		DisplayServer.virtual_keyboard_hide()

func _on_slpha_slider_stop():
	if does_save:
		Global.AppData["Colors"][text] = str(value_c.to_html())
		print(Global.AppData)


func _on_c_btn_color_changed(color):
	Global.AppData["Colors"][text] = str(value_c.to_html())
	print(Global.AppData["Colors"][text])
	DisplayServer.virtual_keyboard_hide()
	hide_it = false
	value_c = color
	for tgt in Targets:
		var Target = get_node(tgt)
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
	#DisplayServer.virtual_keyboard_show("", Rect2(0,0,0,0), 0)
	var PP : PopupPanel = $CBtn.get_popup()
	var CP : ColorPicker = $CBtn.get_picker()
	var AP : HSlider = PP.get_child(1).get_child(1)
	CP.custom_minimum_size = Vector2(512, 612)
	CP.pivot_offset = Vector2(256 ,0)
	CP.scale = Vector2(2, 2)
	AP.value = CP.color.a*255
	#print(CP.color.a)
	await get_tree().process_frame
	DisplayServer.virtual_keyboard_hide()
	await get_tree().process_frame
	await get_tree().process_frame
	DisplayServer.virtual_keyboard_hide()

func _on_alpha_slider_change(end_value):
	var CP : ColorPicker = $CBtn.get_picker()
	CP.color.a = end_value/255.0
	$CBtn.color = CP.color
	_on_c_btn_color_changed(CP.color)
	


func _on_c_btn_toggled(toggled_on):
	if toggled_on:
		hide_it = true
	else:
		hide_it = false
		
