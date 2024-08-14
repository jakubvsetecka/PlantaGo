class_name Stack

var _items: Array = []

func push(item):
	_items.append(item)

func pop():
	if not is_empty():
		return _items.pop_back()
	return null

func peek():
	if not is_empty():
		return _items.back()
	return null

func is_empty() -> bool:
	return _items.is_empty()

func size() -> int:
	return _items.size()

func clear():
	_items.clear()

func _to_string() -> String:
	return str(_items)
