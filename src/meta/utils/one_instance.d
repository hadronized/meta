module meta.utils.one_instance;

mixin template OneInstance(T) {
    static private bool _instancied = false;

    this() {
        assert ( !_instancied, T.stringof ~ " is already instancied!" );
        _instancied = true;
    }
}