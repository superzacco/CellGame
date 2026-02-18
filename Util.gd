extends Node

func rand_nudge(amt: float):
	var upper := amt + 1.0
	var lower := -amt + 1.0
	
	return randf_range(lower, upper)


func get_sample_for(value: float, maximum: float) -> float:
	return clamp(value / maximum, 0.0, 1.0)


func get_inverse(value: float, invert: float, nudge: float, maxMin := Vector2.ZERO, curve: Curve = null, debug := false) -> float:
	var speedNormalized : float = 0.0  
	var speedMultiplyFalloff : float = 0.0  
	if curve:
		speedNormalized = get_sample_for(value, maxMin.x)
		speedMultiplyFalloff = curve.sample(speedNormalized)
	
	var newSpeed = (value / invert) * speedMultiplyFalloff * rand_nudge(nudge) 
	
	if debug:
		print("value: %s, divideBy: %s, normalize: %s, multiplyfalloff: %s, newspeed: %s"%
		[value, invert, speedNormalized, speedMultiplyFalloff, newSpeed])
	
	return clamp(newSpeed, maxMin.y, maxMin.x)
