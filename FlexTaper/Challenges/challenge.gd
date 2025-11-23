class_name Challenge
extends Resource

@export var id: String
@export var damagedImage: SpriteFrames
@export var tapeImage: SpriteFrames
@export var kissImage: SpriteFrames
@export var whackImage: SpriteFrames
@export var solution: Array[AcceptedSolutions]

enum AcceptedSolutions {TAPE, KISS, WHACK, NOTHING}
