extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _ready():
	get_tree().paused = false
	Engine.time_scale = 1.0
	MusicHandler.Stop()

func _on_StartGame_pressed():
	Global.LoadDefaults()
	SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _on_Settings_pressed():
	$Main.visible = false
	$Settings.visible = true

func _on_Settings_Back():
	$Main.visible = true
	$Settings.visible = false

func _on_Music_finished():
	$Music.play()

func _on_Tutorial_pressed():
	Global.LoadDefaults()
	Global.CurrentLevel = 0
	SceneChanger.ChangeScene("res://scenes/Level.tscn")

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

func _on_Intro_pressed():
	SceneChanger.ChangeScene("res://Intro.tscn")
