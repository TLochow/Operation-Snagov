extends Control

var Redirected = false

func _ready():
	var timeSinceStart = OS.get_ticks_msec()
	var restTimeMsec = max(2000.0 - timeSinceStart, 1.0)
	$Timer.wait_time = restTimeMsec / 1000.0
	$Timer.start()

func _on_Timer_timeout():
	if not Redirected:
		Redirected = true
		SceneChanger.ChangeScene("res://MainMenu.tscn")
