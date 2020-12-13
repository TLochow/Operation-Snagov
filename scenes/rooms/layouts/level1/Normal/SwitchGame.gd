extends "res://scenes/rooms/layouts/LayoutBase.gd"

onready var Light1 = $Lights/Sprite
onready var Light2 = $Lights/Sprite2
onready var Light3 = $Lights/Sprite3
onready var Light4 = $Lights/Sprite4

var Light1On = true
var Light2On = true
var Light3On = true
var Light4On = true

var Active = true
var Solved = false

func _ready():
	var startLight = randi() % 4
	match startLight:
		0:
			Light1On = false
		1:
			Light2On = false
		2:
			Light3On = false
		3:
			Light4On = false
	SetLights()
	._ready()

func _process(delta):
	if Solved and EnemyNode.get_child_count() == 0:
		Active = false
		emit_signal("Cleared")
		set_process(false)

func SetLights():
	if Active:
		SetLight(Light1, Light1On)
		SetLight(Light2, Light2On)
		SetLight(Light3, Light3On)
		SetLight(Light4, Light4On)
		Solved = Light1On and Light2On and Light3On and Light4On

func SetLight(light, on):
	if on:
		light.modulate = Color(0.0, 0.7, 0.0, 1.0)
	else:
		light.modulate = Color(0.7, 0.0, 0.0, 1.0)

func _on_Button_Pressed():
	Light1On = not Light1On
	Light2On = not Light2On
	SetLights()

func _on_Button2_Pressed():
	Light1On = not Light1On
	Light2On = not Light2On
	Light3On = not Light3On
	SetLights()

func _on_Button3_Pressed():
	Light2On = not Light2On
	Light3On = not Light3On
	Light4On = not Light4On
	SetLights()

func _on_Button4_Pressed():
	Light3On = not Light3On
	Light4On = not Light4On
	SetLights()
