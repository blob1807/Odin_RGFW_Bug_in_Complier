#+build windows
package rgfw_odin_bindings

import win "core:sys/windows"


when RGFW_OPENGL {
    when RGFW_BUFFER {
        _window_src :: struct {
            window: win.HWND, /*!< source window */
            hdc: win.HDC, /*!< source HDC */
            hOffset: u32, /*!< height offset for window */
            hIconSmall, hIconBig: win.HICON, /*!< source window icons */
            ctx: win.HGLRC, /*!< source graphics context */
            hdcMem: win.HDC,
            bitmap: win.HBITMAP,
            bitmapBits: [^]byte,
            maxSize, minSize, aspectRatio: Area /*!< for setting max/min resize (RGFW_WINDOWS) */
        }

    } else {
        _window_src :: struct {
            window: win.HWND, /*!< source window */
            hdc: win.HDC, /*!< source HDC */
            hOffset: u32, /*!< height offset for window */
            hIconSmall, hIconBig: win.HICON, /*!< source window icons */
            ctx: win.HGLRC, /*!< source graphics context */
            maxSize, minSize, aspectRatio: Area /*!< for setting max/min resize (RGFW_WINDOWS) */
        }
    }

} else {
    when RGFW_BUFFER {
        _window_src :: struct {
            window: win.HWND, /*!< source window */
            hdc: win.HDC, /*!< source HDC */
            hOffset: u32, /*!< height offset for window */
            hIconSmall, hIconBig: win.HICON, /*!< source window icons */
            hdcMem: win.HDC,
            bitmap: win.HBITMAP,
            bitmapBits: [^]byte,
            maxSize, minSize, aspectRatio: Area /*!< for setting max/min resize (RGFW_WINDOWS) */
        }
        
    } else {
        _window_src :: struct {
            window: win.HWND, /*!< source window */
            hdc: win.HDC, /*!< source HDC */
            hOffset: u32, /*!< height offset for window */
            hIconSmall, hIconBig: win.HICON, /*!< source window icons */
            maxSize, minSize, aspectRatio: Area /*!< for setting max/min resize (RGFW_WINDOWS) */
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

	_threadFunc_ptr :: #type proc "std" (lpThreadParameter: win.LPVOID) -> win.DWORD
}
/* */


