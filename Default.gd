extends Node

var DirCenter = Vector2(0.0, 0.0)
var DirUp = Vector2(0.0, -1.0)
var DirDown = Vector2(0.0, 1.0)
var DirLeft = Vector2(-1.0, 0.0)
var DirRight = Vector2(1.0, 0.0)

var RoomSize = Vector2(512.0, 256.0)

enum RoomTypes {
	Normal,
	Start,
	Boss,
	Shop,
	Item
}

enum PickupTypes {
	Health,
	Grenade,
	Armor,
	Money
}

enum Items {
	Pistol,
	DualWield,
	Shotgun,
	MachinePistol,
	BagOfGrenades,
	HeartyMeal,
	HealthKit,
	GlassCannon
}
