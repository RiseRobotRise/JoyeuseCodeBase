# This script attempts to unify the base behaviours of all weapons.
# it is extended by each weapon to facilitate their specific functions
# for example: the fusion pistol is a projectile weapon that has overload events, the pistol can be dual wielded.

extends JOYObject
class_name JOYWeapon

# sets the readiness of the weapon to fire
var reloading : bool = false
var can_shoot : bool = true
var can_shoot_secondary : bool = true

# if homing sets target
var target = null 



# stores various parameters for the weapon
var sound_intensity = 1
var primary_initial_ammo = 0 # The initial ammuntion cartidges for the gun
var secondary_initial_ammo = 0 # The initial ammuntion cartidges for the gun
var primary_ammo_id = 0 # kind of ammo for primary fire
var secondary_ammo_id = 0 # kind of ammo for secondary fire
# primary_uses;  how much ammo we have in the gun (not total ammo)
# secondary_uses; how much secondary ammo we have in the gun (not total ammo)
var primary_magazine_size = 0 # how much ammo the primary magazine canhold.
var secondary_magazine_size = 0 # how much ammo the secondary magazine canhold.



var wielder : Node

export var dual_wieldable = false
var dual_wielding = false


func setup(wieldee : Spatial) -> void:
	wielder = wieldee
	if get_parent() == null:
		wielder.add_child(self)
	elif get_parent()!=wieldee:
		get_parent().remove_child(self)
		wielder.add_child(self)


func primary_use(_use : int = 0):
	pass
	
func secondary_use(_use : int = 0):
	pass
	
func secondary_release():
	pass
func primary_release():
	pass

# Reloads the weapon from the wielders inventory when called.
func reload_primary():
	if wielder.inventory.weapons.has(id):
		wielder.inventory.reload_weapon(id, false) #id = weapon id, secondary = false
		return

func reload_secondary():
	if wielder.inventory.weapons.has(id):
		wielder.inventory.reload_weapon(id, true) #id = weapon id, secondary = true
		return


func ammo_check_primary(size = 1):
	if primary_uses >= size:
		primary_uses -= size
		return true
	else:
		reload_primary()
		return false
	

func ammo_check_secondary(size = 1):
	if secondary_uses >= size:
		secondary_uses -= size
		return true
	else:
		reload_secondary()
		return false
	
	
func dual_wield():
	
	pass

