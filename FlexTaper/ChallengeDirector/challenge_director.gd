class_name ChallengeDirector
extends Node

@export var introTimer: Timer
@export var challengeTimer: Timer
@export var tvStatic: AudioStreamPlayer
@export var introMusic: AudioStreamPlayer
@export var successMusic: AudioStreamPlayer
@export var failMusic: AudioStreamPlayer
@export var tvSprite: AnimatedSprite2D
@export var tvBackingBad: Sprite2D
@export var tvBackingNormal: Sprite2D
@export var tvBackingWin: Sprite2D
@export var staticTv: Sprite2D
@export var renderViewport: SubViewport
@export var buttonContainerNode: Node2D
var challenge: Challenge
var solution: Challenge.AcceptedSolutions
var _solutionAllowed: bool
var tvBacking: Sprite2D

func StartChallenge(newChallenge):
	challenge = newChallenge
	tvBacking = tvBackingNormal
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
	var backing_size = tvBacking.texture.get_size() if tvBacking else Vector2(760, 606)
	var tv_size = tvSprite.sprite_frames.get_frame_texture(tvSprite.animation, tvSprite.frame).get_size()
	var x = max(backing_size.x, tv_size.x)
	var y = max(backing_size.y, tv_size.y)
	renderViewport.size = Vector2(x, y)
	#Log.m("Setting the subviewport to the size: " + str(x) + ", " + str(y))
	
func ChallengeIntro():
	Log.m("Intro")
	set_tv_backing(tvBackingNormal)
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
	set_tv_backing(tvBackingWin)
	successMusic.play();
	await get_tree().create_timer(2.25).timeout
	
func ChallengeOuttroFail():
	set_tv_backing(tvBackingBad)
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
		
func set_tv_backing(newBacking):
	tvBacking = newBacking
	tvBackingBad.visible = false
	tvBackingNormal.visible = false
	tvBackingWin.visible = false
	if (tvBacking == tvBackingBad):
		tvBackingBad.visible = true
	if (tvBacking == tvBackingNormal):
		tvBackingNormal.visible = true
	if (tvBacking == tvBackingWin):
		tvBackingWin.visible = true
	
