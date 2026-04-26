# === Base directories ===
set(SRC_DIR     "${PROJECT_SOURCE_DIR}/src")
set(INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")
set(TEST_DIR    "${PROJECT_SOURCE_DIR}/test")

# === Source and headers ===
file(GLOB_RECURSE sources CONFIGURE_DEPENDS
    "${SRC_DIR}/*.c"
    "${SRC_DIR}/*.asm"
    "${SRC_DIR}/*.s"
)
# Mark all .asm files as NASM sources
foreach(asm_file IN LISTS sources)
    if(asm_file MATCHES "\\.asm$")
        set_source_files_properties(${asm_file} PROPERTIES LANGUAGE ASM_NASM)
    endif()
endforeach()

set(exe_sources ${sources})
list(FILTER sources EXCLUDE REGEX ".*/main\\.(c|asm|s)$")
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${INCLUDE_DIR}/*.h")


# === Test directories ===
file(GLOB TEST_DIRS LIST_DIRECTORIES true RELATIVE "${TEST_DIR}" "${TEST_DIR}/*")

set(test_dirs "")
foreach(entry IN LISTS TEST_DIRS)
    if(IS_DIRECTORY "${TEST_DIR}/${entry}")
        list(APPEND test_dirs "${TEST_DIR}/${entry}")
    endif()
endforeach()

file(GLOB_RECURSE test_helper_sources CONFIGURE_DEPENDS "${TEST_DIR}/*.c")
