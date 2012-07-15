module meta.render.adaptors.shader;


interface shader {
    void compile(string src);
}


interface shader_program {
    void attach(S...)(shader s, S others);
    void detach(S...)(shader s, S others);
    void link();
}    
