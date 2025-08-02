# SceneManager.gd (Autoload)
# Suggested by Claude, untested
extends Node


var current_scene = null

func _ready():
    current_scene = get_tree().current_scene

func goto_scene(path: String):
    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
    current_scene.free()
    var new_scene = ResourceLoader.load(path)
    current_scene = new_scene.instantiate()
    get_tree().root.add_child(current_scene)
    get_tree().current_scene = current_scene
