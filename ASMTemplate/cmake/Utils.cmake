# Print a message only if the `VERBOSE_OUTPUT` option is on
function(verbose_message content)
    if(DEFINED ${PROJECT_NAME}_VERBOSE_OUTPUT AND ${PROJECT_NAME}_VERBOSE_OUTPUT)
        message("\033[1;36m[VERBOSE]\033[0m ${content}")
    endif()
endfunction()
