extends "res://ships/ship-ctrl.gd"

func _ready():
	connect("tuningChanged", self, "_on_comfort_tuning_changed")
	_on_comfort_tuning_changed()

func _on_comfort_tuning_changed():
	if isPlayerControlled():
		var hname = layerHudName if layerHudName else "Hud"
		var default_comfort = autopilotComfortEnabled
		var comfort_enabled = getTunedValue(hname, "TUNE_AUTOPILOT_COMFORT", default_comfort)
		autopilotComfortEnabled = comfort_enabled
		if not comfort_enabled:
			autopilotComfort = false
