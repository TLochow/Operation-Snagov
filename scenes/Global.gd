extends Node

signal Announcement(title, description)

var ROOMSCENE = preload("res://scenes/rooms/Room.tscn")
var LevelGenBlockedCoords = []

var CurrentLevel = 1

var TopEffectsNode
var DebrisNode

var BloodHandler

func LoadDefaults():
	CurrentLevel = 1
	
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
	PlayerBlastShield = false
	PlayerShield = false
	PlayerDrone = false
	PlayerDefenisveDrones = false
	PlayerRevenge = false

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
var PlayerBlastShield
var PlayerShield
var PlayerDrone
var PlayerDefenisveDrones
var PlayerRevenge
