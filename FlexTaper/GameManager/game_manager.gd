extends Node

@export var AllChallenges: Array[Challenge]
@export var CurrentChallenge: Challenge
@export var Director: ChallengeDirector

func _ready():
	select_next_challenge()

func select_next_challenge():
	CurrentChallenge = AllChallenges[randi() % AllChallenges.size()]
	await run_challenge() 

func attempt_solution(solution):
	if(CurrentChallenge.solution.has(solution)):
		select_next_challenge()
	else:
		select_next_challenge()
		
func press_kiss():
	attempt_solution(Challenge.AcceptedSolutions.KISS)

func press_whack():
	attempt_solution(Challenge.AcceptedSolutions.WHACK)

func press_tape():
	attempt_solution(Challenge.AcceptedSolutions.TAPE)

func run_challenge():
	print ("running challenge")
	await Director.StartChallenge(CurrentChallenge)
	print ("ending challenge")
	select_next_challenge()
	
