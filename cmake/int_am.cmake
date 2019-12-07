# handle the defaulting and setting of the following variables
# * ENABLE_[ONEBODY|ERI|ERI2|ERI3|G12|G12DKH]
# * [LIBINT|ONEBODY|ERI|ERI2|ERI3|G12|G12DKH]_[MAX|OPT]_AM[|_LIST]
# * LIBINT_ONEBODY_DERIV
# * LIBINT_SUPPORTS_ONEBODY

# _candidate variables not needed for config.h but are used to figure
#   out the energy/gradient/hessian ERI AM levels at the CMake level
#   so that Libint2Config components may be defined and client codes can
#   require the detected library include gradient integrals up to AM=5 with
#   `find_package(Libint2 COMPONENTS G5)`


message(STATUS "Processing integrals classes ...")

# <<<  overall defaults (LIBINT_MAX/OPT_AM)  >>>

list(LENGTH WITH_MAX_AM _lam)
if (_lam GREATER 1)
    list(GET WITH_MAX_AM 0 _candidate0_E)
    list(GET WITH_MAX_AM 1 _candidate0_G)
    if (_lam GREATER 2)
        list(GET WITH_MAX_AM 2 _candidate0_H)
    else()
        set(_candidate0_H "-1")
    endif()

    list(JOIN WITH_MAX_AM "," _sam)
    execute_process (COMMAND bash -c "echo ${_sam} | tr , '\n' | sort -n | tail -n1"
                     OUTPUT_VARIABLE _max_LIBINT_MAX_AM)

    set(LIBINT_MAX_AM_LIST ${_sam})
    set(LIBINT_MAX_AM "")
else()
    set(_candidate0_E ${WITH_MAX_AM})
    set(_candidate0_G "-1")
    set(_candidate0_H "-1")

    set(LIBINT_MAX_AM_LIST "")
    set(LIBINT_MAX_AM ${WITH_MAX_AM})
    set(_max_LIBINT_MAX_AM ${LIBINT_MAX_AM})

    if (LIBINT_MAX_AM GREATER_EQUAL 8)
        message(FATAL "Value for LIBINT_MAX_AM too high (${LIBINT_MAX_AM}). Are you sure you know what you are doing?")
    elseif (LIBINT_MAX_AM LESS_EQUAL 0)
        message(FATAL "Invalid value for LIBINT_MAX_AM (${LIBINT_MAX_AM}).")
    endif()
endif()

list(LENGTH WITH_OPT_AM _lam)
if (_lam GREATER 1)
    list(JOIN WITH_OPT_AM "," _sam)
    execute_process (COMMAND bash -c "echo ${_sam} | tr , '\n' | sort -n | tail -n1"
                     OUTPUT_VARIABLE _max_LIBINT_OPT_AM)
    set(LIBINT_OPT_AM_LIST ${_sam})
    set(LIBINT_OPT_AM "")
else()
    set(LIBINT_OPT_AM_LIST "")
    if (WITH_OPT_AM EQUAL -1)
        math(EXPR LIBINT_OPT_AM "${_max_LIBINT_MAX_AM}/2 + 1")
        #math(EXPR LIBINT_OPT_AM "${_max_LIBINT_MAX_AM}/2 + ${_max_LIBINT_MAX_AM}%2")
    else()
        set(LIBINT_OPT_AM ${WITH_OPT_AM})
    endif()

    if (LIBINT_OPT_AM GREATER _max_LIBINT_MAX_AM)
        message(FATAL "Invalid value for LIBINT_OPT_AM (${LIBINT_OPT_AM} !<= ${_max_LIBINT_MAX_AM}).")
    endif()
endif()


# <<<  Macro  >>>

macro(process_integrals_class class)
    if (ENABLE_${class} GREATER_EQUAL 0)
        set(INCLUDE_${class} ${ENABLE_${class}})
        if (${class} STREQUAL ONEBODY)
            set(LIBINT_SUPPORTS_${class} yes)
            set(LIBINT_${class}_DERIV ${INCLUDE_${class}})
        endif()
        message(STATUS "Enabling integrals class ${class} to derivative ${INCLUDE_${class}}")
    else()
        set(INCLUDE_${class} "-1")
        set(${class}_MAX_AM "")
        set(${class}_MAX_AM_LIST "")
        message(STATUS "Disabling integrals class ${class}")
    endif()
    
    if (ENABLE_${class} GREATER_EQUAL 0)
        list(LENGTH WITH_${class}_MAX_AM _lam)
        if (_lam GREATER 1)
            if (${class} STREQUAL ERI)
                list(GET WITH_${class}_MAX_AM 0 _candidate_E)
                if (${INCLUDE_${class}} GREATER_EQUAL 1)
                    list(GET WITH_${class}_MAX_AM 1 _candidate_G)
                endif()
                if ((${INCLUDE_${class}} GREATER_EQUAL 1) AND (_lam GREATER 2))
                    list(GET WITH_${class}_MAX_AM 2 _candidate_H)
                endif()
            endif()

            list(JOIN WITH_${class}_MAX_AM "," _sam)
            execute_process (COMMAND bash -c "echo ${_sam} | tr , '\n' | sort -n | tail -n1"
                             OUTPUT_VARIABLE _max_${class}_MAX_AM)
            set(${class}_MAX_AM_LIST ${_sam})
            set(${class}_MAX_AM "")
        else()
            set(${class}_MAX_AM_LIST "")
            if (WITH_${class}_MAX_AM EQUAL -1)

                if (${class} STREQUAL ERI)
                    set(_candidate_E ${_candidate0_E})
                    if (${INCLUDE_${class}} GREATER_EQUAL 1)
                        if (${_candidate0_G} EQUAL -1)
                            set(_candidate_G ${_candidate0_E})
                        else()
                            set(_candidate_G ${_candidate0_G})
                        endif()
                    endif()
                    if (${INCLUDE_${class}} GREATER_EQUAL 2)
                        if (${_candidate0_H} EQUAL -1)
                            set(_candidate_H ${_candidate0_E})
                        else()
                            set(_candidate_H ${_candidate0_H})
                        endif()
                    endif()
                endif()

                set(${class}_MAX_AM "")
                set(_max_${class}_MAX_AM ${LIBINT_MAX_AM})
            else()
                # _max_* variable in case want to default opt_am from it some day
                set(${class}_MAX_AM ${WITH_${class}_MAX_AM})
                set(_max_${class}_MAX_AM ${${class}_MAX_AM})

                if (${class} STREQUAL ERI)
                    set(_candidate_E ${${class}_MAX_AM})
                    if (${INCLUDE_${class}} GREATER_EQUAL 1)
                        set(_candidate_G ${${class}_MAX_AM})
                    endif()
                    if (${INCLUDE_${class}} GREATER_EQUAL 2)
                        set(_candidate_H ${${class}_MAX_AM})
                    endif()
                endif()

                if (${class}_MAX_AM GREATER_EQUAL 8)
                    message(FATAL "Value for ${class}_MAX_AM too high (${${class}_MAX_AM}). Are you sure you know what you are doing?")
                elseif (${class}_MAX_AM LESS_EQUAL 0)
                    message(FATAL "Invalid value for ${class}_MAX_AM (${${class}_MAX_AM}).")
                endif()
            endif()
        endif()
        message(STATUS "Enabling integrals class ${class} to max AM ${${class}_MAX_AM}${${class}_MAX_AM_LIST} (else ${LIBINT_MAX_AM}${LIBINT_MAX_AM_LIST})")
    
        list(LENGTH WITH_${class}_OPT_AM _lam)
        if (_lam GREATER 1)
            list(JOIN WITH_${class}_OPT_AM "," _sam)
            execute_process (COMMAND bash -c "echo ${_sam} | tr , '\n' | sort -n | tail -n1"
                             OUTPUT_VARIABLE _max_${class}_OPT_AM)
            set(${class}_OPT_AM_LIST ${_sam})
            set(${class}_OPT_AM "")
        else()
            set(${class}_OPT_AM_LIST "")
            if (WITH_${class}_OPT_AM EQUAL -1)
                set(${class}_OPT_AM "")
            else()
                set(${class}_OPT_AM ${WITH_${class}_OPT_AM})

                if (${class}_OPT_AM GREATER _max_${class}_MAX_AM)
                    message(FATAL "Invalid value for ${class}_OPT_AM (${${class}_OPT_AM} !<= ${_max_${class}_MAX_AM}).")
                endif()
            endif()
    
        endif()
        message(STATUS "Enabling integrals class ${class} to opt AM ${${class}_OPT_AM}${${class}_OPT_AM_LIST} (else ${LIBINT_OPT_AM}${LIBINT_OPT_AM_LIST})")
    endif()
endmacro()


process_integrals_class(ONEBODY)
process_integrals_class(ERI)
process_integrals_class(ERI3)
process_integrals_class(ERI2)

# discrepancy, as configure doesn't do AM_LIST for these
process_integrals_class(G12)
process_integrals_class(G12DKH)

# form list of active <deriv><max_am> strings to use in Libint2Config
set(Libint2_ERI_COMPONENTS "")
foreach(_i RANGE 2 ${_candidate_E})
    list(APPEND Libint2_ERI_COMPONENTS "e${_i}")
endforeach()
if (${INCLUDE_ERI} GREATER_EQUAL 1)
    foreach(_i RANGE 2 ${_candidate_G})
        list(APPEND Libint2_ERI_COMPONENTS "g${_i}")
    endforeach()
endif()
if (${INCLUDE_ERI} GREATER_EQUAL 2)
    foreach(_i RANGE 2 ${_candidate_H})
        list(APPEND Libint2_ERI_COMPONENTS "h${_i}")
    endforeach()
endif()
message(STATUS "Library will satisfy ERI AM components: ${Libint2_ERI_COMPONENTS}")

# TODO add components for non-eri ints: eri3 -or- eri3_2 for hess -or- eri3_h3 for hess AM=3
