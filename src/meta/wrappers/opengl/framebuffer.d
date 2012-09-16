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

module meta.wrappers.opengl.framebuffer;

/* imports */
private {
    import meta.wrappers.opengl.common;
    import meta.wrappers.opengl.renderbuffer;
    import meta.wrappers.opengl.texture;
}

class CFramebuffer {
    mixin MTGLObject!uint;

    this() {
        glGenFramebuffers(1, &_id);
        assert ( _id );
        fetch_error("this");
    }

    ~this() {
        glDeleteFramebuffers(1, &_id);
    }
}

enum EFramebufferTarget {
    DRAW = GL_DRAW_FRAMEBUFFER,
    READ = GL_READ_FRAMEBUFFER
}


template TFramebufferColorAttachment(int I_) {
    enum TFramebufferColorAttachment = GL_COLOR_ATTACHMENT0+I_;
}

enum EFramebufferAttachment {
    DEPTH = GL_DEPTH_ATTACHMENT,
    STENCIL = GL_STENCIL_ATTACHMENT,
    DEPTH_STENCIL = GL_DEPTH_STENCIL_ATTACHMENT
}

struct SFramebufferBinder {
    mixin MTGLError;

    private EFramebufferTarget _target;

    this(const CFramebuffer fb, EFramebufferTarget t) in {
        assert ( fb !is null );
    } body {
        bind(fb, t);
    }

    ~this() {
        glBindFramebuffer(_target, 0);
    }

    void bind(const CFramebuffer fb, EFramebufferTarget t) in {
        assert ( fb !is null );
    } body {
        glBindFramebuffer(t, fb.id);
        fetch_error("bind");
        _target = t;
    }

    void attach(const CRenderbuffer rb, ERenderbufferTarget t, int a) {
        glFramebufferRenderbuffer(_target, a, t, rb.id);
        fetch_error("attach(renderbuffer)");
    }

    void attach(const CTexture t, int level, int a) {
        glFramebufferTexture(_target, a, t.id, level);
        fetch_error("attach(texture)");
    }

    void check_status() {
        auto v = glCheckFramebufferStatus(_target);
        fetch_error("this");

        final switch (v) {
            case GL_FRAMEBUFFER_COMPLETE :
                CLogger.inst().deb("Framebuffer complete");
                break;

            case GL_FRAMEBUFFER_UNDEFINED :
                throw new CFramebufferCompletenessError("undefined");

            case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT :
                throw new CFramebufferCompletenessError("attachment");

            case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT :
                throw new CFramebufferCompletenessError("missing attchment");

            case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER :
                throw new CFramebufferCompletenessError("draw buffer");

            case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER :
                throw new CFramebufferCompletenessError("read buffer");

            case GL_FRAMEBUFFER_UNSUPPORTED :
                throw new CFramebufferCompletenessError("unsupported");

            case GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE :
                throw new CFramebufferCompletenessError("multisample");

            case GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS :
                throw new CFramebufferCompletenessError("layer targets");
        }
    }
}

class CFramebufferCompletenessError : CRuntimeError {
    this(string reason) {
        super("framebuffer completeness violated; reason: " ~ reason);
    }
}
