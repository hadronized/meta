module meta.render.drivers.opengl.mesh_renderer;

/* imports */
private {
    import meta.models.mesh;
    import meta.render.adaptors.mesh_renderer;
    import meta.utils.logger;
    import meta.wrappers.opengl.buffer;
}
public {
}


class mesh_renderer_gl : mesh_renderer {
    private {
        buffer _vbo;
    }

    this(V)(mesh!V m) in {
        assert ( m !is null );
    } body {
        _vbo = new buffer;


        logger.inst().info("testing attributes");
        /* TEST PURPOSE */
        foreach (a; m.tupleof) {
            logger.inst().deb("attribute of type %s (%d bytes), %d elements in the array", a.stringof, a.sizeof, a.length);
        }
    }
}


