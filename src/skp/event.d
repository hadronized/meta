module skp.event;

mixin template MTEventManager(L_) {
    private L_[] _listeners;

    void add_listener(L_ l) {
        ++_listeners.length;
        _listeners[$-1] = l;
    }

    void trigger(string E_, Args_...)(Args_ a) {
        mixin("
                foreach (l; _listeners) {
                    if (l." ~ E_ ~ "(a))
                        break;
                }
        ");
    }
}
