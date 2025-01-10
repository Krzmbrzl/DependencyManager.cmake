#[[[
# Utility function to verify the arguments parsed via cmake_parse_arguments
#
# This included automatic checking that there have not been any unparsed (i.e. unrecognized) arguments
# as well as the ability to check that required arguments are actually present.
#
# **Keyword arguments**
#
# :keyword ACCEPT_UNRECOGNIZED: Don't error if there are unparsed (unrecognized) arguments
# :type ACCEPT_UNRECOGNIZED: option
# :param PREFIX: The prefix used in the cmake_parse_arguments call
# :type PREFIX: string
# :keyword FUNCTION_NAME: Name of the function whose arguments shall be verified
# :type FUNCTION_NAME: string
# :keyword REQUIRED_PARAMS: List of parameter names that are mandatory
# :type REQUIRED_PARAMS: list of strings
#]]
function (__dep_man_do_verify_parsed_arguments)
  set(FLAGS "ACCEPT_UNRECOGNIZED")
  set(ONE_VAL_OPTIONS "PREFIX" "FUNCTION_NAME")
  set(MULTI_VAL_OPTIONS "REQUIRED_PARAMS")
  cmake_parse_arguments(
    verify_args
    "${FLAGS}"
    "${ONE_VAL_OPTIONS}"
    "${MULTI_VAL_OPTIONS}"
    ${ARGV}
  )

  # First, verify own arguments
  if (DEFINED verify_args_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} - Received unrecognized options: ${verify_args_UNPARSED_ARGUMENTS}")
  endif ()
  if (DEFINED verify_args_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} - The following options are missing argumens: ${verify_args_KEYWORDS_MISSING_VALUES}")
  endif ()
  if (NOT
      DEFINED
      verify_args_PREFIX
  )
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} - Missing required option 'PREFIX'")
  endif ()
  if (NOT
      DEFINED
      verify_args_FUNCTION_NAME
  )
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} - Missing required option 'FUNCTION_NAME'")
  endif ()

  # Now start the function's actual job: Verifying a top-level function's call to cmake_parse_arguments
  if (NOT verify_args_ACCEPT_UNRECOGNIZED AND DEFINED ${verify_args_PREFIX}_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "${verify_args_FUNCTION_NAME} - Received unrecognized options: ${${VERIFY_PARSED_ARGS_PREFIX}_UNPARSED_ARGUMENTS}")
  endif ()
  if (DEFINED ${verify_args_PREFIX}_KEYWORDS_MISSING_VALUES)
    message(
      FATAL_ERROR
        "${verify_args_FUNCTION_NAME} - The following options are missing arguments: ${${VERIFY_PARSED_ARGS_PREFIX}_KEYWORDS_MISSING_VALUES}"
    )
  endif ()

  if (DEFINED verify_args_REQUIRED_PARAMS)
	  foreach (CURRENT_ARG IN LISTS verify_args_REQUIRED_PARAMS)
      set(CURRENT_ARG "${verify_args_PREFIX}_${CURRENT_ARG}")
      if (NOT
          DEFINED
          ${CURRENT_ARG}
      )
        message(FATAL_ERROR "${verify_args_FUNCTION_NAME} - Missing required option '${CURRENT_ARG}'")
      endif ()
    endforeach ()
  endif ()
endfunction ()

#[[[
# Helper macro to call __dep_man_do_verify_parsed_arguments with FUNCTION_NAME set to
# the current function's name.
#]]
macro (__dep_man_verify_parsed_arguments)
  __dep_man_do_verify_parsed_arguments(FUNCTION_NAME "${CMAKE_CURRENT_FUNCTION}" ${ARGV})
endmacro ()
