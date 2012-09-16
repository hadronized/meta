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

module meta.wrappers.devil.image;

/* imports */
private {
    import std.string : toStringz;
    import meta.wrappers.devil.common;
    import meta.wrappers.opengl.texture : texture_format_t;
}
public {
}

class CImage {
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

        texture_format_t format() const {
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
