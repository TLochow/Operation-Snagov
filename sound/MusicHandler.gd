extends Node2D

var Songs = []
var SongCount
var PlayedSongs = []
onready var StreamPlayer = $AudioStreamPlayer

var Playing = false

func _ready():
	LoadSongs()

func Play():
	Playing = true
	StreamPlayer.stop()
	
	var songToPlay = randi() % SongCount
	while PlayedSongs.has(songToPlay):
		songToPlay = randi() % SongCount
	
	PlayedSongs.append(songToPlay)
	if PlayedSongs.size() > SongCount * 0.75:
		PlayedSongs.remove(0)
	
	StreamPlayer.stream = Songs[songToPlay]
	StreamPlayer.play()

func Stop():
	Playing = false
	StreamPlayer.stop()

func _on_AudioStreamPlayer_finished():
	if Playing:
		Play()

func LoadSongs():
	var basePath = "res://sound/music/Voices Of Christmas Past"
	var files = GetAllFilesFromDirectory(basePath)
	for file in files:
		if file.ends_with(".ogg"):
			var song = load(basePath + "/" + file)
			song.set_loop(false)
			Songs.append(song)
	SongCount = Songs.size()

func GetAllFilesFromDirectory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not dir.current_is_dir():
			files.append(file)
	dir.list_dir_end()
	return files
