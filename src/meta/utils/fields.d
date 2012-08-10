module meta.utils.fields;

mixin template Fields(F...) {
    static if (F.length && !(F.length & 1)) {
        static assert ( is(typeof(F[1]) : string), "the type must be string or string-castable" );

        mixin("F[0] " ~ F[1] ~ ";");
        mixin Fields!(F[2 .. F.length]);
    }   
}
