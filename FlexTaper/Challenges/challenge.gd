class_name Challenge
extends Resource

@export var id: String
@export var damagedImage: SpriteFrames

@export var tapeResult: ChallengeResult
@export var kissResult: ChallengeResult
@export var whackResult: ChallengeResult

enum AcceptedSolutions {TAPE, KISS, WHACK, NOTHING}
