extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not Global.GameOver:
			if $ExitConfirmation.visible:
				ToggleExitConfirmation()
			TogglePause()

func TogglePause():
	var newPauseState = not get_tree().paused
	get_tree().paused = newPauseState
	visible = newPauseState

func ToggleExitConfirmation():
	var newConfirmState = not $ExitConfirmation.visible
	$ExitConfirmation.visible = newConfirmState
	$Normal.visible = not newConfirmState

func _on_ResumeButton_pressed():
	TogglePause()

func _on_ExitButton_pressed():
	ToggleExitConfirmation()

func _on_YesButton_pressed():
	SceneChanger.ChangeScene("res://MainMenu.tscn")

func _on_NoButton_pressed():
	ToggleExitConfirmation()
