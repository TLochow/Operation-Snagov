extends Control

var LabelNumber = 1
var FadeIn = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.ChangeScene("res://MainMenu.tscn")

func _ready():
	$AnimationPlayer.play("Intro")

func AdvanceText():
	if FadeIn:
		$Tween.interpolate_property(get_node("Labels/Label" + str(LabelNumber)), "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		FadeIn = false
	else:
		$Tween.interpolate_property(get_node("Labels/Label" + str(LabelNumber)), "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		FadeIn = true
		LabelNumber += 1

func EndMusic():
	$Tween.interpolate_property($Sound/Music, "volume_db", $Sound/Music.volume_db, -40.0, 4.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	SceneChanger.ChangeScene("res://MainMenu.tscn")

func _on_SkipButton_pressed():
	SceneChanger.ChangeScene("res://MainMenu.tscn")
