extends Sprite2D

var bus_index: int

func _ready() -> void:
    bus_index = AudioServer.get_bus_index("Recordable")


func _process(_delta: float) -> void:
    var magnitude = AudioServer.get_bus_peak_volume_left_db(bus_index, 0)
    # Magic numbers for desired dynamic range
    var volume_percentage = db_to_linear(magnitude) * 100
    rotation = deg_to_rad(volume_percentage)
