extends Object
class_name Enums

enum Direction { UP, DOWN, LEFT, RIGHT }
enum Field { SPRING, SAND, WINTER }

static func get_field_as_string(enum_value: int) -> String:
	for name: String in Enums.Field.keys():
		if Enums.Field[name] == enum_value:
			return name
	return "Unknown"  # 未定義の値の場合
