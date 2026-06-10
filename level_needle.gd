extends Sprite2D

var bus_index: int

func _ready() -> void:
    bus_index = AudioServer.get_bus_index("Recordable")


func _process(_delta: float) -> void:
    var magnitude = AudioServer.get_bus_peak_volume_left_db(bus_index, 0)
    rotation = deg_to_rad(-18.5 + 100 * min(max(magnitude - -30, 0) / 30, 1))
