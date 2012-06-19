module meta.utils.runtime_error;

import std.exception;

class runtime_error : Exception {
    this(string msg) {
        super("meta runtime error: " ~ msg);
    }
}
