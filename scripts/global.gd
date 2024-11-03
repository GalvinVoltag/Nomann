extends Node

var control : Control
var notetop
var defaultnote

var Stt_Alert_Share = true

var AppData : Dictionary = {
	
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
	var file = FileAccess.open("user://file_data.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(AllNotes))
	file.close()
	
func Load():
	AllNotes.clear()
	if JSON.parse_string(FileAccess.get_file_as_string("user://file_data.json")) != null:
		AllNotes = JSON.parse_string(FileAccess.get_file_as_string("user://file_data.json"))
	if JSON.parse_string(FileAccess.get_file_as_string("user://AppData.json")) != null:
		AppData = JSON.parse_string(FileAccess.get_file_as_string("user://AppData.json"))
	defaultnote.match_note_to_json(DefaultNote)
	print(AllNotes)

func save_default_note():
	var dnf = FileAccess.open("user://defaultnote.json", FileAccess.WRITE)
	dnf.store_string(JSON.stringify(DefaultNote))
	dnf.close()

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
	var dnf = FileAccess.get_file_as_string("user://defaultnote.json")
	if JSON.parse_string(dnf) != null:
		DefaultNote = JSON.parse_string(dnf)
	else:
		var file = FileAccess.open("user://defaultnote.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(DefaultNote))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
