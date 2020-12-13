extends Control

signal Back

var Loading = true

func _ready():
	LoadSettings()
	Loading = false

func LoadSettings():
	$Sound/Music/MusicSlider.value = Global.MusicVolume
	$Sound/Effects/EffectsSlider.value = Global.SoundEffectsVolume
	$Sound/Control/FullscreenCheckbox.pressed = Global.Fullscreen

func _on_MusicSlider_value_changed(value):
	Global.MusicVolume = value
	Global.SetAudioVolume()

func _on_EffectsSlider_value_changed(value):
	Global.SoundEffectsVolume = value
	Global.SetAudioVolume()
	if not $Sound/Effects/SoundEffectDemo.playing and not Loading:
		$Sound/Effects/SoundEffectDemo.play()

func _on_FullscreenCheckbox_pressed():
	Global.Fullscreen = $Sound/Control/FullscreenCheckbox.pressed
	OS.window_fullscreen = Global.Fullscreen

func _on_SettingsBack_pressed():
	Global.SaveSettings()
	emit_signal("Back")
