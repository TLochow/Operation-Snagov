extends Area2D

export(bool) var Extended = false

onready var Position = get_global_position()

func _ready():
	if Extended:
		$Sprite.frame = 2
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)

func Extend():
	Extended = true
	$AnimationPlayer.play("Extend")

func Retract():
	Extended = false
	$Sprite.frame = 0
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if Extended:
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)

func _on_Spikes_body_entered(body):
	if body.has_method("Damage"):
		body.Damage(1.0, Position, body.get_global_position() - Position, null)
