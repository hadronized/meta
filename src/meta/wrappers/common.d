module meta.wrappers.common;

/* imports */
private {
}
public {
    import skp.runtime_error;
}

/* runtime error */
class CWrapperNotLoaded : CRuntimeError {
    this(string wrapper, string reason) {
        super("failed to load the wrapper \'" ~ wrapper ~ "\'; reason: " ~ reason);
    }
}
