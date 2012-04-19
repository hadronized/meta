module meta.utils.memory;

import meta.utils.logger;

void log_ctor_params(uint I, H, P...)(H h, P params) {
    logger.inst().deb("|\t%2d -> %5s : %8s", I, h, typeof(h).stringof);
    static if (params.length)
        log_ctor_params!(I+1)(params);
    else
        logger.inst().deb("| end of ctor params list");
}

void log_ctor(P...)(P params) {
    static if (params.length) {
        logger.inst().deb("| ctor params list");
        log_ctor_params!0u(params);
    }
}

/**
 * @brief Memory instanciation function
 *
 * This function is used to instanciate all meta objects.
 */
auto spawn(T, P...)(P params) {
    static if (is(T : Object)) {
        /* for class, we simply return a new object */
        logger.inst().deb("spawned a new %s (class)", T.stringof);
        log_ctor(params);
        return new T(params);
    } else {
        /* for POD, like structs, we return a copy of it, and pray for the NRVO is enabled */
        logger.inst().deb("spawned a new %s (POD)", T.stringof);
        log_ctor(params);
        return T(params);
    }
}