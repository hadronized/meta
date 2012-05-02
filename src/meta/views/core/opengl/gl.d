module meta.views.core.opengl.gl;

import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;
import meta.utils.one_instance;
import meta.utils.logger;
import meta.utils.runtime_error;

class component_not_loaded : runtime_error {
    this(string component, string reason) {
        super("OpenGL core failed to load the component \'" ~ component ~ "\'; reason: " ~ reason);
    }
}

static this() {
    logger.inst().deb("Initializing gl module");

    /* glfw initialization */
    try {
        DerelictGLFW3.load();
    } catch (Error e) {
        throw new component_not_loaded("glfw", e.msg);
    }
    if (!DerelictGLFW3.isLoaded())
        throw new component_not_loaded("glfw", "unknown");
        
    /* gl initialization */
    try {
        DerelictGL3.load();
    } catch (Error e) {
        throw new component_not_loaded("gl", e.msg);
    }
    if (!DerelictGL3.isLoaded())
        throw new component_not_loaded("gl", "unknown");

    logger.inst().deb("Successfully initialized gl module");
}

class gl_core {
    mixin OneInstance!gl_core;

    /* load specific extension here? */
}