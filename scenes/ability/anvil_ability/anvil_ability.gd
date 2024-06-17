class_name AnvilAbility extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var gpu_particles_2d = $GPUParticles2D

var base_area: int = 24


func emit_particles():
	gpu_particles_2d.emitting = true


func set_damage_area(increased_amount: int):
	%DamageArea.shape.radius = base_area + increased_amount
	%GPUParticles2D.process_material.emission_sphere_radius = base_area + increased_amount
	print(%DamageArea.shape.radius)

