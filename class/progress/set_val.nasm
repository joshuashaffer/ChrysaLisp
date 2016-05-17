%include 'inc/func.inc'
%include 'class/class_progress.inc'

	fn_function class/progress/set_val
		;inputs
		;r0 = progress object
		;r1 = value
		;outputs
		;r1 = value, clipped to max

		if r1, >, [r0 + progress_max]
			vp_cpy [r0 + progress_max], r1
		endif
		vp_cpy r1, [r0 + progress_val]
		vp_ret

	fn_function_end
