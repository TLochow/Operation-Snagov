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
	if StreamPlayer.playing:
		StreamPlayer.stop()
	else:
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
	var basePath = "res://sound/music/VoicesOfChristmasPast"
	var files = Global.GetAllFilesFromDirectory(basePath)
	for file in files:
		if file.ends_with(".import"):
			var song = load(basePath + "/" + file.replace(".import", ""))
			song.set_loop(false)
			Songs.append(song)
	SongCount = Songs.size()
