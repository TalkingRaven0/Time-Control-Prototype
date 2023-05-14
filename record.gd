var array : Array
var length = 180
func _init():
	self.array = Array()

func add(obj):
	if self.array.size()==length:
		self.array.pop_back()
	self.array.push_front(obj)

func pop():
	return self.array.pop_front()
