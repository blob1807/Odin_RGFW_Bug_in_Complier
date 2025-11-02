#+build wasm32, wasm64p32
package rgfw_odin_bindings

import "vendor:wgpu"

when RGFW_WEBGPU {
    _window_src :: struct {
        ctx:    wgpu.Instance,
        device: wgpu.Device,
        queue:  wgpu.Queue,
    }   

} else {
    _window_src :: struct {
    
    }
}

/* Threads */
when !RGFW_NO_THREADS {
	/*! threading functions */

	_threadFunc_ptr :: #type proc "c" ()
}
/* */