class_name Log
extends Node

static func m(msg):
	var frame_digits = ("%5d" % Engine.get_frames_drawn()).right(5)
	print("[%s]: %s" % [frame_digits, msg])
