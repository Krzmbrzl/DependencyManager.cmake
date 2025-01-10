set(DEPENDENCY_MANAGER_LOG_VERBOSITY
    "WARNING"
    CACHE "The verbosity of the dependency manager's logging. Can be one of \"DEBUG\", \"STATUS\", \"WARNING\""
)

function (__dep_man_serverity_to_int SEVERITY OUTPUT_VARIABLE)
  string(TOUPPER "${SEVERITY}" SEVERITY)

  if (SEVERITY STREQUAL "DEBUG")
    set(numeric 0)
  elseif (SEVERITY STREQUAL "STATUS")
    set(numeric 1)
  elseif (SEVERITY STREQUAL "WARNING")
    set(numeric 2)
  else ()
    message(FATAL_ERROR "Unrecognized logging severity '${SEVERITY}' in ${CMAKE_CURRENT_FUNCTION}")
  endif ()

  set(${OUTPUT_VARIABLE}
      "${numeric}"
      PARENT_SCOPE
  )
endfunction ()

#[[[
# Logs the given message, provided the severity is equal to or higher than what is configured in the DEPENDENCY_MANAGER_LOG_VERBOSITY option
#
# :param SEVERITY: The severity of the message
# :type SEVERITY: string
# :param MSG: The message
# :type MSG: string
#]]
function (__dep_man_log SEVERITY MSG)
  __dep_man_serverity_to_int(${DEPENDENCY_MANAGER_LOG_VERBOSITY} min_severity)
  __dep_man_serverity_to_int(${SEVERITY} current_severity)

  if (current_severity GREATER_EQUAL min_severity)
    message("DependencyManager: ${MSG}")
  endif ()
endfunction ()
