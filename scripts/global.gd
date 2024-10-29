extends Node

var control : Control
var notetop

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

var SharedNote : Dictionary = {
	"title" = "SharedNote%42ERR&nullptr0x000066",
		"ingredients" = [
			"",
			"",
			"&nullptr0x000066"
		],
		"checks" = [
			false,
			false,
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
	AllNotes = JSON.parse_string(FileAccess.get_file_as_string("user://file_data.json"))
	print(AllNotes)

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("Android"):
		var args = OS.get_cmdline_args()
		for arg in args:
			if arg.begins_with("nomann://note/"):
				var data = arg.substr(13)
				
	if Engine.has_singleton("GodotApp"):
		var godot_app = Engine.get_singleton("GodotApp")
		var url_data = godot_app.getUrlData()
		print("UrlData: ", url_data)
	else:
		print("No Singleton")
	var data = FileAccess.get_file_as_string("user://file_data.json")
	if JSON.parse_string(data) != null:
		AllNotes = JSON.parse_string(data)
	else:
		var file = FileAccess.open("user://file_data.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(AllNotes))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
