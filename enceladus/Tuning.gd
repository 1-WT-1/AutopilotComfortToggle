extends "res://enceladus/Tuning.gd"

func fillTuneableSystems():
	var ps = CurrentGame.getPlayerShip()
	var comfort_enabled = true
	if Tool.claim(ps):
		var hud_name = ps.layerHudName if ("layerHudName" in ps and ps.layerHudName) else "Hud"
		var hud = ps.get_node_or_null(hud_name)
		var default_comfort = ps.autopilotComfortEnabled if "autopilotComfortEnabled" in ps else true
		comfort_enabled = ps.getTunedValue(hud_name, "TUNE_AUTOPILOT_COMFORT", default_comfort)
		if hud and hud.has_method("registerSubsystem"):
			hud.registerSubsystem("TUNE_AUTOPILOT_COMFORT", {
				"type": "bool",
				"default": default_comfort,
				"current": comfort_enabled,
				"testProtocol": "autopilot",
				"subsystem": ps.getConfig("autopilot.type"),
			})
		Tool.release(ps)
	.fillTuneableSystems()
	_sync_ui(comfort_enabled, true)

func tuningChanged(system, type, to, protocol):
	.tuningChanged(system, type, to, protocol)
	if type == "TUNE_AUTOPILOT_COMFORT":
		_sync_ui(to, false)

func _sync_ui(enabled: bool, reorder: bool):
	var node = get_node_or_null(itemsNodePath)
	if not node:
		return
	for group_node in node.get_children():
		var prox_node = null
		var comfort_node = null
		for item_node in group_node.get_children():
			if "tuningItem" in item_node:
				if item_node.tuningItem == "TUNE_PROXIMITY_ALERT":
					prox_node = item_node
				elif item_node.tuningItem == "TUNE_AUTOPILOT_COMFORT":
					comfort_node = item_node
		if prox_node and comfort_node and reorder:
			group_node.move_child(comfort_node, prox_node.get_index() + 1)
		if prox_node:
			prox_node.modulate = Color(1, 1, 1, 1.0 if enabled else 0.35)
			var slider = prox_node.get_node_or_null("HSlider")
			if slider:
				slider.editable = enabled
				slider.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE
			var reset_btn = prox_node.get_node_or_null("HBoxContainer/Reset")
			if reset_btn:
				reset_btn.disabled = not enabled
