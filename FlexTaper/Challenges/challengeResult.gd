class_name ChallengeResult
extends Resource

@export var resultImage: SpriteFrames
@export var goodResult: bool

func init(resultImageIn: SpriteFrames, goodResultIn: bool):
	resultImage = resultImageIn
	goodResult = goodResultIn
