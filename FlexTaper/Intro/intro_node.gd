class_name IntroNode
extends Node

var GameManager: GameManager

func StartIntro(manager):
	GameManager = manager
	StartGame()

func StartGame():
	GameManager.select_next_challenge()
