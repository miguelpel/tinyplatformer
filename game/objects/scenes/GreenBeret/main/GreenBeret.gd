# GreenBeret
extends Node

const CATEGORY = "hat"
const ANIMATION = preload("res://game/objects/scenes/GreenBeret/children/AnimatedSprite.tscn")
const KINEMATIC_BODY = preload("res://game/objects/scenes/GreenBeret/children/KinematicBody2D.tscn")
const TEXTURE_RECT = preload("res://game/objects/scenes/GreenBeret/children/TextureRect.tscn")
const VALUE = 3
#const THROW_FORCE = 100
#var timer
var current_owner

func _ready():
#	$AnimatedSprite.hide()
#	$KinematicBody2D.hide()
#	$TextureRect.hide()
#	print("ready")
	pass

func create_animation():
	var animation = ANIMATION.instance()
	animation.object_ref = self
	return animation
	pass

func create_tex_icon():
	var tex_rect = TEXTURE_RECT.instance()
	tex_rect.object_ref = self
	return tex_rect

func create_kin_body():
	var kin_body = KINEMATIC_BODY.instance()
	kin_body.object_ref = self
	return kin_body

func delete_animation():
	pass

func _process(delta):
	pass