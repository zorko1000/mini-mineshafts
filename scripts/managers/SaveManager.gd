# SaveManager.gd (Autoload)
# Proposed by Claude, untested
#
extends Node

const SAVE_FILE = "user://savegame.save"

func save_game(data: Dictionary):
    var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    save_file.store_string(JSON.stringify(data))
    save_file.close()

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_FILE):
        return {}
    
    var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
    var json_string = save_file.get_as_text()
    save_file.close()
    
    var json = JSON.new()
    var parse_result = json.parse(json_string)
    return json.data if parse_result == OK else {}