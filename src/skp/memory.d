/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta, a render framework
    Copyright (C) 2012 Dimitri 'skp' Sabadie <dimitri.sabadie@gmail.com> 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

module meta.utils.memory;

import skp.logger;

private void log_ctor_params_(uint I_, H_, P_...)(H_ h, P_ params) {
    logger.inst().deb("|\t%2d -> %5s : %8s", I_, h, typeof(h).stringof);
    static if (params.length)
        log_ctor_params_!(I+1)(params);
    else
        logger.inst().deb("| end of ctor params list");
}

private void log_ctor_(P_...)(P_ params) {
    static if (params.length) {
        logger.inst().deb("| ctor params list");
        log_ctor_params_!0u(params);
    }
}

/**
 * @brief Memory instanciation function
 *
 * This function is used to instanciate all meta objects.
 */
auto spawn(T_, P_...)(P_ params) {
    static if (is(T_ : Object)) {
        /* for class, we simply return a new object */
        logger.inst().deb("spawned a new %s (class)", T_.stringof);
        log_ctor_(params);
        return new T_(params);
    } else {
        /* for POD, like structs, we return a copy of it, and pray for the NRVO is enabled */
        logger.inst().deb("spawned a new %s (POD)", T_.stringof);
        log_ctor_(params);
        return T_(params);
    }
}
