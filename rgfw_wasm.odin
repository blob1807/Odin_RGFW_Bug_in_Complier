#+build wasm32, wasm64p32
package rgfw_odin_bindings

import "vendor:wgpu"

when RGFW_WEBGPU {
    _window_src :: struct {
        ctx: wgpu.Instance,
        device: wgpu.Device,
        queue: wgpu.Queue,
    }   

} else {
    _window_src :: struct {
    
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

	_threadFunc_ptr :: #type proc "c" ()
}
/* */