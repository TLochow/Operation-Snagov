extends Control

signal Back

var MusicVolume = 0.0
var SoundEffectsVolume = 0.0

var Loading = true

func _ready():
	LoadSettings()
	Loading = false

func LoadSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	if result == OK:
		MusicVolume = config.get_value("settings", "music_volume", 0.0)
		SoundEffectsVolume = config.get_value("settings", "sound_effects_volume", 0.0)
	SetAudioVolume()
	$Sound/Music/MusicSlider.value = MusicVolume
	$Sound/Effects/EffectsSlider.value = SoundEffectsVolume

func SaveSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	config.set_value("settings", "music_volume", MusicVolume)
	config.set_value("settings", "sound_effects_volume", SoundEffectsVolume)
	config.save("user://settings.cfg")

func SetAudioVolume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), MusicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), SoundEffectsVolume)

func _on_MusicSlider_value_changed(value):
	MusicVolume = value
	SetAudioVolume()

func _on_EffectsSlider_value_changed(value):
	SoundEffectsVolume = value
	SetAudioVolume()
	if not $Sound/Effects/SoundEffectDemo.playing and not Loading:
		$Sound/Effects/SoundEffectDemo.play()

func _on_SettingsBack_pressed():
	SaveSettings()
	emit_signal("Back")
