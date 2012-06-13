module meta.wrappers.glfw.window;

/* imports */
private {
	import meta.wrappers.opengl.common;
	import meta.wrappers.glfw.common;
	import std.conv : to;
}
public {
}


/* window error */
class window_error : runtime_error {
	this(string reason) {
		super("window error; reason: " ~ reason);
	}
}


/* window class */
/* TODO: if full=true, exception thrown, fixit */
class window {
    private GLFWwindow _window; /* wrapped window */

    this(int majver, int minver, int w, int h, bool full, string title) {
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, majver);
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, minver);
        glfwOpenWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        _window = glfwOpenWindow(w, h, GLFW_WINDOWED | (full ? GLFW_FULLSCREEN : 0), cast(const(char)*)title, null);
        if (_window == null) {
            auto errstr = to!string(glfwErrorString(glfwGetError()));
            throw new window_error("unable to create the window; glfw error: " ~ errstr);
        }
        logger.inst().deb("Created a window {(%dx%d), fullscreen=%s}", w, h, full ? "on" : "off");
        DerelictGL3.reload();
        logger.inst().deb("Reloaded GL3 module");
    }

    ~this() {
        glfwCloseWindow(_window);
    }

    void fetch_events(bool wait = true)() {
        static if (wait)
            glfwWaitEvents();
        else
            glfwPollEvents();
    }

    key_state state(key k) {
        return glfwGetKey(_window, k);
    }

/*
    auto param(string param)() if (string == "opened") {
        return glfwWindowGetParam(GLFW_OPENED);
    }
*/

    alias glfwSwapBuffers swap_buffers;
}


/* keyboard key */
alias int key;

/* key states */
alias int key_state;
alias GLFW_PRESS   KS_PRESSED;
alias GLFW_RELEASE KS_RELEASED;

/* special keys*/
alias int special_key;
alias GLFW_KEY_SPACE SK_SPACE;
alias GLFW_KEY_ESC   SK_ESC;
alias GLFW_KEY_ENTER SK_ENTER;

/* window params */
alias int window_param;
//alias GLFW_OPENED WP_OPENED;

