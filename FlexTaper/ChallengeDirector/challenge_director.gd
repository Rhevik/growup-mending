class_name ChallengeDirector
extends Node

var test: int
var introTimer: Timer
var challengeTimer: Timer
var introMusic: AudioStreamPlayer
var challenge: Challenge

func StartChallenge(newChallenge) -> Challenge.AcceptedSolutions:
	challenge = newChallenge
	await ChallengeIntro()
	var answer = await ChallengeGame()
	return answer
	
func ChallengeIntro():
	introTimer = get_node("IntroTimer")
	introMusic.play()
	
	await introTimer.timeout
	
func ChallengeGame() -> Challenge.AcceptedSolutions:
	challengeTimer = get_node("ChallengeTimer")
	challengeTimer.start()

	while (!challengeTimer.is_stopped()):
		await get_tree().create_timer(0).timeout
		
	return Challenge.AcceptedSolutions.NOTHING
