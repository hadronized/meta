import meta.views.core.opengl.gl;
import meta.utils.logger;
import meta.utils.memory;
import meta.utils.traits;
import meta.utils.math.vecs;

int main() {
    logger.inst().info("Hello, world!");

    auto w = spawn!(window!(3,2))(800, 600, false, "meta framework");
    auto dev = spawn!device;
    auto vs = spawn!shader(shader_type.VERTEX);
    auto fs = spawn!shader(shader_type.FRAGMENT);
    auto ps = spawn!shader_program;

    vs.compile("
#version 150

void main() {
}");
    fs.compile("
#version 150

void main() {
}");
    ps.attach(vs, fs);
    ps.link();

    logger.inst().info("gl type of %s is %s", float.stringof, GLTypeOf!float);

    dev.set_clear_color( color(1, 0, 0, 1) );
    while (w.state(SK_ESC) == KS_RELEASED) {
        dev.clear(buffer_bit.COLOR);
        w.swap_buffers();
        w.fetch_events();
    }

    static if (Compatible!(vec2, "array"))
        logger.inst().info("compatible");
    else
        logger.inst().warning("not compatible");

    return 0;
}