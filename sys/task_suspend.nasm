%include "func.inc"
%include "task.inc"

	fn_function "sys/task_suspend"
		;inputs
		;r15 = task control node

		;push all task registers
		vp_push r0
		vp_push r1
		vp_push r2
		vp_push r3
		vp_push r5
		vp_push r6
		vp_push r7
		vp_push r8
		vp_push r9
		vp_push r10
		vp_push r11
		vp_push r12
		vp_push r13
		vp_push r14

		;save stack pointer
		vp_cpy r4, [r15 + TK_NODE_STACK]

		;remove task control block
		vp_cpy r15, r0
		vp_cpy r15, r1
		ln_remove_node r0, r15

		;get statics
		fn_bind sys/task_statics, r0

		;add to suspend list and restore next
		vp_lea [r0 + TK_STATICS_TASK_SUSPEND_LIST], r0
		lh_add_at_head r0, r1, r2
		fn_jmp sys/task_restore

	fn_function_end
