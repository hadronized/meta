INCLUDES= -I./import
DLDFLAGS= -L-lDerelictUtil -L-lDerelictGL3 -L-lDerelictGLFW3
OUT= gl.bin

all: gl
	
gl:
	dmd -w -debug test/gl.d meta/utils/memory.d meta/utils/logger.d meta/utils/traits.d meta/utils/color.d meta/utils/runtime_error.d meta/utils/math/vecs.d meta/views/core/opengl/common.d meta/views/core/opengl/glfw.d meta/views/core/opengl/gl.d -of$(OUT) $(DLDFLAGS) $(INCLUDES)

clean:
	@rm -rf *.o $(OUT)
	
