class_name IntroNode
extends Node

var GameManager: GameManager
@export var IntroAnim: AnimatedSprite2D
@export var StartButton: BaseButton

func StartIntro(manager):
	GameManager = manager
	GameManager.Director.hide_buttons()
	GameManager.Director.SetSpriteFrames(IntroAnim.sprite_frames)

func StartGame():
	DisableIntro()
	GameManager.Director.SetSpriteFrames(GameManager.AllChallenges[0].damagedImage)
	GameManager.select_next_challenge()
	
func DisableIntro():
	for child in get_children():
		child.visible = false
	StartButton.disabled = true
	GameManager.Director.show_buttons()
