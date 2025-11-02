#+build linux
package rgfw_odin_bindings

import "core:sys/linux"
import "vendor:x11/xlib"
import "vendor:egl"

/*
If someone whats to send the time & add support for OSMESA, OPENGL & WAYLAND, be my guest. 
*/

#assert(RGFW_EGL == true)
#assert(RGFW_X11 == true)

#assert(RGFW_WAYLAND == false)
#assert(RGFW_OSMESA  == false)
#assert(RGFW_OPENGL  == false)

when RGFW_BUFFER {
    when RGFW_ADVANCED_SMOOTH_RESIZE {
        _window_src :: struct {
            display: ^xlib.Display, /*!< source display */ 
            window: xlib.Window, /*!< source window */
            EGL_surface: egl.Surface,
            EGL_display: egl.Display,
            EGL_context: egl.Context,
            bitmap: ^xlib.XImage,
            gc: xlib.GC,
            visual: xlib.XVisualInfo,
            counter_value: i64,
            counter: xlib.XID,
        }

    } else {
        _window_src :: struct {
            display: ^xlib.Display, /*!< source display */
            window: xlib.Window, /*!< source window */
            EGL_surface: egl.Surface,
            EGL_display: egl.Display,
            EGL_context: egl.Context,
            bitmap: ^xlib.XImage,
            gc: xlib.GC,
            visual: xlib.XVisualInfo,
        }

    }

} else {
    when RGFW_ADVANCED_SMOOTH_RESIZE {
        _window_src :: struct {
            display: ^xlib.Display, /*!< source display */
            window: xlib.Window, /*!< source window */
            EGL_surface: egl.Surface,
            EGL_display: egl.Display,
            EGL_context: egl.Context,
            gc: xlib.GC,
            visual: xlib.XVisualInfo,
            counter_value: i64,
            counter: xlib.XID,
        }

    } else {
        _window_src :: struct {
            display: ^xlib.Display, /*!< source display */
            window: xlib.Window, /*!< source window */
            EGL_surface: egl.Surface,
            EGL_display: egl.Display,
            EGL_context: egl.Context,
            gc: xlib.GC,
            visual: xlib.XVisualInfo,
        }
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

	_threadFunc_ptr :: #type proc "c" (rawptr) -> rawptr
}
/* */