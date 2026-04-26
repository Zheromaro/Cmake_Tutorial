cmake_minimum_required(VERSION 3.22)


# ---this is to give the project a name
project(HELLOAPP)


# --- creat a varibale 
set(SRC_FILE 
    main.c
    src/calc.c)


# --- (MODE or flag "the message")
message(WARNING "SRC FILE has ${SRC_FILE}")


# --- add a cmake in this cmake (path)
add_subdirectory(${CMAKE_SOURCE_DIR}/lib)


# --- (1st executable file name, 2nd source code)
add_executable(hellobinary ${SRC_FILE})


# --- for the code 
# make it like the files in include are in the same folder as main.c
target_include_directories(hellobinary PUBLIC include/ lib/)
# make code in lib accessible without being in SRC_FILE
target_link_libraries(hellobinary PUBLIC wifi_lib)


# --- 
if() #look in doc
elseif() 
else() 
endif()