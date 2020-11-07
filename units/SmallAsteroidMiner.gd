extends Node2D

signal unit_selected(unit)
signal unit_deselected(unit)

var selected:bool = false setget _set_selected
var show_health:bool = false setget _set_show_health

func _set_show_health(value):
	show_health = value
	$KinematicBody2D/HUD/HealthBar.visible = value

func _set_selected(value):
	if selected and value:
		return
	elif selected and !value:
		selected = value
		emit_signal("unit_selected", self)
	elif !selected and value:
		selected = value
		emit_signal("unit_deselected", self)
	else:
		return
	$KinematicBody2D/HUD/SelectionHUD.visible = selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
