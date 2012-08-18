module skp.logics.composite_logic;

/* imports */
private {
    import skp.logics.logic;
}
public {
}

abstract class ACompositeLogic : ILogic {
    protected ILogic[] _logics;

    void install_logic(ILogic l) {
        ++_logics.length;
        _logics[$-1] = l;
    }

    override void run() {
        foreach (l; _logics)
            l.run();
    }
}
