module skp.runtime_error;

import std.exception;

class CRuntimeError : Exception {
    this(string msg) {
        super("meta runtime error: " ~ msg);
    }
}
