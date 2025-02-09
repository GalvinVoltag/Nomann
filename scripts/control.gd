extends Control

@onready var notebase = preload("res://scenes/note.tscn")

var LOVE = ""
var note_count = 0
var setting_on = false
var murl = "https://galvinvoltag.github.io/galvinvoltag.com/nomann"

func get_bnumber(s):
	match s[0]:
		"a": return 1
		"b": return 2
		"t": return 3
	return int(s)

func compare_versions(ver_a:String, ver_b:String): #returns true if the first one is biger
	var st = ver_a.substr(1, -1).split("-")
	var version_a = [int(st[0].split(".")[0]), int(st[0].split(".")[1]), int(st[0].split(".")[2]), get_bnumber(st[1].split(".")[0]), int(st[1].split(".")[1])]
	st = ver_b.substr(1, -1).split("-")
	var version_b = [int(st[0].split(".")[0]), int(st[0].split(".")[1]), int(st[0].split(".")[2]), get_bnumber(st[1].split(".")[0]), int(st[1].split(".")[1])]
	for i in 5:
		if version_a[i] > version_b[i]: return true
		if version_a[i] < version_b[i]: return false
	return false

func strip_bbcode(text):
	var re = RegEx.new()
	re.compile("\\[.*?\\]")
	return re.sub(text, "", true)

func get_version_text():
	return "nah"

func add_note_from_json(nt : Dictionary):
	var sss = []
	if nt.has("settings"):
		sss = nt["settings"]
	add_note_NR(nt["title"], nt["ingredients"], nt["checks"], sss)
	print("added note from json")


func add_note_from_url(url : String):
	if url.length() < 8: return
	var whole = []
	var notes = []
	var checks = []
	var title = ""
	for s in url.split("/"):
		whole.append(s)
	title = str(whole[1]).substr(6)
	var preventfirst = true
	for s in str(whole[2]).substr(6).split("[0]"):
		var noloop = true
		for ss in s.split("[1]"):
			notes.append(ss)
			if noloop:
				checks.append(false)
				noloop = false
			else:
				checks.append(true)
	notes.remove_at(0)
	checks.remove_at(0)
	var nt : Dictionary
	nt["title"] = title
	nt["ingredients"] = notes
	nt["checks"] = checks
	add_note_NR(nt["title"], nt["ingredients"], nt["checks"], Global.DefaultNote["settings"])
	print("added note from url --->", checks)

func version_control():
	print_rich("[color=red]=====================================================\\")
	
	%VersionText.text = ".."
	var VET         # VErsion Text
	var colortext = "white"
	match Global.version.split("-")[1][0]:
		"a": colortext = "purple"
		"b": colortext = "maroon"
		"t": colortext = "cyan"
	%VersionText.text = "..."
	VET = Global.version.split("-")[0] + "[color=" + colortext + "]-" + Global.version.split("-")[1] + "\n" + "[color=white]"
	%VersionText.text = VET + "."
	
	$VersionControl.request_completed.connect(_on_version_control)
	$VersionControl.request("https://api.github.com/repos/GalvinVoltag/Nomann/releases")
	
	print_rich("[color=red]=====================================================/")

func _on_version_control(result, response, headers, body):
	if result != 3:
		%VersionText.text = %VersionText.text + "."
		var json = JSON.parse_string(body.get_string_from_utf8())
		LOVE = json[0]["tag_name"]    # Latest Online VErsion
		print(LOVE)
		var VET = %VersionText.text.substr(0, %VersionText.text.length()-2)
		var colortext = "white"
		match LOVE.split("-")[1][0]:
			"a": colortext = "purple"
			"b": colortext = "maroon"
			"t": colortext = "cyan"
		VET = VET + LOVE.split("-")[0] + "[color=" + colortext + "]-" + LOVE.split("-")[1] + "\n"
		%VersionText.text = VET
		if compare_versions(LOVE, Global.version):
			$UpdateDialog.set_text("[center]There is a newer version ( " + LOVE.split("-")[0] + "[color=" + colortext + "]-" + LOVE.split("-")[1] + "[color=white] ) available, update now?")
			$UpdateDialog.popup()
			await $UpdateDialog.done
			if $UpdateDialog.answer:
				OS.shell_open(json[0]["assets"][0]["browser_download_url"])

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		setting_on = false
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_everything()

# Called when the node enters the scene tree for the first time.
func _ready():
	version_control()
	#add_note_from_url("/title=[shake]To do for app/notes=[1][u]customization[1][color=brown]sharing notes[0][font_size=99]rearrangement[0][pulse][b]sound effects[0][rainbow]animations")
	Global.control = $"."
	Global.notetop = %NotesTop
	Global.defaultnote = %"Default Note"
	Global.share = %Share
	Global.setting = %Setting
	Global.Load()
	for nt in Global.AllNotes:
		var sss = []
		if nt.has("settings"):
			sss = nt["settings"]
		add_note_NR(nt["title"], nt["ingredients"], nt["checks"], sss, true)
		print_rich("[color=green]", nt)
	%SettingsM.size.y = get_viewport_rect().size.y
	%ExtJson.text = ("\n>" + $Deeplink.get_link_path())
	add_note_from_url($Deeplink.get_link_path())
	Global.Refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer.add_theme_constant_override("margin_bottom", DisplayServer.virtual_keyboard_get_height())
	if setting_on:
		%SettingsM.position.x = ( %SettingsM.position.x*(0.1/delta) + 0 ) / (1 + (0.1/delta))
	else:
		%SettingsM.position.x = ( %SettingsM.position.x*(0.1/delta) - 1080 ) / (1 + (0.1/delta))
	
func add_note(title, ingredients, checks):
	note_count += 1
	var newnote = notebase.instantiate()
	newnote.set_title(title)
	var fori = 0
	for i in ingredients:
		newnote.add_ingredient(i, checks[fori])
		fori += 1
	%NotesTop.add_child(newnote)
	%NotesTop.move_child(%NotesTop.get_child(-1), 0)
	Global.Refresh()
	
func add_note_NR(title, ingredients, checks, settings, skiporder = false):
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
	if !skiporder:
		%NotesTop.move_child(%NotesTop.get_child(-1), 0)

func _on_add_pressed():
	note_count += 1
	add_note_from_json(Global.DefaultNote)
	
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


func _on_settings_pressed():
	setting_on = true


func _on_stt_bck_pressed():
	setting_on = false


func _on_add_ext_pressed():
	add_note_from_json(%ExtJson.text)
	%ExtJson.clear()


func _on_paste_pressed():
	%ExtJson.text = DisplayServer.clipboard_get()

func _on_clear_ext_pressed():
	%ExtJson.clear()





func _on_deeplink_deeplink_received(url):
	%ExtJson.text = ("\n>" + $Deeplink.get_link_path())
	add_note_from_url($Deeplink.get_link_path())
	Global.Refresh()
	$Deeplink.clear_data()
