extends Object
class_name Enums

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum Field {
	SPRING,
	SAND,
	WINTER
}

static func field_to_string(enum_value: int) -> String:
	return Enums.Field.keys()[enum_value]
