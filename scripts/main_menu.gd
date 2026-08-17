extends Control

@onready var settings_panel: PanelContainer = %SettingsPanel
@onready var about_panel: PanelContainer = %AboutPanel
@onready var fullscreen_toggle: CheckButton = %FullscreenToggle


func _ready() -> void:
	fullscreen_toggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_settings_pressed() -> void:
	about_panel.hide()
	settings_panel.show()


func _on_about_pressed() -> void:
	settings_panel.hide()
	about_panel.show()


func _on_fullscreen_toggled(enabled: bool) -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)


func _on_close_panel_pressed() -> void:
	settings_panel.hide()
	about_panel.hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and (settings_panel.visible or about_panel.visible):
		_on_close_panel_pressed()
		get_viewport().set_input_as_handled()
