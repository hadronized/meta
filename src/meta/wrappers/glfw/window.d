/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta, a render framework
    Copyright (C) 2012 Dimitri 'skp' Sabadie <dimitri.sabadie@gmail.com> 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

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
class CWindowError : CRuntimeError {
    this(string reason) {
        super("window error; reason: " ~ reason);
    }
}

/* window class */
/* TODO: if full=true, exception thrown, fixit */
class CWindow {
    private GLFWwindow _window; /* wrapped window */

    this(int majver, int minver, int w, int h, bool full, string title) {
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, majver);
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, minver);
        glfwOpenWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        _window = glfwOpenWindow(w, h, GLFW_WINDOWED | (full ? GLFW_FULLSCREEN : 0), cast(const(char)*)title, null);
        if (_window == null) {
            auto errstr = to!string(glfwErrorString(glfwGetError()));
            throw new CWindowError("unable to create the window; glfw error: " ~ errstr);
        }
        CLogger.inst().deb("Created a window {(%dx%d), fullscreen=%s}", w, h, full ? "on" : "off");
        DerelictGL3.reload();
        CLogger.inst().deb("Reloaded GL3 module");
    }

    ~this() {
        glfwCloseWindow(_window);
    }

    void fetch_events(bool wait = false)() {
        static if (wait)
            glfwWaitEvents();
        else
            glfwPollEvents();
    }

    key_state_t state(key_t k) {
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
alias int key_t;

/* key states */
alias int key_state_t;
alias GLFW_PRESS   KS_PRESSED;
alias GLFW_RELEASE KS_RELEASED;

/* special keys*/
alias int special_key_t;
alias GLFW_KEY_SPACE SK_SPACE;
alias GLFW_KEY_ESC   SK_ESC;
alias GLFW_KEY_ENTER SK_ENTER;

/* window params */
alias int window_param_t;
//alias GLFW_OPENED WP_OPENED;
