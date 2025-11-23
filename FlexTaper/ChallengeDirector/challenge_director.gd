class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var tvStatic: AudioStreamPlayer
@export var introMusic: AudioStreamPlayer
@export var successMusic: AudioStreamPlayer
@export var failMusic: AudioStreamPlayer
@export var tvSprite: AnimatedSprite2D
@export var tvBacking: Sprite2D
@export var staticTv: Sprite2D
@export var renderViewport: SubViewport
@export var buttonContainerNode: Node
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
	Log.m("Challenge End")
	
func SetSpriteFrames(given_frames: SpriteFrames):
	Log.m("Setting TV frame to: " + given_frames.resource_path)
	tvSprite.sprite_frames = given_frames
	var backing_size = tvBacking.texture.get_size()
	var tv_size = tvSprite.sprite_frames.get_frame_texture(tvSprite.animation, tvSprite.frame).get_size()
	var x = max(backing_size.x, tv_size.x)
	var y = max(backing_size.y, tv_size.y)
	renderViewport.size = Vector2(x, y)
	#Log.m("Setting the subviewport to the size: " + str(x) + ", " + str(y))
	
func ChallengeIntro():
	Log.m("Intro")
	introTimer = get_node("IntroTimer")
	introTimer.start()
	tvStatic.play();
	introMusic.play()
	staticTv.visible = true
	await introTimer.timeout
	tvStatic.stop();
	staticTv.visible = false
	SetSpriteFrames(challenge.damagedImage)
	disable_buttons(false)
	
func ChallengeOuttroSuccess():
	successMusic.play();
	await get_tree().create_timer(2.25).timeout
	
func ChallengeOuttroFail():
	failMusic.play();
	Log.m("Challenge Fail")
	await get_tree().create_timer(2.25).timeout
	Log.m("Challenge Fail End")
	
func ChallengeGame() -> Challenge.AcceptedSolutions:
	Log.m("Game")
	challengeTimer = get_node("ChallengeTimer")
	challengeTimer.start()

	solution = Challenge.AcceptedSolutions.NOTHING
	while (challengeTimer.time_left > 0 && solution == Challenge.AcceptedSolutions.NOTHING):
		await get_tree().create_timer(0).timeout
		
	return solution

func DidPlayerSucceedChallenge(result) -> bool:
	if (challenge.solution.has(result)):
		Log.m("Success!")
		return true
	else:
		Log.m("Failed!")
		return false

func press_kiss():
	solution = Challenge.AcceptedSolutions.KISS
	SetSpriteFrames(challenge.kissImage)
	disable_buttons(true)

func press_whack():
	solution = Challenge.AcceptedSolutions.WHACK
	SetSpriteFrames(challenge.whackImage)
	disable_buttons(true)

func press_tape():
	solution = Challenge.AcceptedSolutions.TAPE
	SetSpriteFrames(challenge.tapeImage)
	disable_buttons(true)
	
func disable_buttons(disabled):
	for button : BaseButton in buttonContainerNode.get_children():
		button.disabled = disabled
