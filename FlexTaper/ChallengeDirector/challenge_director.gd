class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var introMusic: AudioStreamPlayer
@export var successMusic: AudioStreamPlayer
@export var failMusic: AudioStreamPlayer
var challenge: Challenge

func StartChallenge(newChallenge):
	challenge = newChallenge
	await ChallengeIntro()
	var answer = await ChallengeGame()
	if(DidPlayerSucceedChallenge(answer)):
		ChallengeOuttroSuccess();
	else:
		ChallengeOuttroFail();
	
func ChallengeIntro():
	introTimer = get_node("IntroTimer")
	introMusic.play()
	
	await introTimer.timeout
	
func ChallengeOuttroSuccess():
	successMusic.Play();
	await get_tree().create_timer(1.0).timeout
	
func ChallengeOuttroFail():
	failMusic.Play();
	await get_tree().create_timer(1.0).timeout
	return 0;
	
func ChallengeGame() -> Challenge.AcceptedSolutions:
	challengeTimer = get_node("ChallengeTimer")
	challengeTimer.start()

	while (!challengeTimer.is_stopped()):
		await get_tree().create_timer(0).timeout
		
	return Challenge.AcceptedSolutions.NOTHING

func DidPlayerSucceedChallenge(result) -> bool:
	if (challenge.AcceptedSolutions.find_key(result) != null):
		return true
	else:
		return false
	
