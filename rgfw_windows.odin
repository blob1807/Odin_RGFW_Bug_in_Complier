#+build windows
package rgfw_odin_bindings

import win "core:sys/windows"


when RGFW_OPENGL {
    when RGFW_BUFFER {
        _window_src :: struct {
            window:      win.HWND,  /*!< source window */
            hdc:         win.HDC,   /*!< source HDC */
            hOffset:     u32,       /*!< height offset for window */
            hIconSmall:  win.HICON, 
            hIconBig:    win.HICON, /*!< source window icons */
            ctx:         win.HGLRC, /*!< source graphics context */
            hdcMem:      win.HDC,
            bitmap:      win.HBITMAP,
            bitmapBits:  [^]byte,
            maxSize:     Area, 
            minSize:     Area, 
            aspectRatio: Area,      /*!< for setting max/min resize (RGFW_WINDOWS) */
        }

    } else {
        _window_src :: struct {
            window:      win.HWND,  /*!< source window */
            hdc:         win.HDC,   /*!< source HDC */
            hOffset:     u32,       /*!< height offset for window */
            hIconSmall:  win.HICON, 
            hIconBig:    win.HICON, /*!< source window icons */
            ctx:         win.HGLRC, /*!< source graphics context */
            maxSize:     Area, 
            minSize:     Area, 
            aspectRatio: Area       /*!< for setting max/min resize (RGFW_WINDOWS) */
        }
    }

} else {
    when RGFW_BUFFER {
        _window_src :: struct {
            window:      win.HWND,  /*!< source window */
            hdc:         win.HDC,   /*!< source HDC */
            hOffset:     u32,       /*!< height offset for window */
            hIconSmall:  win.HICON, 
            hIconBig:    win.HICON, /*!< source window icons */
            hdcMem:      win.HDC,
            bitmap:      win.HBITMAP,
            bitmapBits:  [^]byte,
            maxSize:     Area, 
            minSize:     Area, 
            aspectRatio: Area       /*!< for setting max/min resize (RGFW_WINDOWS) */
        }
        
    } else {
        _window_src :: struct {
            window:      win.HWND,  /*!< source window */
            hdc:         win.HDC,   /*!< source HDC */
            hOffset:     u32,       /*!< height offset for window */
            hIconSmall:  win.HICON, 
            hIconBig:    win.HICON, /*!< source window icons */
            maxSize:     Area, 
            minSize:     Area, 
            aspectRatio: Area       /*!< for setting max/min resize (RGFW_WINDOWS) */
        }
    }
}


/* Threads */
when !RGFW_NO_THREADS {
	/*! threading functions */
	_threadFunc_ptr :: #type proc "std" (lpThreadParameter: win.LPVOID) -> win.DWORD
}
/* */


