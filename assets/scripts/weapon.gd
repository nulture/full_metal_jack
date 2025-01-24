
class_name Weapon extends Node3D

@export var anim_player : AnimationPlayer

var _health : int = 10
@export var health : int = 10 :
	get: return _health
	set(value):
		if _health == value: return
		_health = value

		if _health == 0:
			queue_free()
			if drops_detritus:
				drop_detritus()

@export var bullet_scene : PackedScene
@export var bullet_spawn_location : Node3D
@export var projectile_count : int = 1
@export var bullet_cost : int = 1
@export var fire_rate : float = 1.0

@export var detritus_scene : PackedScene

var _is_shooting : bool
@export var is_shooting : bool :
	get: return _is_shooting
	set(value):
		if _is_shooting == value: return
		_is_shooting = value

var drops_detritus : bool = true

# func _physics_process(delta: float) -> void:


func fire(ammo: Ammo) -> void:
	if anim_player.is_playing(): anim_player.stop()
	anim_player.play("fire")
	health -= 1
	ammo.consume_bullets(bullet_cost)
	for i in projectile_count:
		create_bullet(ammo.get_parent())


func create_bullet(shooter: Node3D) -> void:
	var projectile : Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_rotation = bullet_spawn_location.global_rotation
	projectile.global_position = bullet_spawn_location.global_position
	projectile.populate(shooter)


func drop_detritus() -> void:
	var detritus : Detritus = detritus_scene.instantiate()
	get_tree().root.add_child(detritus)
	detritus.global_position = self.global_position