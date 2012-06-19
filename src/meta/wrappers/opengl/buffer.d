module meta.wrappers.opengl.buffer;

/* TODO: we have to change a few things here, such as create a new scope class to
   handle the type of a buffer, and make buffers moar general */

/* imports */
private {
	import meta.wrappers.opengl.common;
}
public {
}


enum buffer_type {
	NONE          ,
	ARRAY         = GL_ARRAY_BUFFER,
	ELEMENT_ARRAY = GL_ELEMENT_ARRAY_BUFFER,
	TFB           = GL_TRANSFORM_FEEDBACK_BUFFER,
	UNIFORM       = GL_UNIFORM_BUFFER
}

enum buffer_usage {
	STREAM_DRAW  = GL_STREAM_DRAW,
	STATIC_DRAW  = GL_STATIC_DRAW,
	DYNAMIC_DRAW = GL_DYNAMIC_DRAW,
	DYNAMIC_COPY = GL_DYNAMIC_COPY
}

enum buffer_access {
	READ       = GL_READ_ONLY,
	WRITE      = GL_WRITE_ONLY,
	READ_WRITE = GL_READ_WRITE
}

class buffer {
	mixin GLObject!uint;

	private int _type;
	private uint _size;

	this() {
		glGenBuffers(1, &_id);
		assert ( _id );
		fetch_error("this()");
		_type = buffer_type.NONE;
		_size = 0;
	}

	~this() {
		glDeleteBuffers(1, &_id);
	}

	uint size() const @property {
		return _size;
	}

	void use(buffer_type type) {
		glBindBuffer(_type = type, _id);
		fetch_error("use()");
	}

	void done() {
		glBindBuffer(_type, 0);
		_type = buffer_type.NONE;
	}

	void commit(uint size, void *data, buffer_usage usage) {
		try {
			glBufferData(_type, _size = size, data, usage);
			fetch_error("commit()");
		} catch (globject_error e) {
			_size = 0;
			throw e;
		}
	}

	void update(int offset, uint size, void *data) {
		glBufferSubData(_type, offset, size, data);
		fetch_error("update");
	}

	void * map(buffer_access a) {
		auto mapped = glMapBuffer(_type, a);
		fetch_error("map()");
		return mapped;
	}

	void * map(int offset, uint length, buffer_access a) {
		auto mapped = glMapBufferRange(_type, offset, length, a);
		fetch_error("map() range");
		return mapped;
	}

	bool unmap() {
		auto r = glUnmapBuffer(_type);
		fetch_error("unnap()");
		return r == GL_TRUE;
	}
}

