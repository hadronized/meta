module meta.utils.runtime_error;

import std.exception;

/* I have no idea what I'm doing :D */
class runtime_error : Error {
    this(string msg) {
        super("meta runtime error: " ~ msg);
    }
}