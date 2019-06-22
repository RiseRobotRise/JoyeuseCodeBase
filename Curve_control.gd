extends Control

var CURVE = Curve.new()
var curvepoints = []
signal point_Added(point)
func _enter_tree():
	
	CURVE.add_point(Vector2(0,0))
	CURVE.add_point(Vector2(1,1))
	$TextureRect.texture.curve = CURVE
	
func _ready():
	update()
	
func _draw():
	draw_polyline (curvepoints, Color(1,1,1,1), 5.0, true )