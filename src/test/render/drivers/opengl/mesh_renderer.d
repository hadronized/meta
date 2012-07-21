import meta.models.mesh;
import meta.render.drivers.opengl.mesh_renderer;
import meta.utils.logger;
import meta.wrappers.glfw.common;

/* use the default vertex class */
alias mesh!default_vertex our_mesh;

int main() {
    auto m = new our_mesh;
    auto renderer = new mesh_renderer_gl(m);

    logger.inst().info("Hello there!");
    return 0;
}
