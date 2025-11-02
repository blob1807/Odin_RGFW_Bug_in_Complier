#+build darwin
package rgfw_odin_bindings


when RGFW_OPENGL  {
    _window_src :: struct {
        window: rawptr,
        ctx:    rawptr, /*!< source graphics context */
        view:   rawptr, /* apple viewpoint thingy */
        mouse:  rawptr,
    }
    
} else  {
    _window_src :: struct {
        window: rawptr,
        view:   rawptr, /* apple viewpoint thingy */
        mouse:  rawptr,
    }
}


/* Threads */
when !RGFW_NO_THREADS {
	/*! threading functions */

	_threadFunc_ptr :: #type proc "c" (rawptr) rawptr
}
/* */