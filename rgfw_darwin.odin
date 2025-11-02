#+build darwin
package rgfw_odin_bindings


when RGFW_OPENGL  {
    _window_src :: struct {
        window: rawptr,
        ctx: rawptr, /*!< source graphics context */
        view: rawptr, /* apple viewpoint thingy */
        mouse: rawptr,
    }
    
} else  {
    _window_src :: struct {
        window: rawptr,
        view: rawptr, /* apple viewpoint thingy */
        mouse: rawptr,
    }
}


/* Threads */
when !RGFW_NO_THREADS {
	/*! threading functions */

	/*! NOTE! (for X11/linux) : if you define a window in a thread, it must be run after the original thread's window is created or else there will be a memory error */
	/*
		I'd suggest you use sili's threading functions instead
		if you're going to use sili
		which is a good idea generally
	*/

	_threadFunc_ptr :: #type proc "c" (rawptr) rawptr
}
/* */