extends Node

onready var IsDebug = OS.is_debug_build()

var MusicVolume = 0.0
var SoundEffectsVolume = 0.0

var Fullscreen = true

signal Announcement(title, description)
signal Won

var ROOMSCENE = preload("res://scenes/rooms/Room.tscn")
var LevelGenBlockedCoords = []

var CurrentLevel = 1

var TopEffectsNode
var DebrisNode
var PickupsNode

var BloodHandler

func _ready():
	randomize()
	LoadSettings()

func LoadDefaults():
	CurrentLevel = 1
	KillCounter = 0
	GameOver = false
	
	CloverLeaf = false
	
	PlayerHealth = 10
	PlayerMaxHealth = 10
	PlayerGrenades = 3
	PlayerArmor = 0
	PlayerMoney = 0
	
	PlayerShootCooldown = 1.0
	PlayerShotSpread = 0.05
	PlayerShotAmount = 1.0
	PlayerShotDamage = 1.0
	PlayerMoveSpeed = 100.0
	
	PlayerImpactDetector = false
	PlayerGrenadeLauncher = false
	PlayerFlameThrower = false
	PlayerBlastShield = false
	PlayerFlameShield = false
	PlayerShield = false
	PlayerDrone = false
	PlayerDefenisveDrones = false
	PlayerRevenge = false

var KillCounter
var GameOver
var Won

var CloverLeaf

var PlayerHealth
var PlayerMaxHealth
var PlayerGrenades
var PlayerArmor
var PlayerMoney

var PlayerShootCooldown
var PlayerShotSpread
var PlayerShotAmount
var PlayerShotDamage
var PlayerMoveSpeed

var PlayerImpactDetector
var PlayerGrenadeLauncher
var PlayerFlameThrower
var PlayerBlastShield
var PlayerFlameShield
var PlayerShield
var PlayerDrone
var PlayerDefenisveDrones
var PlayerRevenge

func GetAllFilesFromDirectory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not dir.current_is_dir():
			files.append(file)
	dir.list_dir_end()
	return files

func ReparentNode(child, newParent):
	var oldParent = child.get_parent()
	oldParent.call_deferred("remove_child", child)
	newParent.call_deferred("add_child", child)

func LoadSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	if result == OK:
		MusicVolume = config.get_value("settings", "music_volume", 0.0)
		SoundEffectsVolume = config.get_value("settings", "sound_effects_volume", 0.0)
		Fullscreen = config.get_value("settings", "fullscreen", true)
	SetAudioVolume()
	OS.window_fullscreen = Fullscreen

func SaveSettings():
	var config = ConfigFile.new()
	var result = config.load("user://settings.cfg")
	config.set_value("settings", "music_volume", MusicVolume)
	config.set_value("settings", "sound_effects_volume", SoundEffectsVolume)
	config.set_value("settings", "fullscreen", Fullscreen)
	config.save("user://settings.cfg")

func SetAudioVolume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), MusicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), SoundEffectsVolume)
