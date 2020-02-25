extends AudioStreamPlayer3D
class_name AutoSound3D

func _init(sound_resource, offset):
	if sound_resource is String:
		stream = load(sound_resource)
	elif sound_resource is AudioStream:
		stream = sound_resource
	translation = offset
	doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
	unit_db = 20
	unit_size = 2
	
func _ready():
	play()
	yield(self, "finished")
	queue_free()
