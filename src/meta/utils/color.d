module meta.utils.color;

import meta.utils.math.vecs;

struct color {
    private vec4 _v;
    alias _v this;

    @property inout auto opDispatch(string name, A...)(A args)
    if (name == "r") {
        return v.x;
    }
}
    