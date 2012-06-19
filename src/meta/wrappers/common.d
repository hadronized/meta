module meta.wrappers.common;

/* imports */
private {
}
public {
    import meta.utils.runtime_error;
}

/* runtime error */
class wrapper_not_loaded : runtime_error {
    this(string wrapper, string reason) {
        super("failed to load the wrapper \'" ~ wrapper ~ "\'; reason: " ~ reason);
    }
}
