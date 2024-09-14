extends Control

@onready var notebase = preload("res://scenes/note.tscn")

var note_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.control = $"."
	Global.notetop = %NotesTop
	Global.Load()
	for nt in Global.AllNotes:
		var sss = []
		if nt.has("settings"):
			sss = nt["settings"]
		add_note_NR(nt["title"], nt["ingredients"], nt["checks"], sss)
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
	
func add_note_NR(title, ingredients, checks, settings):
	note_count += 1
	var newnote = notebase.instantiate()
	newnote.set_title(title)
	var fori = 0
	for i in ingredients:
		newnote.add_ingredient(i, checks[fori])
		fori += 1
	fori = 0
	for s in settings:
		newnote.set_setting(fori, Color(s))
		#print_rich("[color=#", Color(s).to_html(), "] COLOR SET AS: ", s)
		fori += 1
	%NotesTop.add_child(newnote)

func _on_add_pressed():
	note_count += 1
	add_note("New Note", ["..."], [false])
	
func carry_note_down(index):
	print("CALLED ", index)
	var the_one = %NotesTop.get_child(index)
	%NotesTop.move_child(the_one, index+1)
	Global.Refresh()
	
func carry_note_up(index):
	if index > 0:
		print("CALLED ", index)
		var the_one = %NotesTop.get_child(index)
		%NotesTop.move_child(the_one, index-1)
		Global.Refresh()
