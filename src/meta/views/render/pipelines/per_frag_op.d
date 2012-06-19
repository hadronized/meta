module meta.views.render.pipelines.per_frag_op;

/* imports */
private {
    import meta.math.vecs;
    import meta.models.mesh;
    import meta.wrappers.opengl.buffer;
    import meta.wrappers.opengl.va;
    import meta.wrappers.opengl.shader;
    import meta.wrappers.opengl.shader_program;
}
public {
}


immutable auto PFO_VERTEX_SHADER_SRC = "
#version 300
in vec4 co;
smooth out vec2 uv;
void main() {
    gl_Position = co;
    uv = vec2( (co.x+1.f)/2, (1.f-co.y)/2 );
}";

version(wip) {
class per_frag_op {
    alias vec!(2, float) virt_screen_vertex_co;

    class virt_screen_vertex {
        virt_screen_vertex_co co;

        this(virt_screen_vertex_co co) {
            this.co = co;
        }
    }

    alias mesh!virt_screen_vertex virt_screen;
    
    private {
        buffer _vbo;
        buffer _ibo;
        va _va;
        shader _vs;
        shader _fs;
        shader_program _sp;
    }

    this(string src) {
        init_shader_(src);
        init_buffers_();
    }

    private void init_shader_(string src) {
        _vs.compile(PFO_VERTEX_SHADER_SRC);
        _fs.compile(src);
        with (_sp) {
            attach(_vs);
            attach(_fs);
            link();
        }
    }

    private void init_buffers_() {
        /* VBO initialization */
        _vbo = new buffer(buffer_type.ARRAY);
        auto screen = create_virt_screen();

        with (_vbo) {
            use();
            commit(screen.sizeof, screen.vertices.ptr.co.as_array.ptr, buffer_usage.DYNAMIC_DRAW);
            done();
        }
    }

    private virt_screen create_virt_screen() {
        /* a virtual screen has 4 vertices, i.e. the 4 corners of the screen */
        auto screen = new virt_screen;
        with (screen) {
            add_vertex( new virt_screen_vertex_co(-1.,  1.) );
            add_vertex( new virt_screen_vertex_co( 1.,  1.) );
            add_vertex( new virt_screen_vertex_co( 1., -1.) );
            add_vertex( new virt_screen_vertex_co(-1., -1.) );
        }

        return screen;
    }

    void apply() {
    }

    unittest {
        auto fs = new shader(shader_type.FRAGMENT);
        auto pfo = new per_frag_op(fs);

        pfo.apply();
    }
}
}
