module meta.render.drivers.opengl.mesh_renderer;

/* imports */
private {
    import meta.models.mesh;
    import meta.render.adaptors.mesh_renderer;
    import meta.wrappers.opengl.buffer;
    import skp.fields;
    import skp.logger;
}
public {
}

private mixin template MTArrayFields(F_...) {
    static if (F_.length && !(F_.length & 1)) {
        mixin MTArrayFields!(F_[2 .. F_.length]);
        mixin Fields!(F_[0][], F_[1] ~ "v");
    }   
}

struct SMeshDeintarlacer(V_) {
    mixin MTArrayFields!(V_.fields_list);

    this(mesh!V_ m) in {
        assert ( m !is null );
    } body {
    }
}

class CMeshRendererGL : IMeshRenderer {
    private {
        CBuffer _vbo;
    }

    this(V_)(mesh!V_ m) in {
        assert ( m !is null );
    } body {
        auto deint = new CMeshDeinterlacer!V_;
        auto vert = m.vertices;

        _vbo = new CBuffer;
    }
}


