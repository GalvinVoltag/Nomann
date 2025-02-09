extends PanelContainer

@onready var ingredient = preload("res://scenes/ingredient.tscn")
@onready var chk = preload("res://icons/Check.png")
@onready var dlt = preload("res://icons/Delete.png")

@export var AllSettings: Array[Control]

var singleton = null
var murl = "https://galvinvoltag.github.io/galvinvoltag.com/nomann"


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

func encode_uri_component(uri: String) -> String:
	# Characters that don't need to be encoded
	var safe_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!~*'()"
	var encoded = ""
	
	for i in range(uri.length()):
		var c = uri[i]
		if safe_chars.find(c) != -1:
			encoded += c
		else:
			# Convert character to UTF-8 bytes and percent-encode each byte
			var bytes = c.to_utf8_buffer()
			for byte in bytes:
				encoded += "%%%02X" % byte
	return encoded

func get_note_json():
	var current = {}
	current["title"] = get_title()
	current["ingredients"] = []
	current["checks"] = []
	current["settings"] = []
	for ing in find_child("List").get_children():
		current["ingredients"].append(ing.get_text())
		current["checks"].append(ing.get_check())
	var i = 0
	for sttng in AllSettings:
		current["settings"].append(sttng.get_value().to_html())
		i+=1
	return current

func get_note_url():
	var title = encode_uri_component(get_title())
	var notes = ""
	for ing in find_child("List").get_children():
		notes += encode_uri_component("[" + str(int(ing.get_check())) + "]" + ing.get_text())
	return murl + "?title=" + title + "&notes=" + notes

func match_note_to_json(nt : Dictionary):
	#var nt = JSON.parse_string(str)
	var sss = []
	if nt.has("settings"):
		sss = nt["settings"]
		var fori = 0
		for i in nt["settings"]:
			set_setting(fori, nt["settings"][fori])
			fori+=1
	set_title(nt["title"])
	var fori = 0
	for i in nt["ingredients"]:
		add_ingredient(i, nt["checks"][fori])
		fori+=1
	#add_note_NR(nt["title"], nt["ingredients"], nt["checks"], sss)

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
	if Engine.has_singleton("GodotShare"):
		singleton = Engine.get_singleton("GodotShare")


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
		Global.RefreshLater()
		$".".queue_free()
	else: 
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
	%titleToggle.button_pressed = true
	%Head.visible = true
	Global.Refresh()


func _on_title_toggle_toggled(toggled_on):
	%Head.visible = toggled_on

func _on_shr_pressed():
	Global.share.share_text(get_note_json()["title"], "", get_note_url())
	#singleton.shareText("tite", "subject", "Test line share complete")
	#DisplayServer.clipboard_set(JSON.stringify(get_note_json(), "   ", true, false))
	#DisplayServer.clipboard_set(get_note_url())
	#if Global.Stt_Alert_Share:
		#OS.alert("The list has been copied to clipboard", "Success!")
	
	
