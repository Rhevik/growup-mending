extends Node

@export var AllChallenges: Array[Challenge]
@export var CurrentChallenge: Challenge
@export var Director: ChallengeDirector
var _ChallengeIndex: int

func _ready():
	AllChallenges.shuffle()
	_ChallengeIndex = 0;
	select_next_challenge()

func select_next_challenge():
	CurrentChallenge = AllChallenges[_ChallengeIndex]
	_ChallengeIndex += 1
	if (_ChallengeIndex >= AllChallenges.size()):
		Log.m("shuffled challenges")
		_ChallengeIndex = 0
		AllChallenges.shuffle()
	await run_challenge()

func run_challenge():
	Log.m ("running challenge")
	await Director.StartChallenge(CurrentChallenge)
	Log.m ("ending challenge")
	select_next_challenge()
	
