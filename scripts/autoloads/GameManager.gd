# GameManager.gd (Autoload)
# Suggested by Claude, untested
extends Node

signal game_state_changed(new_state)

enum GameManagerState { MENU, PLAYING, PAUSED, GAME_OVER }
var current_state: GameManagerState = GameManagerState.MENU

func change_state(new_state: GameManagerState) -> void:
    current_state = new_state
    game_state_changed.emit(new_state)
