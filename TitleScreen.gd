extends Node


func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	
	
	
func _physics_process(delta):
	pass



func _on_TextureButton_pressed():
	get_tree().change_scene("res://World.tscn")
	



func _on_TextureButton2_pressed():
	get_tree().quit()
