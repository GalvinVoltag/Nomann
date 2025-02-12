extends Node

signal appdata_loading_done

var control : Control
var notetop
var defaultnote
var share
var setting

var overwrite = false

var version = "v0.1.4-alpha.2"

var AppData : Dictionary = {
	"DefaultNote": {
		"title" = "New Note",
		"ingredients" = [
			"one",
			"two",
			"three"
		],
		"checks" = [
			true,
			true,
			false
		]
	},
	"Settings": {
		"automatic update": true,
		"test setting": false,
		"automatic save": false,
	},
	"Colors": {
		"Header Color": "fff01f"
	}
}

var DefaultColors : Array = [
	"7002706b",
	"00000000",
	"ffffff",
	"ccccccff",
	"2a2a2a5e",
	"2a2a2a00",
]

var DefaultNote : Dictionary = {
	"title" = "New Note",
	"ingredients" = [
		"one",
		"two",
		"three"
	],
	"checks" = [
		true,
		true,
		false
	]
}

var AllNotes : Array = [
	{
		"title" = "No Note :D",
		"ingredients" = [
			"this is first",
			"this is the second",
			"aand, this is the last one."
		],
		"checks" = [
			true,
			true,
			false
		]
	},
	{
		"title" = "Yessir!  >:I",
		"ingredients" = [
			"you go offff",
			"turn on man"
		],
		"checks" = [
			false,
			true
		]
	}
]

func RefreshLater():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Refresh()

func Refresh():
	AllNotes.clear()
	var cont = notetop
	for nt in cont.get_children():
		var current = {}
		current["title"] = nt.get_title()
		current["ingredients"] = []
		current["checks"] = []
		current["settings"] = []
		for ing in nt.find_child("List").get_children():
			current["ingredients"].append(ing.get_text())
			current["checks"].append(ing.get_check())
		var i = 0
		for sttng in nt.AllSettings:
			current["settings"].append(sttng.get_value().to_html())
			i+=1
		AllNotes.append(current)
	print_rich("[color=orange]", AllNotes)


func Load():
	if overwrite: save_everything()
	AllNotes.clear()
	if JSON.parse_string(FileAccess.get_file_as_string("user://file_data.json")) != null:
		AllNotes = JSON.parse_string(FileAccess.get_file_as_string("user://file_data.json"))
	if JSON.parse_string(FileAccess.get_file_as_string("user://AppData.json")) != null:
		AppData = JSON.parse_string(FileAccess.get_file_as_string("user://AppData.json"))
	else: save_everything()
	DefaultNote = AppData["DefaultNote"]
	defaultnote.match_note_to_json(DefaultNote)
	print_rich("[color=gold] !!!!!!!!!!!!!!! initializing !!!!!!!!!!!!!!!")
	print_rich("[color=gold]" + JSON.stringify(AppData))
	print_rich("[color=gold]iiiiiiiiiiiiiiiiii intialized iiiiiiiiiiiiiiiiii[color=white]")
	appdata_loading_done.emit()
	var first = true
	for s in AppData["Settings"]:
		if first:
			setting.get_child(0).text = s
			setting.get_child(1).button_pressed = AppData["Settings"][s]
			first = false
		else:
			var newstt = setting.duplicate()
			newstt.get_child(0).text = s
			newstt.get_child(1).button_pressed = AppData["Settings"][s]
			setting.get_parent().add_child(newstt)
		print("for for for for for")

func save_everything():
	DefaultNote = (defaultnote.get_note_json())
	AppData["DefaultNote"] = DefaultNote
	var dnf = FileAccess.open("user://AppData.json", FileAccess.WRITE)
	dnf.store_string(JSON.stringify(AppData))
	dnf.close()
	var file = FileAccess.open("user://file_data.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(AllNotes))
	file.close()
	#save_default_note()

func save_default_note():
	AppData["DefaultNote"] = DefaultNote
	save_everything()

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = FileAccess.get_file_as_string("user://AppData.json")
	if JSON.parse_string(data) == null:
		data = FileAccess.open("user://AppData.json", FileAccess.WRITE)
		data.store_string("")
		data.close()
	data = FileAccess.get_file_as_string("user://file_data.json")
	if JSON.parse_string(data) != null:
		AllNotes = JSON.parse_string(data)
	else:
		var file = FileAccess.open("user://file_data.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(AllNotes))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
