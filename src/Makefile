INCLUDES= -I./import
DLDFLAGS= -L-lDerelictUtil -L-lDerelictGL3 -L-lDerelictGLFW3

all:
	dmd -w -debug test/mesh.d meta/utils/memory.d meta/utils/logger.d meta/models/mesh.d
	
gl:
	dmd -w -debug test/gl.d meta/utils/memory.d meta/utils/logger.d meta/utils/traits.d meta/utils/runtime_error.d meta/utils/math/vecs.d meta/views/core/opengl/gl.d -ofgltest $(DLDFLAGS) $(INCLUDES)
	
