module meta.logics.composite_logic;

/* imports */
private {
    import meta.logics.logic;
}
public {
}


abstract class composite_logic : logic {
    protected logic[] _logics;

    void install_logic(logic l) {
        ++_logics.length;
        _logics[$-1] = l;
    }

    override void run() {
        foreach (l; _logics)
            l.run();
    }
}
