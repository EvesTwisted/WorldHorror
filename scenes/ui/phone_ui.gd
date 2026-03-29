extends Control

signal stress_slider_changed(value: float)
signal graphics_button_pressed

func _ready() -> void:
	$VBoxContainer/StressSlider.value_changed.connect(_on_stress_slider_changed)
	$VBoxContainer/GraphicsButton.pressed.connect(_on_graphics_button_pressed)

func _on_stress_slider_changed(value: float) -> void:
	stress_slider_changed.emit(value)

func _on_graphics_button_pressed() -> void:
	graphics_button_pressed.emit()
