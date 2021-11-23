## Singleton used to control fade in and fade out effects.
# @name      TransitionRect
# @singleton
# @desc      This class displays a black rectangle on top of the scene at all times. At the start,
#            it is invisible so as not to cover the screen. Functions can be called to fade the
#            screen in and out by interpolating the alpha of the black rectnggle.
#
#            The functions @function fade_in() and @function fade_out() are used to implement
#            traditional fade in and fade out effects.
extends CanvasLayer

## Emitted when a fade has finished.
# @arg String type  Describes which kind of fade was finished, "in" or "out"
signal fade_finished(type)

## The default duration of a fade.
# @type float
const DEFAULT_DURATION := 1.0

onready var tween = $Tween

func _ready() -> void:
	var screen_size := Vector2(
		ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height")
	)
	set_meta('screen_size', screen_size)
	set_meta('current_fade', '...')

## Start a fade-in effect.
# @desc  This function interpolates the alpha value of a black rectangle from
#        one to zero. Certain aspects of the fade, such as fade-time and the
#        initial value, can be controlled via @a options.
#
#        @a options is a dictionary that contains various parameters for the fade:
#        the key @i initial_value is used to specify the initial alpha value
#        at the start of the fade, and @i duration is used to specify how long
#        the fade lasts in seconds.
#
#        @i duration must be a positive number greater than zero in order to be read.
#        If this parameter is not provided or is invalid, it defaults to
#        @constant DEFAULT_DURATION.
#
#        The option @i initial_value defaults to 1.0 unless it is specified by
#        the user. For it to be valid, the initial value must be in the range [0.01, 1.0].
func fade_in(options: Dictionary = {}) -> void:
	if tween.is_active(): return

	# duration of the fade
	var duration := DEFAULT_DURATION
	if 'duration' in options:
		# only set duration if parameter is over zero
		var temp: float = options['duration']
		if temp > 0.0:
			duration = temp

	# initial value
	var initial_value := 1.0
	if 'initial_value' in options:
		var temp: float = options['initial_value']
		if Math.is_in_range(temp, 0.01, 1.0):
			initial_value = temp
	
	# start tween
	tween.interpolate_property($ColorRect, @"self_modulate:a",
		initial_value, 0.0, duration, Tween.TRANS_CUBIC)
	tween.start()

	set_meta('current_fade', 'in') # fade type

## Start a fade out effect.
# @desc  This function causes a fade-out effect by interpolating the alpha value
#        of a black rectangle covering the screen, from zero to one.
#
#        @a options is a dictionary that contains various parameters for the fade:
#        the key @i initial_value is used to specify the initial alpha value
#        at the start of the fade, and @i duration is used to specify how long
#        the fade lasts in seconds.
#
#        @i duration must be a positive number greater than zero in order to be read.
#        If this parameter is not provided or is invalid, it defaults to
#        @constant DEFAULT_DURATION.
#
#        The option @i initial_value defaults to zero unless it is specified by
#        the user. For it to be valid, the initial value must be in the range [0.0, 0.99].
func fade_out(options: Dictionary = {}) -> void:
	if tween.is_active(): return

	# duration of the fade
	var duration := DEFAULT_DURATION
	if 'duration' in options:
		# only set duration if parameter is over zero
		var temp: float = options['duration']
		if temp > 0.0:
			duration = temp

	# initial value
	var initial_value: float = $ColorRect.self_modulate.a
	if initial_value >= 1.0:
		initial_value = 0.0

	# option overrides initial_value
	if 'initial_value' in options:
		var temp: float = options['initial_value']
		if Math.is_in_range(temp, 0.00, 0.99):
			initial_value = temp
	
	# start tween
	tween.interpolate_property($ColorRect, @"self_modulate:a",
		initial_value, 1.0, duration, Tween.TRANS_CUBIC)
	tween.start()

	set_meta('current_fade', 'out') # fade type

## Set the alpha value of the fade rect.
func set_alpha(a: float) -> void:
	$ColorRect.self_modulate.a = clamp(a, 0, 1)

func _on_all_tweens_completed() -> void:
	var cf: String = get_meta('current_fade')
	emit_signal('fade_finished', cf)

func _go_to_next_scene(scene: String):
	var t := get_tree()
	t.connect('idle_frame', self, '_start_queued_fade', [], CONNECT_ONESHOT)
	t.change_scene(scene)
