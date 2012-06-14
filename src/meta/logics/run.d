module meta.logics.run;

/* imports */
private {
	import meta.logics.composite_logic;
	import meta.utils.logger;
	import meta.wrappers.glfw.window;
}
public {
}


class run_logic : composite_logic {
	private bool _run;
	private window _window;

	this(window w) {
		assert ( w !is null );
		_run = false;
		_window = w;
	}

	bool ran() @property const {
		return _run;
	}

	void end() {
		_run = false;
		logger.inst().deb("ending the application...");
	}

	override final void run() {
		_run = true;
		logger.inst().deb("running the application");
		while (_run) {
			/* TODO: eventually manage FPS here */
			super.run();

			_window.swap_buffers();
			_window.fetch_events();
			if (_window.state(SK_ESC) == KS_PRESSED)
				end();
		}
	}
}

