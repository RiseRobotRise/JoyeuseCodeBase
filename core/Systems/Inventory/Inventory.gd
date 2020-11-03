class_name Inventory
var weapons : Dictionary = {}
var ammo : Dictionary = {}
var misc : Dictionary = {}
var weilder_ref : Spatial


func add_ammo(id : int, amount : int): #Ammo works by cartidges, ammo has their own id's
	if  ammo.has(id):
		ammo[id] += amount
	else:
		ammo[id] = amount

func reload_weapon(id : int, secondary : bool = false): #reloads the weapon with "id" 
	var ammo_id : int = 0
	if weapons.has(id):
		var weapon : JOYWeapon = weapons[id].node_ref
		ammo_id = weapons[id]["primary_ammo_id"]
		if secondary:
			ammo_id = weapons[id]["secondary_ammo_id"]
		if ammo[ammo_id] > 0:
			ammo[ammo_id] -= 1
			if secondary:
				weapon.restore_uses(weapon.secondary_magazine_size)
			else:
				weapon.restore_uses(weapon.primary_magazine_size)

func use_item(id, uses) -> bool: #Returns the success of the action. 
	if misc.has(id):
		misc[id].node_ref.primary_use(uses)
		return true
	return false

func _register_weapon(node : JOYWeapon):
	print("registering a gun! ")
	if weapons.has(node.id):
		if weapons[node.id].amount < 2 and weapons[node.id].dual_weildable == true:
			weapons[node.id].amount = 2
			return
		else: 
			add_ammo(node.id, node.primary_uses/node.primary_magazine_size)
			node.remove_uses(node.primary_uses, false) #Removes the primary ammo from the gun
			add_ammo(node.id, node.secondary_uses/node.secondary_magazine_size) #adds the ammo from the gun
			node.remove_uses(node.secondary_uses, true) #Removes the secondary ammo from the gun
			node.primary_initial_ammo = 0
			node.secondary_initial_ammo = 0
			return
	else:
		node.setup(weilder_ref)
		var new_weapon : Dictionary
		new_weapon["id"] = node.id
		new_weapon["amount"] = 1
		new_weapon["node_ref"] = node
		new_weapon["primary_ammo_id"] = node.primary_ammo_id
		new_weapon["secondary_ammo_id"] = node.secondary_ammo_id
		weapons[node.id] = new_weapon
		add_ammo(node.primary_ammo_id, node.primary_initial_ammo)
		add_ammo(node.secondary_ammo_id, node.secondary_initial_ammo)
		
		
func _register_misc(node : JOYObject) -> void:
	print("Registering something I don't quite know!'")
	if misc.has(node.id):
			misc[node.id].amount += 1
	else:
		var new_object : Dictionary
		new_object["id"] = node.id
		new_object["amount"] = 1
		new_object["node_ref"] = node

func register_object(node : JOYObject) -> void:
	if node is JOYWeapon:
		_register_weapon(node)
		
	elif node is JOYObject:
		_register_misc(node)
	elif node is JOYAmmo:
		add_ammo(node.id, node.amout)
	else:
		print("object is none! ", node)
