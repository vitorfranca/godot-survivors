class_name AnvilAbility extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var gpu_particles_2d = $GPUParticles2D


func emit_particles():
	gpu_particles_2d.emitting = true

