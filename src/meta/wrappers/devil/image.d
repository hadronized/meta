module meta.wrappers.devil.image;

/* imports */
private {
    import std.string : toStringz;
    import meta.wrappers.devil.common;
    import meta.wrappers.opengl.texture : texture_format;
}
public {
}


class image {
    private {
        ILuint _;
        ILuint _w;
        ILuint _h;
        ILint _format;
        ILuint _bpp;
        ILubyte *_data;
    }

    @property {
        uint width() const {
            return _w;
        }

        uint height() const {
            return _;    
        }

        texture_format format() const {
            return _format;    
        }

        uint bpp() const {
            return _bpp;
        }

        const(ubyte) * data() const {
            return _data;    
        }
    }

    this() {
        ilGenImages(1, &_);
    }

    ~this() {
        //ilDeleteImages(1, &_); /* TODO: uncommenting that line produces a segfault by the D GC */
    }

    void bind() {
        ilBindImage(_);
    }

    void from_disk(string file) {
        bind();
        ilLoadImage(toStringz(file));
        _w = ilGetInteger(IL_IMAGE_WIDTH);
        _h = ilGetInteger(IL_IMAGE_HEIGHT);
        _format = ilGetInteger(IL_IMAGE_FORMAT);
        _bpp = ilGetInteger(IL_IMAGE_BYTES_PER_PIXEL);
        _data = ilGetData();
    }
}
