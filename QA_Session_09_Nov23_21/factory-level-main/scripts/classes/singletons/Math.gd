extends Node

const CMP_EPSILON := 0.001

# TODO: add documentation

static func is_almost_equal(a: float, b: float, epsilon: float = CMP_EPSILON) -> bool:
	if a == b: return true
	
	var tolerance := a * epsilon
	if tolerance < epsilon:
		tolerance = epsilon
	
	return abs(a - b) < tolerance

static func is_almost_zero(a: float, epsilon: float = CMP_EPSILON) -> bool:
	return abs(a) < epsilon

static func is_in_range(value: float, min_value: float, max_value: float) -> bool:
	return (value >= min_value) && (value <= max_value)
