extends Resource

@export var id: String
@export var damagedImage: SpriteFrames
@export var repairedImage: SpriteFrames
@export var failedImage: SpriteFrames
@export var solution: Array[AcceptedSolutions]

enum AcceptedSolutions {TAPE, KISS, WHACK}
