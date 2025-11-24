class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var tvStatic: AudioStreamPlayer
@export var introMusic: AudioStreamPlayer
@export var successList: Array[AudioStreamPlayer]
@export var failList: Array[AudioStreamPlayer]
@export var tvSprite: AnimatedSprite2D
@export var tvBacking: Sprite2D
@export var staticTv: Sprite2D
@export var renderViewport: SubViewport
@export var buttonContainerNode: Node2D
var challenge: Challenge
var solution: Challenge.AcceptedSolutions
var _solutionAllowed: bool

func StartChallenge(newChallenge):
	challenge = newChallenge
	shuffle_buttons()
	await ChallengeIntro()
	disable_buttons(false)
	var answer = await ChallengeGame()
	disable_buttons(true)
	
	introMusic.stop();
	var r = null;
	
	match answer:
		Challenge.AcceptedSolutions.TAPE:
			r = challenge.tapeResult
		Challenge.AcceptedSolutions.WHACK:
			r = challenge.whackResult
		Challenge.AcceptedSolutions.KISS:
			r = challenge.kissResult
			
	if (r == null):
		r = ChallengeResult.new()
		r.init(challenge.damagedImage, false)
			
	await ProcessChallengeResult(r)
	
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
	
func ChallengeOuttroSuccess():
	successList.pick_random().play();
	await get_tree().create_timer(2.25).timeout
	
func ChallengeOuttroFail():
	failList.pick_random().play();
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

func press_kiss():
	if (_solutionAllowed):
		solution = Challenge.AcceptedSolutions.KISS

func press_whack():
	if (_solutionAllowed):
		solution = Challenge.AcceptedSolutions.WHACK

func press_tape():
	if (_solutionAllowed):
		solution = Challenge.AcceptedSolutions.TAPE
	
func disable_buttons(disabled):
	buttonContainerNode.visible = not disabled
	_solutionAllowed = not disabled
	
func shuffle_buttons():
	var buttons: Array[TextureButton] = []
	buttons.assign(buttonContainerNode.get_children(false))
	var positions: Array[Vector2] = []
	for i in range(buttons.size()):
		positions.append(buttons[i].position)
		
	positions.shuffle()
	
	for i in range(buttons.size()):
		buttons[i].position = positions[i]
		
	
func ProcessChallengeResult(result : ChallengeResult):
	SetSpriteFrames(result.resultImage);
	
	if (result.goodResult):
		await ChallengeOuttroSuccess();
	else:
		await ChallengeOuttroFail();

func hide_buttons():
	_solutionAllowed = false
	for button : BaseButton in buttonContainerNode.get_children():
		button.visible = false
		
func show_buttons():
	for button : BaseButton in buttonContainerNode.get_children():
		button.visible = true
