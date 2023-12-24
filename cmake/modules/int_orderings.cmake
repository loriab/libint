# handle the setting of the following variables
# * LIBINT_SHGSHELL_ORDERING*
# * LIBINT_CGSHELL_ORDERING*
# * LIBINT_SHELL_SET*


# <<<  solid harmonic Gaussian orderings  >>>

set(LIBINT_SHGSHELL_ORDERING_STANDARD 1)
set(LIBINT_SHGSHELL_ORDERING_GAUSSIAN 2)

string(TOLOWER "${LIBINT2_SHGAUSS_ORDERING}" LIBINT2_SHGAUSS_ORDERING_lower)

if (LIBINT2_SHGAUSS_ORDERING_lower STREQUAL "standard")
    set(LIBINT_SHGSHELL_ORDERING ${LIBINT_SHGSHELL_ORDERING_STANDARD})
elseif (LIBINT2_SHGAUSS_ORDERING_lower STREQUAL "gaussian")
    set(LIBINT_SHGSHELL_ORDERING ${LIBINT_SHGSHELL_ORDERING_GAUSSIAN})
else()
    message(FATAL_ERROR "Invalid value for LIBINT2_SHGAUSS_ORDERING (${LIBINT2_SHGAUSS_ORDERING})")
endif()


# <<<  Cartesian Gaussian orderings  >>>

set(LIBINT_CGSHELL_ORDERING_STANDARD 1)
set(LIBINT_CGSHELL_ORDERING_INTV3 2)
set(LIBINT_CGSHELL_ORDERING_GAMESS 3)
set(LIBINT_CGSHELL_ORDERING_ORCA 4)
set(LIBINT_CGSHELL_ORDERING_BAGEL 5)

string(TOLOWER "${LIBINT2_CARTGAUSS_ORDERING}" LIBINT2_CARTGAUSS_ORDERING_lower)

if (LIBINT2_CARTGAUSS_ORDERING_lower STREQUAL "standard")
    set(LIBINT_CGSHELL_ORDERING ${LIBINT_CGSHELL_ORDERING_STANDARD})
elseif (LIBINT2_CARTGAUSS_ORDERING_lower STREQUAL "intv3")
    set(LIBINT_CGSHELL_ORDERING ${LIBINT_CGSHELL_ORDERING_INTV3})
elseif (LIBINT2_CARTGAUSS_ORDERING_lower STREQUAL "gamess")
    set(LIBINT_CGSHELL_ORDERING ${LIBINT_CGSHELL_ORDERING_GAMESS})
elseif (LIBINT2_CARTGAUSS_ORDERING_lower STREQUAL "orca")
    set(LIBINT_CGSHELL_ORDERING ${LIBINT_CGSHELL_ORDERING_ORCA})
elseif (LIBINT2_CARTGAUSS_ORDERING_lower STREQUAL "bagel")
    set(LIBINT_CGSHELL_ORDERING ${LIBINT_CGSHELL_ORDERING_BAGEL})
else()
    message(FATAL_ERROR "Invalid value for LIBINT2_CARTGAUSS_ORDERING (${LIBINT2_CARTGAUSS_ORDERING})")
endif()


# <<<  shell subset orderings  >>>

set(LIBINT_SHELL_SET_STANDARD 1)
set(LIBINT_SHELL_SET_ORCA 2)

string(TOLOWER "${LIBINT2_SHELL_SET}" LIBINT2_SHELL_SET_lower)

if (LIBINT2_SHELL_SET_lower STREQUAL "standard")
    set(LIBINT_SHELL_SET ${LIBINT_SHELL_SET_STANDARD})
elseif (LIBINT2_SHELL_SET_lower STREQUAL "orca")
    set(LIBINT_SHELL_SET ${LIBINT_SHELL_SET_ORCA})
else()
    message(FATAL_ERROR "Invalid value for LIBINT2_SHELL_SET (${LIBINT2_SHELL_SET})")
endif()