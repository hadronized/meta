import meta.views.core.opengl.gl;
import meta.utils.logger;

int main() {
    logger.inst().info("Hello, world!");

    auto glcontext = new context!(3, 2);
    glcontext.create(800, 600, false, "meta framework");

    return 0;
}