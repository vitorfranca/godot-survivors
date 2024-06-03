class_name HitFlashComponent
extends Node

@export var hit_flash_material: ShaderMaterial
@export var health_component: HealthComponent
@export var sprite: Sprite2D

var hit_flash_tween: Tween


func _ready():
	health_component.health_updated.connect(on_health_updated)
	sprite.material = hit_flash_material

func on_health_updated(_amount: float):
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", .8)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
