extends Skeleton

"""
This is the code for a helper skeleton, which manages all the IK solvings and 
complex animations systems, to be delivered to the main skeleton which cannot
do these operations, otherwise the mesh will be deformed
"""

var R_Hand_Target : Spatial
var L_Hand_Target : Spatial
var R_Foot_Target : Spatial
var L_Foot_Target : Spatial

export(NodePath) var R_Hand_IK
export(NodePath) var L_Hand_IK
export(NodePath) var R_Foot_IK
export(NodePath) var L_Foot_IK

var RHANDIK : SkeletonIK
var LHANDIK : SkeletonIK
var RFOOTIK : SkeletonIK
var LFOOTIK : SkeletonIK


func _ready():
	setup_IK()
	
func setup_IK():
	RHANDIK = get_node_or_null(R_Hand_IK)
	LHANDIK = get_node_or_null(L_Hand_IK)
	RFOOTIK = get_node_or_null(R_Foot_IK)
	LFOOTIK = get_node_or_null(L_Foot_IK)
	
	if RHANDIK != null and R_Hand_Target != null:
		RHANDIK.start()
	if LHANDIK != null and L_Hand_Target != null:
		LHANDIK.start()
	if RFOOTIK!= null and R_Foot_Target != null:
		RFOOTIK.start()
	if LFOOTIK != null and L_Foot_Target != null:
		LFOOTIK.start()

func _process(_delta):
	if LHANDIK != null and L_Hand_Target != null:
		LHANDIK.target = L_Hand_Target.global_transform
		
	if RHANDIK != null and R_Hand_Target != null:
		RHANDIK.target = R_Hand_Target.global_transform
		
	if RFOOTIK!= null and R_Foot_Target != null:
		RFOOTIK.target = R_Foot_Target.global_transform
		
	if LFOOTIK != null and L_Foot_Target != null:
		LFOOTIK.target = L_Foot_Target.transform
