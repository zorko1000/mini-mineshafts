extends Node

# Scene references
var main_level_scene: Node = null

func register_level_scene(main_level: Node):
    """
    Register the current level scene as the main level scene
    """
    self.main_level_scene = main_level

func level_bounds() -> Rect2:
    """
    Returns the camera limits as a Rect2 representing the level bounds.
    """
    if main_level_scene == null:
        return Rect2()
    var camera: Camera2D = main_level_scene.get_node_or_null("Camera2D")
    if camera == null:
        return Rect2()
    var left: float = camera.limit_left
    var right: float = camera.limit_right
    var top: float = camera.limit_top
    var bottom: float = camera.limit_bottom
    return Rect2(left, top, right - left, bottom - top)