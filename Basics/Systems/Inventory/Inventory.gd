class_name Inventory
var arsenal_links : Array = [null,null,null,null,null,null,null,null,null,null]
var weapons : Array = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
var ammo : Array = [0,0,0,0,0,0,0,0,0,0]
var misc : Array = []


func add_ammo(id, amount):
	ammo[id]+=amount

func add_weapon(id):
	weapons[id] = 1

func reload_weapon(id):
	if weapons[id]!=-1:
		ammo[id]

func use_item(id, uses):
	if misc.size() > id:
		misc[id] -=1
	if misc[id] < 0:
		misc[id] = 0

func register_object(node):
	if node is Weapon:
		if arsenal_links.size() <= node.id:
			arsenal_links.resize(node.id)
		arsenal_links[node.id] = node
		if node.id >= weapons.size():
			weapons.resize(node.id)
		weapons[node.id] = 0
	elif node is JOYObject:
		pass
