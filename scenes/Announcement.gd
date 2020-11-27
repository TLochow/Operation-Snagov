extends PanelContainer

var Title = ""
var Description = ""

func _ready():
	$VBoxContainer/TitleLabel.text = Title
	$VBoxContainer/DescriptionLabel.text = Description
	$AnimationPlayer.play("Announcement")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
