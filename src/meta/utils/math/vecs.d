module meta.utils.math.vecs;

/* TODO: add common and useful math op */
struct vec(uint D, T) if (D >= 2 && D <= 4) {
    /* components */
    public {
        T x;
        T y;

        static if (D > 2)
            T z;
        static if (D > 3)
            T w;
    }

    this(P...)(P params) if (params.length <= D) {
        ctor_!0u(params);
    }

    /* This method recursively builds the vec */
    /* TODO: add conversion with slicable object */
    private void ctor_(uint I, H, R...)(H head, R remaining) if (I <= D) {
        static if (is(H : T)) {
            /* we can directly set the corresponding component */
            *(&x+I) = head;
            /* and go to the next component */
            ctor_!(I+1)(remaining);
        } else {
            static assert (0, "cannot assign " ~ H.stringof ~ " to " ~ T.stringof);
        }
    }

    /* terminal version of the ctor_ template method */
    private void ctor_(uint I)() {
    }
}