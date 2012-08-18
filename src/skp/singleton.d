module skp.singleton;

mixin template MTSingleton(T_) {
    static private T_ _inst;

    protected this() {
        _inst = null;
    }

    public static T_ inst() {
        return _inst ? _inst : (_inst = new T_);
    }
}
