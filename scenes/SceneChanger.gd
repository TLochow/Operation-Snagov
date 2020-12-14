extends CanvasLayer

func ChangeScene(path):
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	$AnimationPlayer.play("FadeIn")

func EndGame():
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().quit()
