module meta.wrappers.opengl.buffer;

/* imports */
private {
	import meta.wrappers.opengl.common;
}
public {
}


enum buffer_type {
	ARRAY         = GL_ARRAY_BUFFER,
	ELEMENT_ARRAY = GL_ELEMENT_ARRAY_BUFFER,
	UNIFORM       = GL_UNIFORM_BUFFER
}

enum buffer_usage {
	STREAM_DRAW  = GL_STREAM_DRAW,
	STATIC_DRAW  = GL_STATIC_DRAW,
	DYNAMIC_DRAW = GL_DYNAMIC_DRAW
}

enum buffer_access {
	READ       = GL_READ_ONLY,
	WRITE      = GL_WRITE_ONLY,
	READ_WRITE = GL_READ_WRITE
}

class buffer {
	mixin GLObject!uint;

	immutable buffer_type type;
	
	private uint _size;

	this(buffer_type type) {
		glGenBuffers(1, &_id);
		fetch_error("this()");
		this.type = type;
		_size = 0;
	}

	~this() {
		glDeleteBuffers(1, &_id);
	}

	void use() {
		glBindBuffer(this.type, _id);
		fetch_error("use()");
	}

	void done() const {
		glBindBuffer(type, 0);
	}

	void commit(uint size, void *data, buffer_usage usage) {
		try {
			glBufferData(type, _size = size, data, usage);
			fetch_error("commit()");
		} catch (globject_error e) {
			_size = 0;
			throw e;
		}
	}

	void update(int offset, uint size, void *data) {
		glBufferSubData(type, offset, size, data);
		fetch_error("update");
	}

	void * map(buffer_access a) {
		auto mapped = glMapBuffer(type, a);
		fetch_error("map()");
		return mapped;
	}

	void * map(int offset, uint length, buffer_access a) {
		auto mapped = glMapBufferRange(type, offset, length, a);
		fetch_error("map() range");
		return mapped;
	}

	bool unmap() {
		auto r = glUnmapBuffer(type);
		fetch_error("unnap()");
		return r == GL_TRUE;
	}
}

