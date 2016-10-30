%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_error.inc'
%include 'class/class_lisp.inc'

def_func class/lisp/func_setq
	;inputs
	;r0 = lisp object
	;r1 = args
	;outputs
	;r0 = lisp object
	;r1 = value

	ptr this, args, var, val, eval
	uint length, index

	push_scope
	retire {r0, r1}, {this, args}

	devirt_call vector, get_length, {args}, {length}
	if {length >= 2 && !(length & 1)}
		assign {0, 0}, {index, val}
		loop_start
			func_call ref, deref_if, {val}
			func_call vector, get_element, {args, index}, {var}
			func_call vector, get_element, {args, index + 1}, {val}
			func_call lisp, repl_eval, {this, val}, {val}
			breakif {val->obj_vtable == @class/class_error}
			assign {val}, {eval}
			func_call lisp, env_set, {this, var, eval}, {val}
			func_call ref, deref, {eval}
			breakif {val->obj_vtable == @class/class_error}
			assign {index + 2}, {index}
		loop_until {index == length}
	else
		func_call error, create, {"(setq var val ...) wrong numbers of args", args}, {val}
	endif

	eval {this, val}, {r0, r1}
	pop_scope
	return

def_func_end