class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var tvStatic: AudioStreamPlayer
@export var introMusic: AudioStreamPlayer
@export var successMusic: AudioStreamPlayer
@export var failMusic: AudioStreamPlayer
@export var tvSprite: AnimatedSprite2D
@export var staticTv: SpriteFrames
var challenge: Challenge
var solution: Challenge.AcceptedSolutions

func StartChallenge(newChallenge):
	challenge = newChallenge
	await ChallengeIntro()
	var answer = await ChallengeGame()
	introMusic.stop();
	if(DidPlayerSucceedChallenge(answer)):
		await ChallengeOuttroSuccess();
	else:
		await ChallengeOuttroFail();
	print("Challenge End")
	
func ChallengeIntro():
	print("Intro")
	introTimer = get_node("IntroTimer")
	introTimer.start()
	tvStatic.play();
	introMusic.play()
	tvSprite.sprite_frames = staticTv
	await introTimer.timeout
	tvStatic.stop();
	tvSprite.sprite_frames = challenge.damagedImage
	
func ChallengeOuttroSuccess():
	successMusic.play();
	tvSprite.sprite_frames = challenge.repairedImage
	await get_tree().create_timer(2.25).timeout
	
func ChallengeOuttroFail():
	failMusic.play();
	tvSprite.sprite_frames = challenge.failedImage
	print("Challenge Fail")
	await get_tree().create_timer(2.25).timeout
	print("Challenge Fail End")
	
func ChallengeGame() -> Challenge.AcceptedSolutions:
	print("Game")
	challengeTimer = get_node("ChallengeTimer")
	challengeTimer.start()

	solution = Challenge.AcceptedSolutions.NOTHING
	while (challengeTimer.time_left > 0 && solution == Challenge.AcceptedSolutions.NOTHING):
		await get_tree().create_timer(0).timeout
		
	return solution

func DidPlayerSucceedChallenge(result) -> bool:
	print("Succeed?")
	if (challenge.solution.has(result)):
		return true
	else:
		return false

func press_kiss():
	solution = Challenge.AcceptedSolutions.KISS

func press_whack():
	solution = Challenge.AcceptedSolutions.WHACK

func press_tape():
	solution = Challenge.AcceptedSolutions.TAPE
