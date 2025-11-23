class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var introMusic: AudioStreamPlayer
@export var successMusic: AudioStreamPlayer
@export var failMusic: AudioStreamPlayer
@export var tvSprite: AnimatedSprite2D
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
	print("Intro")
	introTimer = get_node("IntroTimer")
	introTimer.start()
	introMusic.play()
	
	await introTimer.timeout
	
func ChallengeOuttroSuccess():
	successMusic.play();
	tvSprite.sprite_frames = challenge.repairedImage
	await get_tree().create_timer(1.0).timeout
	
func ChallengeOuttroFail():
	failMusic.play();
	tvSprite.sprite_frames = challenge.failedImage
	await get_tree().create_timer(1.0).timeout
	return 0;
	
func ChallengeGame() -> Challenge.AcceptedSolutions:
	print("Game")
	challengeTimer = get_node("ChallengeTimer")
	challengeTimer.start()

	while (challengeTimer.time_left > 0):
		print(challengeTimer.time_left)
		await get_tree().create_timer(0).timeout
		
	return Challenge.AcceptedSolutions.NOTHING

func DidPlayerSucceedChallenge(result) -> bool:
	print("Succeed?")
	if (challenge.solution.has(result)):
		return true
	else:
		return false
