cmake_minimum_required(VERSION 3.22)

project(HELLOAPP)

set(SRC_FILE 
    main.c
    src/calc.c)
    
message(WARNING "SRC FILE has ${SRC_FILE}")

add_subdirectory(${CMAKE_SOURCE_DIR}/lib)

add_executable(hellobinary ${SRC_FILE})

target_include_directories(hellobinary PUBLIC include/ lib/)
target_link_libraries(hellobinary PUBLIC wifi_lib)

install(FILES "${PROJECT_BINARY_DIR}/hellobinary"
    DESTINATION "${PROJECT_BINARY_DIR}/executable")