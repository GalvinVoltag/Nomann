extends Node

var control : Control
var notetop

var AllNotes = [
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
		for ing in nt.find_child("List").get_children():
			current["ingredients"].append(ing.get_text())
			current["checks"].append(ing.get_check())
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
	var data = FileAccess.get_file_as_string("user://file_data.json")
	if JSON.parse_string(data) != null:
		AllNotes = JSON.parse_string(data)
	else:
		var file = FileAccess.open("user://file_data.json", FileAccess.WRITE)
		file.store_line(JSON.stringify(AllNotes))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
