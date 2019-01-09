# RedShirt
extends Node

const CATEGORY = "shirt"
const ANIMATION = preload("res://game/objects/scenes/RedShirt/children/AnimatedSprite.tscn")
const KINEMATIC_BODY = preload("res://game/objects/scenes/RedShirt/children/KinematicBody2D.tscn")
const TEXTURE_RECT = preload("res://game/objects/scenes/RedShirt/children/TextureRect.tscn")
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