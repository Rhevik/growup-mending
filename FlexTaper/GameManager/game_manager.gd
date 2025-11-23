extends Node

@export var AllChallenges: Array[Challenge]
@export var CurrentChallenge: Challenge
@export var Director: ChallengeDirector

func _ready():
	select_next_challenge()

func select_next_challenge():
	CurrentChallenge = AllChallenges[randi() % AllChallenges.size()]
	await run_challenge() 

func run_challenge():
	print ("running challenge")
	await Director.StartChallenge(CurrentChallenge)
	print ("ending challenge")
	select_next_challenge()
	
