extends Object
class_name Enum # class_nameを設定しないと、Enum.Directionとかが定義元にジャンプできない

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum Field {
	HOME,
	SPRING,
	SAND,
	WINTER
}

static func field_to_string(enum_value: int) -> String:
	return Enum.Field.keys()[enum_value]
