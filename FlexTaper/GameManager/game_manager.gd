extends Node

@export var AllChallenges: Array[Challenge]
@export var CurrentChallenge: Challenge

func _ready():
	select_next_challenge()

func select_next_challenge():
	CurrentChallenge = AllChallenges[randi() % AllChallenges.size()] 
