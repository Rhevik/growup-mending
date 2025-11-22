extends Resource

@export var id: String
@export var damagedImage: Texture2D
@export var repairedImage: Texture2D
@export var failedImage: Texture2D
@export var solution: Array[AcceptedSolutions]

enum AcceptedSolutions {TAPE, KISS, WHACK}
