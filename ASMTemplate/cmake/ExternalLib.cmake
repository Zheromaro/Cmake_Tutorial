# Base libs directory
set(EXTERNAL_LIBS_DIR "${PROJECT_SOURCE_DIR}/libs")

# Collect all .a and .so files under libs/*
file(GLOB_RECURSE EXTERNAL_LIBS
    CONFIGURE_DEPENDS
    "${EXTERNAL_LIBS_DIR}/**/*.a"
    "${EXTERNAL_LIBS_DIR}/**/*.so"
)

# Collect include directories under libs/*
file(GLOB EXTERNAL_LIBS_SUBDIRS LIST_DIRECTORIES true "${EXTERNAL_LIBS_DIR}/*")

set(EXTERNAL_LIBS_INCLUDE "")

foreach(entry IN LISTS EXTERNAL_LIBS_SUBDIRS)
    # Check if this subdirectory has an 'include' folder with headers
    if(IS_DIRECTORY "${entry}/include")
        list(APPEND EXTERNAL_LIBS_INCLUDE "${entry}/include")
    endif()
endforeach()

list(REMOVE_DUPLICATES EXTERNAL_LIBS_INCLUDE)
