
class_name Weapon extends Node3D

signal fired

@export var anim_player : AnimationPlayer

var _health : int = 10
@export var health : int = 10 :
	get: return _health
	set(value):
		if _health == value: return
		_health = value

		if _health == 0:
			if drops_detritus:
				drop_detritus()
			close.call_deferred()

@export var bullet_scene : PackedScene
@export var bullet_spawn_location : Node3D
@export var projectile_count : int = 1
@export var bullet_cost : int = 1
@export var fire_rate : float = 1.0

@export var detritus_scene : PackedScene
@export var audio_stream : AudioStream = preload("res://assets/audio/pistol_fire.tres")

var _is_shooting : bool
@export var is_shooting : bool :
	get: return _is_shooting
	set(value):
		if _is_shooting == value: return
		_is_shooting = value

var drops_detritus : bool = true

# func _physics_process(delta: float) -> void:


func fire(ammo: Ammo, direction := Vector3.ZERO) -> void:
	if ammo.health == 0: return
	if anim_player.is_playing(): anim_player.stop()
	anim_player.play("fire")
	health -= 1
	ammo.consume_bullets(bullet_cost)
	for i in projectile_count:
		create_bullet(ammo.get_parent(), direction)
	fired.emit()


func create_bullet(shooter: Node3D, direction := Vector3.ZERO) -> void:
	var projectile : Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = bullet_spawn_location.global_position
	if direction :
		projectile.look_at(projectile.global_position + direction)
	else:
		projectile.global_rotation = bullet_spawn_location.global_rotation
	projectile.populate(shooter, audio_stream)


func drop_detritus() -> void:
	var detritus : Detritus = detritus_scene.instantiate()
	get_tree().root.add_child(detritus)
	detritus.global_position = self.global_position


func close() -> void:
	self.visible = false
	var gp := self.global_position
	var tree := get_tree()
	get_parent().remove_child(self)
	tree.root.add_child(self)
	self.global_position = gp
	await get_tree().create_timer(5.0).timeout
	queue_free()
