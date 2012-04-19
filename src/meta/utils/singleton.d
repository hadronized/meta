module meta.utils.singleton;

mixin template Singleton(T) {
    static private T _inst;

    protected this() {
        _inst = null;
    }

    public static T inst() {
        return _inst ? _inst : (_inst = new T);
    }
} /* Singleton template */
