package rgfw_odin_bindings

import "core:c"

@require import vk "vendor:vulkan"
@require import gl "vendor:OpenGl"
@require import "vendor:directx/dxgi"

foreign import rgfw "./lib/libRGFW.lib"

RGFW_BUFFER  :: true
RGFW_WEBGPU  :: true  // Only Backend Supported for WASM
RGFW_OPENGL  :: true  // Not Supported on Linux
RGFW_X11     :: true  // Only Backend Supported for Linux
RGFW_EGL     :: true  // Only Backend Supported for Linux
RGFW_VULKAN  :: true
RGFW_DIRECTX :: true

RGFW_OSMESA  :: false // Not Supported
RGFW_WAYLAND :: false // Not Supported

RGFW_ADVANCED_SMOOTH_RESIZE :: false

RGFW_NO_MONITOR     :: false
RGFW_NO_PASSTHROUGH :: false
RGFW_NO_THREADS     :: false


/*
	Defined as `c.ptrdiff_t :: distinct int`.
	So it's the correct sign by may not be the correct size on some targerts.
*/
ssize_t :: c.ptrdiff_t

Key :: distinct u8


eventType :: enum u8 {
    /*! event codes */
	eventNone = 0, /*!< no event has been sent */
 	keyPressed, /* a key has been pressed */
	keyReleased, /*!< a key has been released */
	// FIXME
	/*! key event note
		the code of the key pressed is stored in
		RGFW_event.key
		!!Keycodes defined at the bottom of the RGFW_HEADER part of this file!!

		while a string version is stored in
		RGFW_event.KeyString

		RGFW_event.keyMod holds the current keyMod
		this means if CapsLock, NumLock are active or not
	*/
	mouseButtonPressed, /*!< a mouse button has been pressed (left,middle,right) */
	mouseButtonReleased, /*!< a mouse button has been released (left,middle,right) */
	mousePosChanged, /*!< the position of the mouse has been changed */
	/*! mouse event note
		the x and y of the mouse can be found in the vector, RGFW_event.point

		RGFW_event.button holds which mouse button was pressed
	*/
	gamepadConnected, /*!< a gamepad was connected */
	gamepadDisconnected, /*!< a gamepad was disconnected */
	gamepadButtonPressed, /*!< a gamepad button was pressed */
	gamepadButtonReleased, /*!< a gamepad button was released */
	gamepadAxisMove, /*!< an axis of a gamepad was moved */
	/*! gamepad event note
		RGFW_event.gamepad holds which gamepad was altered, if any
		RGFW_event.button holds which gamepad button was pressed

		RGFW_event.axis holds the data of all the axises
		RGFW_event.axisesCount says how many axises there are
	*/
	windowMoved, /*!< the window was moved (by the user) */
	windowResized, /*!< the window was resized (by the user), [on WASM this means the browser was resized] */
	focusIn, /*!< window is in focus now */
	focusOut, /*!< window is out of focus now */
	mouseEnter, /* mouse entered the window */
	mouseLeave, /* mouse left the window */
	windowRefresh, /* The window content needs to be refreshed */

	/* attribs change event note
		The event data is sent straight to the window structure
		with win->r.x, win->r.y, win->r.w and win->r.h
	*/
	quit, /*!< the user clicked the quit button */
	DND, /*!< a file has been dropped into the window */
	DNDInit, /*!< the start of a dnd event, when the place where the file drop is known */
	/* dnd data note
		The x and y coords of the drop are stored in the vector RGFW_event.point

		RGFW_event.droppedFilesCount holds how many files were dropped

		This is also the size of the array which stores all the dropped file string,
		RGFW_event.droppedFiles
	*/
	windowMaximized, /*!< the window was maximized */
	windowMinimized, /*!< the window was minimized */
	windowRestored, /*!< the window was restored */
	scaleUpdated /*!< content scale factor changed */
}


/*! mouse button codes (RGFW_event.button) */
mouseButton :: enum u8 {
	mouseLeft = 0, /*!< left mouse button is pressed */
	mouseMiddle, /*!< mouse-wheel-button is pressed */
	mouseRight, /*!< right mouse button is pressed */
	mouseScrollUp, /*!< mouse wheel is scrolling up */
	mouseScrollDown, /*!< mouse wheel is scrolling down */
	mouseMisc1,
    mouseMisc2, 
    mouseMisc3, 
    mouseMisc4, 
    mouseMisc5,
	mouseFinal
}

MAX_PATH  :: 260 /* max length of a path (for dnd) */
MAX_DROPS :: 260 /* max items you can drop at once */

/* for RGFW_event.lockstate */
keymod_set :: bit_set[keymod; u8]
keymod :: enum u8 {
	modCapsLock   = 0,
	modNumLock    = 1,
	modControl    = 2,
	modAlt        = 3,
	modShift      = 4,
	modSuper      = 5,
	modScrollLock = 6
}


/*! gamepad button codes (based on xbox/playstation), you may need to change these values per controller */
gamepadCodes :: enum u8 {
	gamepadNone = 0, /*!< or PS X button */
	gamepadA, /*!< or PS X button */
	gamepadB, /*!< or PS circle button */
	gamepadY, /*!< or PS triangle button */
	gamepadX, /*!< or PS square button */
	gamepadStart, /*!< start button */
	gamepadSelect, /*!< select button */
	gamepadHome, /*!< home button */
	gamepadUp, /*!< dpad up */
	gamepadDown, /*!< dpad down */
	gamepadLeft, /*!< dpad left */
	gamepadRight, /*!< dpad right */
	gamepadL1, /*!< left bump */
	gamepadL2, /*!< left trigger */
	gamepadR1, /*!< right bumper */
	gamepadR2, /*!< right trigger */
	gamepadL3,  /* left thumb stick */
	gamepadR3, /*!< right thumb stick */
	gamepadFinal
}


/*! basic vector type */
Point :: [2]i32
/*! basic vector type */
Rect  :: [4]i32
/*! basic area type */
Area  :: [2]u32

/* monitor mode data | can be changed by the user (with functions)*/
monitorMode :: struct {
    area: Area, /*!< monitor workarea size */
    refreshRate: u32, /*!< monitor refresh rate */
    red, blue, green: u8,
}

/*! structure for monitor data */
monitor :: struct {
    x, y: i32, /*!< x - y of the monitor workarea */
    name: [128]u8, /*!< monitor name */
    scaleX, scaleY: f32, /*!< monitor content scale */
    pixelRatio: f32, /*!< pixel ratio for monitor (1.0 for regular, 2.0 for hiDPI)  */
    physW, physH: f32, /*!< monitor physical size in inches */
    mode: monitorMode,
}


modeRequest_set :: bit_set[modeRequest; u8]
modeRequest :: enum u8 {
    monitorScale    = 0, /*!< scale the monitor size */
    monitorRefresh  = 1, /*!< change the refresh rate */
    monitorRGB      = 2, /*!< change the monitor RGB bits size */
}
MODE_REQUEST_ALL :: modeRequest_set{.monitorRefresh, .monitorRGB, .monitorScale}


/* RGFW mouse loading */
mouse :: distinct rawptr

/* NOTE: some parts of the data can represent different things based on the event (read comments in RGFW_event struct) */
/*! Event structure for checking/getting events */
event :: struct {
	type: eventType, /*!< which event has been sent?*/
	point: Point, /*!< mouse x, y of event (or drop point) */
	vector: Point, /*!< raw mouse movement */
	scaleX, scaleY: f32, /*!< DPI scaling */

	// FIXME
	key: Key, /*!< the physical key of the event, refers to where key is physically !!Keycodes defined at the bottom of the RGFW_HEADER part of this file!! */
	keyChar: u8, /*!< mapped key char of the event */

	repeat: bool, /*!< key press event repeated (the key is being held) */
	keyMod: keymod_set,

	button: u8, /* !< which mouse (or gamepad) button was pressed */
	scroll: f64, /*!< the raw mouse scroll value */

	gamepad: u16, /*! which gamepad this event applies to (if applicable to any) */
	axisesCount: u8, /*!< number of axises */

	whichAxis: u8, /* which axis was effected */
	axis: [4]Point, /*!< x, y of axises (-100 to 100) */

	/*! drag and drop data */
	/* 260 max paths with a max length of 260 */
	// TODO: is char**, [^][^]byte or [^]cstring ???
	droppedFiles: [^][^]byte, /*!< dropped files */
	droppedFilesCount: uint, /*!< house many files were dropped */

	_win: rawptr, /*!< the window this event applies too (for event queue events) */
}


/*! source data for the window (used by the APIs) */
window_src :: _window_src


/*! Optional arguments for making a windows */
windowFlags :: bit_set[windowFlag; u32]
windowFlag :: enum u32 {
	windowNoInitAPI       = 0, /* do NOT init an API (including the software rendering buffer) (mostly for bindings. you can also use `#define RGFW_NO_API`) */
	windowNoBorder        = 1, /*!< the window doesn't have a border */
	windowNoResize        = 2, /*!< the window cannot be resized by the user */
	windowAllowDND        = 3, /*!< the window supports drag and drop */
	windowHideMouse       = 4, /*! the window should hide the mouse (can be toggled later on using `RGFW_window_mouseShow`) */
	windowFullscreen      = 5, /*!< the window is fullscreen by default */
	windowTransparent     = 6, /*!< the window is transparent (only properly works on X11 and MacOS, although it's meant for for windows) */
	windowCenter          = 7, /*! center the window on the screen */
	windowOpenglSoftware  = 8, /*! use OpenGL software rendering */
	windowCocoaCHDirToRes = 9, /*! (cocoa only), change directory to resource folder */
	windowScaleToMonitor  = 10, /*! scale the window to the screen */
	windowHide            = 11, /*! the window is hidden */
	windowMaximize        = 12,
	windowCenterCursor    = 13,
	windowFloating        = 14, /*!< create a floating window */
	windowFreeOnClose     = 15, /*!< free (RGFW_window_close) the RGFW_window struct when the window is closed (by the end user) */
	windowFocusOnShow     = 16, /*!< focus the window when it's shown */
	windowMinimize        = 17, /*!< focus the window when it's shown */
	windowFocus           = 18, /*!< if the window is in focus */
}

WINDOW_FLAGS_WINDOWED_FULLSCREEN :: windowFlags{ .windowNoBorder, .windowMaximize }


when RGFW_BUFFER {
	window :: struct {
		buffer: [^]byte, /*!< buffer for non-GPU systems (OSMesa, basic software rendering) */
		/* when rendering using RGFW_BUFFER, the buffer is in the RGBA format */
		bufferSize: Area,
		userPtr: rawptr, /* ptr for usr data */
		event: event, /*!< current event */
		r: Rect, /*!< the x, y, w and h of the struct */
		_lastMousePoint: Point, /*!< last cusor point (for raw mouse data) */
		_flags: windowFlags, /*!< windows flags (for RGFW to check) */
		_oldRect: Rect, /*!< rect before fullscreen */
	}

} else {
	window :: struct {
		userPtr: rawptr, /* ptr for usr data */
		event: event, /*!< current event */
		r: Rect, /*!< the x, y, w and h of the struct */
		_lastMousePoint: Point, /*!< last cusor point (for raw mouse data) */
		_flags: windowFlags, /*!< windows flags (for RGFW to check) */
		_oldRect: Rect, /*!< rect before fullscreen */
	}
}


when RGFW_X11 || ODIN_OS == .Darwin {
	thread :: distinct u64
} else {
	thread :: distinct rawptr
}


/*!
	for RGFW_window_eventWait and RGFW_window_checkEvents
	waitMS -> Allows the function to keep checking for events even after `RGFW_window_checkEvent == NULL`
			  if waitMS == 0, the loop will not wait for events
			  if waitMS > 0, the loop will wait that many miliseconds after there are no more events until it returns
			  if waitMS == -1 or waitMS == the max size of an unsigned 32-bit int, the loop will not return until it gets another event
*/
eventWait :: enum i32 {
	eventNoWait = 0,
	eventWaitNext = -1
}


icon_set :: bit_set[icon; u8]
icon :: enum u8 {
	iconTaskbar = 0,
	iconWindow  = 1,
}
ICON_BOTH :: icon_set{ .iconTaskbar, .iconWindow }



/* error handling */
debugType :: enum u8 {
	typeError = 0, 
	typeWarning, 
	typeInfo,
}

errorCode :: enum u8 {
	noError = 0, /*!< no error */
	errOpenglContext, errEGLContext, /*!< error with the OpenGL context */
	errWayland,
	errDirectXContext,
	errIOKit,
	errClipboard,
	errFailedFuncLoad,
	errBuffer,
	infoMonitor, infoWindow, infoBuffer, infoGlobal, infoOpenGL,
	warningWayland, warningOpenGL
}

debugContext :: struct { 
	win: ^window,
	monitor: monitor, 
	srcError: u32,
}

debugfunc :: #type proc "c" (type: debugType, err: errorCode, ctx: debugContext, msg: cstring)


/*
	event callbacks.
	These are completely optional, so you can use the normal
	RGFW_checkEvent() method if you prefer that

* Callbacks
*/

/*! RGFW_windowMoved, the window and its new rect value  */
windowMovedfunc :: #type proc "c" (win: ^window, r: Rect)
/*! RGFW_windowResized, the window and its new rect value  */
windowResizedfunc :: #type proc "c" (win: ^window, r: Rect)
/*! RGFW_windowRestored, the window and its new rect value  */
windowRestoredfunc :: #type proc "c" (win: ^window, r: Rect)
/*! RGFW_windowMaximized, the window and its new rect value  */
windowMaximizedfunc :: #type proc "c" (win: ^window, r: Rect)
/*! RGFW_windowMinimized, the window and its new rect value  */
windowMinimizedfunc :: #type proc "c" (win: ^window, r: Rect)
/*! RGFW_quit, the window that was closed */
windowQuitfunc :: #type proc "c" (win: ^window)
/*! RGFW_focusIn / RGFW_focusOut, the window who's focus has changed and if its in focus */
focusfunc :: #type proc "c" (win: ^window, inFocus: bool)
/*! RGFW_mouseEnter / RGFW_mouseLeave, the window that changed, the point of the mouse (enter only) and if the mouse has entered */
mouseNotifyfunc :: #type proc "c" (win: ^window, point: Point, status: bool)
/*! RGFW_mousePosChanged, the window that the move happened on, and the new point of the mouse  */
mousePosfunc :: #type proc "c" (win: ^window, point: Point, vector: Point)
/*! RGFW_DNDInit, the window, the point of the drop on the windows */
dndInitfunc :: #type proc "c" (win: ^window, point: Point)
/*! RGFW_windowRefresh, the window that needs to be refreshed */
windowRefreshfunc :: #type proc "c" (win: ^window)
/*! RGFW_keyPressed / RGFW_keyReleased, the window that got the event, the mapped key, the physical key, the string version, the state of the mod keys, if it was a press (else it's a release) */
// FIXME
keyfunc :: #type proc "c" (win: ^window, key: u8, keyChar: u8, keyMod: keymod_set, pressed: bool)
/*! RGFW_mouseButtonPressed / RGFW_mouseButtonReleased, the window that got the event, the button that was pressed, the scroll value, if it was a press (else it's a release)  */
mouseButtonfunc :: #type proc "c" (win: ^window, button: mouseButton, scroll: f64, pressed: bool)
/*! RGFW_gamepadButtonPressed, the window that got the event, the button that was pressed, the scroll value, if it was a press (else it's a release) */
// FIXME
gamepadButtonfunc :: #type proc "c" (win: ^window, gamepad: u16, button: u8, pressed: bool)
/*! RGFW_gamepadAxisMove, the window that got the event, the gamepad in question, the axis values and the axis count */
gamepadAxisfunc :: #type proc "c" (win: ^window, gamepad: u16, axis: [2]Point, axisesCount: u8, whichAxis: u8)
/*! RGFW_gamepadConnected / RGFW_gamepadDisconnected, the window that got the event, the gamepad in question, if the controller was connected (else it was disconnected) */
gamepadfunc :: #type proc "c" (win: ^window, gamepad: u16, connected: bool)
/*! RGFW_dnd, the window that had the drop, the drop data and the number of files dropped */
dndfunc :: #type proc "c" (win: ^window, droppedFiles: [^][^]byte, droppedFilesCount: uint)
/*! RGFW_scaleUpdated, the window the event was sent to, content scaleX, content scaleY */
scaleUpdatedfunc :: #type proc "c" (win: ^window, scaleX: f32, scaleY: f32)
/* */


/* Threads */
when !RGFW_NO_THREADS {
	/*! threading functions */

	/*! NOTE! (for X11/linux) : if you define a window in a thread, it must be run after the original thread's window is created or else there will be a memory error */
	/*
		I'd suggest you use sili's threading functions instead
		if you're going to use sili
		which is a good idea generally
	*/

	threadFunc_ptr :: _threadFunc_ptr
}
/* */

/* gamepad */
gamepadType :: enum u8 {
	gamepadMicrosoft = 0, 
	_gamepadSony, 
	gamepadNintendo, 
	gamepadLogitech, 
	gamepadUnknown,
}
/* */


/* graphics_API */

/*! native API functions */
when RGFW_OPENGL || RGFW_EGL {
	glHints :: enum u8 {
		glStencil = 0,  /*!< set stencil buffer bit size (8 by default) */
		glSamples, /*!< set number of sampiling buffers (4 by default) */
		glStereo, /*!< use GL_STEREO (GL_FALSE by default) */
		glAuxBuffers, /*!< number of aux buffers (0 by default) */
		glDoubleBuffer, /*!< request double buffering */
		glRed, glGreen, glBlue, glAlpha, /*!< set RGBA bit sizes */
		glDepth,
		glAccumRed, glAccumGreen, glAccumBlue, glAccumAlpha, /*!< set accumulated RGBA bit sizes */
		glSRGB, /*!< request sRGA */
		glRobustness, /*!< request a robust context */
		glDebug, /*!< request opengl debugging */
		glNoError, /*!< request no opengl errors */
		glReleaseBehavior,
		glProfile,
		glMajor, RGFW_glMinor,
		glFinalHint = 32, /*!< the final hint (not for setting) */
		releaseFlush = 0,  glReleaseNone, /* RGFW_glReleaseBehavior options */
		glCore = 0,  glCompatibility /*!< RGFW_glProfile options */
	}
}

when RGFW_VULKAN {
	when RGFW_X11 {
		VK_SURFACE :: "VK_KHR_xlib_surface"
	} else when ODIN_OS == .Windows {
		VK_SURFACE :: "VK_KHR_win32_surface"
	} else when ODIN_OS == .Darwin {
		VK_SURFACE :: "VK_MVK_macos_surface"
	} else {
		VK_SURFACE :: ""
	}
}
/* */


@(default_calling_convention="c", link_prefix="RGFW_")
foreign rgfw {
    useWayland :: proc(wayland: bool) ---
    usingWayland :: proc() -> bool ---

    /*! get an array of all the monitors (max 6) */
    getMonitors :: proc(len: ^uint) -> [^]monitor ---
    /*! get the primary monitor */
    getPrimaryMonitor :: proc() -> monitor ---

    /*! request a specific mode */
    monitor_requestMode :: proc(mon: monitor, mode: monitorMode, request: modeRequest_set) -> bool ---
    /*! check if 2 monitor modes are the same */
    monitorModeCompare :: proc(mon: monitor, mon2: monitor, request: modeRequest_set) -> bool ---

    /*!< loads mouse icon from bitmap (similar to RGFW_window_setIcon). Icon NOT resized by default */
    loadMouse :: proc(icon: ^u8, a: Area, channels: i32 ) -> ^mouse ---
    /*!< frees RGFW_mouse data */
    freeMouse :: proc(mouse: ^mouse) ---

	/*! scale monitor to window size */
	monitor_scaleToWindow :: proc(mon: monitor, win: ^window) -> bool ---

	/* Window_management */

	/*!
	* the class name for X11 and WinAPI. apps with the same class will be grouped by the WM
	* by default the class name will == the root window's name
	*/
	setClassName :: proc(name: cstring) ---
	setXInstName :: proc(name: cstring) --- /*!< X11 instance name (window name will by used by default) */

	/*! (cocoa only) change directory to resource folder */
	moveToMacOSResourceDir :: proc() ---

	/* NOTE: (windows) if the executable has an icon resource named RGFW_ICON, it will be set as the initial icon for the window */

	createWindow :: proc(
		name: cstring, /* name of the window */
		rect: Rect, /* rect of window */
		flags: windowFlags /* extra arguments ((u32)0 means no flags used)*/
	) -> ^window --- /*!< function to create a window and struct */

	createWindowPtr :: proc(
		name: cstring, /* name of the window */
		rect: Rect, /* rect of window */
		flags: windowFlags, /* extra arguments (NULL / (u32)0 means no flags used) */
		win: ^window /* ptr to the window struct you want to use */
	) -> ^window --- /*!< function to create a window (without allocating a window struct) */

	window_initBuffer :: proc(win: ^window) ---
	window_initBufferSize :: proc(win: ^window, area: Area) ---
	window_initBufferPtr :: proc(win: ^window, buffer: [^]byte, area: Area) ---

	/*! set the window flags (will undo flags if they don't match the old ones) */
	window_setFlags :: proc(win: ^window, flags: windowFlags) ---

	/*! get the size of the screen to an area struct */
	RGFW_getScreenSize :: proc() -> Area ---


	/*!
		this function checks an *individual* event (and updates window structure attributes)
		this means, using this function without a while loop may cause event lag

		ex.

		while (RGFW_window_checkEvent(win) != NULL) [this keeps checking events until it reaches the last one]

		this function is optional if you choose to use event callbacks,
		although you still need some way to tell RGFW to process events eg. `RGFW_window_checkEvents`
	*/

	window_checkEvent :: proc(win: ^window) -> ^event --- /*!< check current event (returns a pointer to win->event or NULL if there is no event)*/


	/*! sleep until RGFW gets an event or the timer ends (defined by OS) */
	window_eventWait :: proc(win: ^window, waitMS: i32) ---

	/*!
		check all the events until there are none left.
		This should only be used if you're using callbacks only
	*/
	window_checkEvents :: proc(win: ^window, waitMS: i32) ---

	/*!
		tell RGFW_window_eventWait to stop waiting (to be ran from another thread)
	*/
	stopCheckEvents :: proc() ---

	/*! window managment functions */
	window_close :: proc(win: ^window) --- /*!< close the window and free leftover data */

	/*! move a window to a given point */
	window_move :: proc(win: ^window,
		v: Point, /*!< new pos */
	) ---

	when !RGFW_NO_MONITOR {
		/*! move window to a specific monitor */
		window_moveToMonitor :: proc(win: ^window, m: monitor /* monitor */) ---
	}

	/*! resize window to a current size/area */
	window_resize :: proc(win: ^window, /*!< source window */
		a: Area, /*!< new size */
	) ---

	/*! set window aspect ratio */
	window_setAspectRatio :: proc(win: ^window, a: Area) ---
	/*! set the minimum dimensions of a window */
	window_setMinSize :: proc(win: ^window, a: Area) ---
	/*! set the maximum dimensions of a window */
	window_setMaxSize :: proc(win: ^window, a: Area) ---

	window_focus :: proc(win: ^window) --- /*!< sets the focus to this window */
	window_isInFocus :: proc(win: ^window) -> bool --- /*!< checks the focus to this window */
	window_raise :: proc(win: ^window) --- /*!< raise the window (to the top) */
	window_maximize :: proc(win: ^window) --- /*!< maximize the window */
	window_setFullscreen :: proc(win: ^window, fullscreen: bool) --- /*!< turn fullscreen on / off for a window */
	window_center :: proc(win: ^window) --- /*!< center the window */
	window_minimize :: proc(win: ^window) --- /*!< minimize the window (in taskbar (per OS))*/
	window_restore :: proc(win: ^window) --- /*!< restore the window from minimized (per OS)*/
	window_setFloating :: proc(win: ^window, floating: bool) --- /*!< make the window a floating window */
	window_setOpacity :: proc(win: ^window, opacity: u8) --- /*!< sets the opacity of a window */

	/*! if the window should have a border or not (borderless) based on bool value of `border` */
	window_setBorder :: proc(win: ^window, border: bool) ---
	window_borderless :: proc(win: ^window) -> bool ---

	/*! turn on / off dnd (RGFW_windowAllowDND stil must be passed to the window)*/
	window_setDND :: proc(win: ^window, allow: bool) ---
	/*! check if DND is allowed */
	window_allowsDND :: proc(win: ^window) -> bool ---

	when !RGFW_NO_PASSTHROUGH {
		/*! turn on / off mouse passthrough */
		window_setMousePassthrough :: proc(win: ^window, passthrough: bool) ---
	}

	/*! rename window to a given string */
	window_setName :: proc(win: ^window, name: cstring) ---

	window_setIcon :: proc(win: ^window, /*!< source window */
		icon: [^]u8 /*!< icon bitmap */,
		a: Area /*!< width and height of the bitmap */,
		channels: i32 /*!< how many channels the bitmap has (rgb : 3, rgba : 4) */
	) -> bool --- /*!< image MAY be resized by default, set both the taskbar and window icon */

	window_setIconEx :: proc(win: ^window, icon: [^]byte, a: Area, channels: i32, type: icon_set) -> bool ---

	/*!< sets mouse to RGFW_mouse icon (loaded from a bitmap struct) */
	window_setMouse :: proc(win: ^window, mouse: ^mouse) ---

	/*!< sets the mouse to a standard API cursor (based on RGFW_MOUSE, as seen at the end of the RGFW_HEADER part of this file) */
	// FIXME
	window_setMouseStandard :: proc(win: ^window, umouse: u8) -> bool ---

	window_setMouseDefault :: proc(win: ^window) -> bool --- /*!< sets the mouse to the default mouse icon */
	/*
		Locks cursor at the center of the window
		win->event.point becomes raw mouse movement data

		this is useful for a 3D camera
	*/
	window_mouseHold :: proc(win: ^window, area: Area) ---
	/*! stop holding the mouse and let it move freely */
	window_mouseUnhold :: proc(win: ^window) ---

	/*! hide the window */
	window_hide :: proc(win: ^window) ---
	/*! show the window */
	window_show :: proc(win: ^window) ---

	/*
		makes it so `RGFW_window_shouldClose` returns true or overrides a window close
		by modifying window flags
	*/
	window_setShouldClose :: proc(win: ^window, shouldClose: bool) ---

	/*! where the mouse is on the screen */
	getGlobalMousePoint :: proc() -> Point ---

	/*! where the mouse is on the window */
	window_getMousePoint :: proc(win: ^window) -> Point ---

	/*! show the mouse or hide the mouse */
	window_showMouse :: proc(win: ^window, show: bool) ---
	/*! if the mouse is hidden */
	window_mouseHidden :: proc(win: ^window) -> bool ---
	/*! move the mouse to a given point */
	window_moveMouse :: proc(win: ^window, v: Point) ---

	/*! if the window should close (RGFW_close was sent or escape was pressed) */
	window_shouldClose :: proc(win: ^window) -> bool ---
	/*! if the window is fullscreen */
	window_isFullscreen :: proc(win: ^window) -> bool ---
	/*! if the window is hidden */
	window_isHidden :: proc(win: ^window) -> bool ---
	/*! if the window is minimized */
	window_isMinimized :: proc(win: ^window) -> bool ---
	/*! if the window is maximized */
	window_isMaximized :: proc(win: ^window) -> bool ---
	/*! if the window is floating */
	window_isFloating :: proc(win: ^window) -> bool ---
	/** @} */

	/* Monitor */
	when !RGFW_NO_MONITOR {
		/*
			scale the window to the monitor.
			This is run by default if the user uses the arg `RGFW_scaleToMonitor` during window creation
		*/
		window_scaleToMonitor :: proc(win: ^window) ---
		/*! get the struct of the window's monitor  */
		window_getMonitor :: proc(win: ^window) -> monitor ---
	}

	/* */

	/** * @defgroup Input
	* @{ */

	/*! if window == NULL, it checks if the key is pressed globally. Otherwise, it checks only if the key is pressed while the window in focus. */
	isPressed :: proc(win: ^window, key: Key) -> bool --- /*!< if key is pressed (key code)*/

	wasPressed :: proc(win: ^window, key: Key) -> bool --- /*!< if key was pressed (checks previous state only) (key code) */

	isHeld :: proc(win: ^window, key: Key) -> bool --- /*!< if key is held (key code) */
	isReleased :: proc(win: ^window, key: Key) -> bool --- /*!< if key is released (key code) */

	/* if a key is pressed and then released, pretty much the same as RGFW_isReleased */
	isClicked :: proc(win: ^window, key: Key /*!< key code */) -> bool ---

	/*! if a mouse button is pressed */
	isMousePressed :: proc(win: ^window, button: mouseButton /*!< mouse button code */ ) -> bool ---
	/*! if a mouse button is held */
	isMouseHeld :: proc(win: ^window, button: mouseButton /*!< mouse button code */ ) -> bool ---
	/*! if a mouse button was released */
	isMouseReleased :: proc(win: ^window, button: mouseButton /*!< mouse button code */ ) -> bool ---
	/*! if a mouse button was pressed (checks previous state only) */
	wasMousePressed :: proc(win: ^window, button: mouseButton /*!< mouse button code */ ) -> bool ---
	/* */


	/* Clipboard */
	readClipboard :: proc(size: ^uint) -> cstring; /*!< read clipboard data */
	/*! read clipboard data or send a NULL str to just get the length of the clipboard data */
	readClipboardPtr :: proc(str: [^]byte, strCapacity: uint) -> ssize_t ---
	writeClipboard :: proc(text: cstring, textLen: u32) --- /*!< write text to the clipboard */
	/* */


	/* error handling */
	setDebugCallback :: proc(func: debugfunc) -> debugfunc ---
	sendDebugInfo :: proc(type: debugType, err: errorCode, ctx: debugContext, msg: cstring) ---
	/* */


	/*
		event callbacks.
		These are completely optional, so you can use the normal
		RGFW_checkEvent() method if you prefer that

	* Callbacks
	*/
	/*! set callback for a window move event. Returns previous callback function (if it was set)  */
	setWindowMovedCallback :: proc(func: windowMovedfunc) -> windowMovedfunc ---
	/*! set callback for a window resize event. Returns previous callback function (if it was set)  */
	setWindowResizedCallback :: proc(func: windowResizedfunc) -> windowResizedfunc ---
	/*! set callback for a window quit event. Returns previous callback function (if it was set)  */
	setWindowQuitCallback :: proc(func: windowQuitfunc) -> windowQuitfunc ---
	/*! set callback for a mouse move event. Returns previous callback function (if it was set)  */
	setMousePosCallback :: proc(func: mousePosfunc) -> mousePosfunc ---
	/*! set callback for a window refresh event. Returns previous callback function (if it was set)  */
	setWindowRefreshCallback :: proc(func: windowRefreshfunc) -> windowRefreshfunc ---
	/*! set callback for a window focus change event. Returns previous callback function (if it was set)  */
	setFocusCallback :: proc(func: focusfunc) -> focusfunc ---
	/*! set callback for a mouse notify event. Returns previous callback function (if it was set)  */
	setMouseNotifyCallback :: proc(func: mouseNotifyfunc) -> mouseNotifyfunc ---
	/*! set callback for a drop event event. Returns previous callback function (if it was set)  */
	setDndCallback :: proc(func: dndfunc) -> dndfunc ---
	/*! set callback for a start of a drop event. Returns previous callback function (if it was set)  */
	setDndInitCallback :: proc(func: dndInitfunc) -> dndInitfunc ---
	/*! set callback for a key (press / release) event. Returns previous callback function (if it was set)  */
	setKeyCallback :: proc(func: keyfunc) -> keyfunc ---
	/*! set callback for a mouse button (press / release) event. Returns previous callback function (if it was set)  */
	setMouseButtonCallback :: proc(func: mouseButtonfunc) -> mouseButtonfunc ---
	/*! set callback for a controller button (press / release) event. Returns previous callback function (if it was set)  */
	setGamepadButtonCallback :: proc(func: gamepadButtonfunc) -> gamepadButtonfunc ---
	/*! set callback for a gamepad axis move event. Returns previous callback function (if it was set)  */
	setGamepadAxisCallback :: proc(func: gamepadAxisfunc) -> gamepadAxisfunc ---
	/*! set callback for when a controller is connected or disconnected. Returns the previous callback function (if it was set) */
	setGamepadCallback :: proc(func: gamepadfunc) -> gamepadfunc ---
	/*! set call back for when window is maximized. Returns the previous callback function (if it was set) */
	setWindowMaximizedCallback :: proc(func: windowResizedfunc) -> windowResizedfunc ---
	/*! set call back for when window is minimized. Returns the previous callback function (if it was set) */
	setWindowMinimizedCallback :: proc(func: windowResizedfunc) -> windowResizedfunc ---
	/*! set call back for when window is restored. Returns the previous callback function (if it was set) */
	setWindowRestoredCallback :: proc(func: windowResizedfunc) -> windowResizedfunc ---
	/*! set callback for when the DPI changes. Returns previous callback function (if it was set)  */
	setScaleUpdatedCallback :: proc(func: scaleUpdatedfunc) -> scaleUpdatedfunc ---
	/* */


	/* Threads */

	when !RGFW_NO_THREADS {
		/*! threading functions */

		/*! NOTE! (for X11/linux) : if you define a window in a thread, it must be run after the original thread's window is created or else there will be a memory error */
		/*
			I'd suggest you use sili's threading functions instead
			if you're going to use sili
			which is a good idea generally
		*/

		createThread :: proc(ptr:  threadFunc_ptr, args: rawptr) -> thread --- /*!< create a thread */
		cancelThread :: proc(thread: thread) --- /*!< cancels a thread */
		joinThread :: proc(thread: thread) --- /*!< join thread to current thread */
		setThreadPriority :: proc(thread: thread, priority: u8) --- /*!< sets the priority priority */
	}
	/* */


	/* gamepad */
	/*! gamepad count starts at 0*/
	isPressedGamepad :: proc(win: ^window, controller: u8, button: gamepadCodes) -> b32 ---
	isReleasedGamepad :: proc(win: ^window, controller: u8, button: gamepadCodes) -> b32 ---
	isHeldGamepad :: proc(win: ^window, controller: u8, button: gamepadCodes) -> b32 ---
	wasPressedGamepad :: proc(win: ^window, controller: u8, button: gamepadCodes) -> b32 ---
	getGamepadAxis :: proc(win: ^window, controller: u16, whichAxis: u16) -> Point ---
	getGamepadName :: proc(win: ^window, controller: u16) -> cstring ---
	getGamepadCount :: proc(win: ^window) -> uint ---
	RGFW_getGamepadType :: proc(win: ^window, controller: u16) -> gamepadType ---
	/* */

	/* graphics_API */

	/*!< make the window the current opengl drawing context

		NOTE:
		if you want to switch the graphics context's thread,
		you have to run RGFW_window_makeCurrent(NULL); on the old thread
		then RGFW_window_makeCurrent(valid_window) on the new thread
	*/
	window_makeCurrent :: proc(win: ^window) ---

	/*! get current RGFW window graphics context */
	RGFW_getCurrent :: proc() -> ^window ---

	/* supports openGL, directX, OSMesa, EGL and software rendering */
	window_swapBuffers :: proc(win: ^window) --- /*!< swap the rendering buffer */
	window_swapInterval :: proc(win: ^window, swapInterval: i32) ---
	/*!< render the software rendering buffer (this is called by RGFW_window_swapInterval)  */
	window_swapBuffers_software :: proc(win: ^window) ---

	/*! native API functions */
	when RGFW_OPENGL || RGFW_EGL {
		/*!< create an opengl context for the RGFW window, run by createWindow by default (unless the RGFW_windowNoInitAPI is included) */
		window_initOpenGL :: proc(win: ^window, software: boo) ---
		/*!< called by `RGFW_window_close` by default (unless the RGFW_windowNoInitAPI is set) */
		window_freeOpenGL :: proc(win: ^window) ---

		setGLHint :: proc(hint: glHints, value: i32) ---
		getProcAddress :: proc(procname: cstring) -> rawptr ---
		window_makeCurrent_OpenGL :: proc(win: ^window) --- /*!< to be called by RGFW_window_makeCurrent */
		window_swapBuffers_OpenGL :: proc(win: ^window) --- /*!< swap opengl buffer (only) called by RGFW_window_swapInterval  */
		getCurrent_OpenGL :: proc(void) -> rawptr --- /*!< get the current context (OpenGL backend (GLX) (WGL) (EGL) (cocoa) (webgl))*/
	}
	when RGFW_VULKAN {
		/* if you don't want to use the above macros */
		getVKRequiredInstanceExtensions :: proc(count: ^uint) -> ^cstring --- /*!< gets (static) extension array (and size (which will be 2)) */

		window_createVKSurface :: proc(win: ^window, instance: vk.Instance , surface: ^vk.SurfaceKHR) -> vk.Result ---
		getVKPresentationSupport :: proc(instance: vk.Instance, physicalDevice: vk.PhysicalDevice, queueFamilyIndex: u32) -> bool ---
	}
	when RGFW_DIRECTX {
		#assert(ODIN_OS == .Windows)
		window_createDXSwapChain :: proc(win: ^window, pFactory: ^dxgi.IFactory, pDevice: ^dxgi.IUnknown, swapchain: [^]^dxgi.ISwapChain) -> c.int ---
	}
	/* */
}


gl_set_proc_address :: proc(p: rawptr, name: cstring) {
	when RGFW_OPENGL || RGFW_EGL {
		(^rawptr)(p)^ = getProcAddress(name)
	}
}

round :: #force_inline proc "contextless" (x: $T) -> T {
    return T( x >= 0 ? f32(x) + 0.5 : f32(x) - 0.5 )
}