extends Control

@onready var notebase = preload("res://scenes/note.tscn")

var note_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.control = $"."
	Global.notetop = %NotesTop
	Global.Load()
	for nt in Global.AllNotes:
		add_note_NR(nt["title"], nt["ingredients"], nt["checks"])
		print_rich("[color=green]", nt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer.add_theme_constant_override("margin_bottom", DisplayServer.virtual_keyboard_get_height())
	
func add_note(title, ingredients, checks):
	note_count += 1
	var newnote = notebase.instantiate()
	newnote.set_title(title)
	var fori = 0
	for i in ingredients:
		newnote.add_ingredient(i, checks[fori])
		fori += 1
	%NotesTop.add_child(newnote)
	Global.Refresh()
	
func add_note_NR(title, ingredients, checks):
	note_count += 1
	var newnote = notebase.instantiate()
	newnote.set_title(title)
	var fori = 0
	for i in ingredients:
		newnote.add_ingredient(i, checks[fori])
		fori += 1
	%NotesTop.add_child(newnote)

func _on_add_pressed():
	note_count += 1
	add_note("New Note", ["..."], [false])
