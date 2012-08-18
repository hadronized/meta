module meta.render.adaptors.shader;

interface IShader {
    void compile(string src);
}

interface IShaderProgram {
    void attach(S_...)(IShader s, S_ others);
    void detach(S_...)(IShader s, S_ others);
    void link();
}    
