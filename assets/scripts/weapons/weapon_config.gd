
class_name WeaponConfig extends Node3D

signal weapon_added

@export var weapon_scene : PackedScene
@export var ammo : Ammo

@onready var cooldown : Timer = $cooldown

var fire_direction : Vector3

@export var sockets : Array[Node3D]
var max_sockets : int :
	get: return sockets.size()
var visible_weapons : Array[Weapon] :
	get:
		var result : Array[Weapon]
		for socket in sockets:
			if socket.get_child_count() == 0: continue
			var weapon_ := socket.get_child(0)
			if weapon_ is Weapon:
				result.push_back(weapon_)
		return result

var available_socket : Node3D :
	get:
		for socket in sockets:
			if socket.get_child_count() > 0:	continue
			return socket
		return null

var unhealthiest_weapon : Weapon :
	get:
		var result : Weapon = null
		var health := 100000
		for weapon in visible_weapons:
			if weapon.health < health:
				result = weapon
				health = weapon.health
		return result

var is_all_sockets_full : bool :
	get: return visible_weapons.size() == max_sockets

var _is_shooting : bool
var is_shooting : bool :
	get: return _is_shooting
	set(value):
		if _is_shooting == value: return
		_is_shooting = value
		_set_is_shooting(_is_shooting)


func _ready() -> void:
	pass


func _set_is_shooting(value: bool) -> void:
	if value: cooldown.start()
	else: cooldown.stop()


func try_add_weapon() -> bool:
	var socket := available_socket
	weapon_added.emit()
	if socket:
		socket.add_child(weapon_scene.instantiate())
		return true
	return false

func drop_weapon_pickups() -> void:
	for weapon in visible_weapons:
		weapon.drop_pickup()
