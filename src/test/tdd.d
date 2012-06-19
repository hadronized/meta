module meta.test.tdd;

/* In this module, we can find all the interface wanted to be working in the final
   meta framework. */


/* the entry point of the demo has to pass through the run logic */
class run : run_logic {
    override void init() {
        /* all the sublogics has to be instantied here */
        install_logic(new foo_logic1);
        install_logic(new foo_logic2);
    }
}
        

void main(string[] args) {
    /* then the run logic is just used as bellow */
    auto app = new run(args);
    app.init();
    
    return app.run();
}

/* the first thing we are about to wanna do is to create the first logic of the
   demo, for instance, the pre_logic, which loads all needed resources, and draws
   a little splashscreen meanwhile; to do that, let's create a new logic */
class pre_logic : composite_logic {
    /* what is a composite_logic ? it's just a logic that is able to run other
       ones */
    override void init() {
        /* load the splashscreen resources */
    }

    override void run() {
        /* load all the demo resources, drawing the state of the loading as a
           splashscreen clip intro */
        /* run all the installed logic; only available for composite_logic */
        super.run();
    }
}

/* then, we want for instance the first demo module as a terminal logic */
class mod1_logic : logic {
    /* let's image we want to draw a simple sphere with a raytracer fragment
       shader program */
    /* first, we need the pipeline that already supports this kind of stuf */
    per_frag_op _pfo; /* per fragment operation pipeline */
    /* then, we need a sphere structure */
    struct sphere {
        vec4 center;
        float radius;
        color diffuse;
        color specular;
    }
    /* finally, we need a sphere program interface */
    class sphere_gpu_swapper {
        /* uniforms and so on */
        void map_from(shader_program sp) {
            /* map all uniforms from the shader program */
        }
    }

    override void init() {
        auto fs = new shader(FRAGMENT);
        /* load the shader sources, compile, link */

        _pfo = new per_frag_op(fs);

        /* get the shader program in order to map sphere uniforms */
        auto sp = _pfo.program;

    }

    override void run() {

    }
}
