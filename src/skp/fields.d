module skp.fields;

mixin template MTFields(F_...) {
    static if (F_.length && !(F_.length & 1)) {
        static assert ( is(typeof(F_[1]) : string), "the type must be string or string-castable" );

        mixin("F_[0] " ~ F_[1] ~ ";");
        mixin MTFields!(F_[2 .. F_.length]);

        alias F_ fields_list;
    }   
}
