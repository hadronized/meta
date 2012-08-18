module meta.render.drivers.opengl.mesh_renderer;

/* imports */
private {
    import meta.models.mesh;
    import meta.render.adaptors.mesh_renderer;
    import meta.utils.fields;
    import meta.utils.logger;
    import meta.wrappers.opengl.buffer;
}
public {
}


mixin template ArrayFields(F...) {
    static if (F.length && !(F.length & 1)) {
        mixin ArrayFields!(F[2 .. F.length]);
        mixin Fields!(F[0][], F[1] ~ "v");
    }   
}

struct mesh_deintarlacer(V) {
    mixin ArrayFields!(V.fields_list);

    this(mesh!V m) in {
        assert ( m !is null );
    } body {
    }
}

class mesh_renderer_gl : mesh_renderer {
    private {
        buffer _vbo;
    }

    this(V)(mesh!V m) in {
        assert ( m !is null );
    } body {
        auto deint = new mesh_deinterlacer!V.fields_list;
        auto vert = m.vertices;

        _vbo = new buffer;

    }
}


