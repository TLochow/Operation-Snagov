extends Control

var MusicVolume = 0.0
var SoundEffectsVolume = 0.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _ready():
	get_tree().paused = false
	MusicHandler.Stop()
	LoadSettings()

func LoadSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	if result == OK:
		MusicVolume = config.get_value("settings", "music_volume", 0.0)
		SoundEffectsVolume = config.get_value("settings", "sound_effects_volume", 0.0)
	SetAudioVolume()
	$Settings/Sound/Music/MusicSlider.value = MusicVolume
	$Settings/Sound/Effects/EffectsSlider.value = SoundEffectsVolume

func SaveSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	config.set_value("settings", "music_volume", MusicVolume)
	config.set_value("settings", "sound_effects_volume", SoundEffectsVolume)
	config.save("user://settings.cfg")

func SetAudioVolume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), MusicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), SoundEffectsVolume)

func _on_StartGame_pressed():
	Global.LoadDefaults()
	SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _on_Settings_pressed():
	$Main.visible = false
	$Settings.visible = true

func _on_MusicSlider_value_changed(value):
	MusicVolume = value
	SetAudioVolume()

func _on_EffectsSlider_value_changed(value):
	SoundEffectsVolume = value
	SetAudioVolume()
	if not $Settings/Sound/Effects/SoundEffectDemo.playing and $Settings.visible:
		$Settings/Sound/Effects/SoundEffectDemo.play()

func _on_SettingsBack_pressed():
	$Main.visible = true
	$Settings.visible = false
	SaveSettings()

func _on_Music_finished():
	$Music.play()

func _on_Tutorial_pressed():
	pass # Replace with function body.

func _on_Exit_pressed():
	SceneChanger.EndGame()

func _on_Credits_pressed():
	$Credits.visible = true
	$Main.visible = false

func _on_CreditsBack_pressed():
	$Credits.visible = false
	$Main.visible = true

func _on_FullMusicList_pressed():
	$FullMusicList.visible = true
	$Credits.visible = false

func _on_MusicListBack_pressed():
	$FullMusicList.visible = false
	$Credits.visible = true
