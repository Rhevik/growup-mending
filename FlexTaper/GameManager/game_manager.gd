extends Node

@export var AllChallenges: Array[Challenge]
@export var CurrentChallenge: Challenge

func _ready():
	select_next_challenge()

func select_next_challenge():
	CurrentChallenge = AllChallenges[randi() % AllChallenges.size()] 

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
