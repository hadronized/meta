module meta.utils.event;


mixin template EventManager(L) {
	private L[] _listeners;

	void add_listener(L l) {
		++_listeners.length;
		_listeners[$-1] = l;
	}

	void trigger(string event, Args...)(Args a) {
		mixin("
				foreach (l; _listeners) {
					if (l." ~ event ~ "(a))
					    break;
				}
		");
	}
}
