import meta.views.core.opengl.gl;
import meta.utils.logger;
import meta.utils.memory;

int main() {
    logger.inst().info("Hello, world!");

    auto w = spawn!(window!(3,2))(800, 600, false, "meta framework");
    auto dev = spawn!device;
    auto vs = spawn!shader(shader_type.VERTEX);

    dev.set_clear_color( color(1, 0, 0, 1) );
    while (w.state(SK_ESC) == KS_RELEASED) {
        dev.clear(buffer_bit.COLOR);
        w.swap_buffers();
        w.fetch_events();
    }

    return 0;
}