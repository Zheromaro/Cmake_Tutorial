cmake_minimum_required(VERSION 3.15)

# ==========================================================
# 🧩 Project details
# ==========================================================
project(
  ARCHI
  VERSION 0.1.0
  LANGUAGES C ASM
)

message(STATUS "🚀 Starting configuration for ${PROJECT_NAME} v${PROJECT_VERSION}")

# ==========================================================
# ⚙️  Load custom project settings
# ==========================================================
include(cmake/StandardSettings.cmake)
include(cmake/Utils.cmake)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug")
endif()

# Define a cross-platform debug macro
add_compile_definitions($<$<CONFIG:Debug>:_DEBUG>)

# ==========================================================
# 🧰 Enable proper assembler handling (NASM)
# ==========================================================
if (WIN32)
    enable_language(ASM_MASM)
    message(STATUS "🧱 Using MASM assembler on Windows")

elseif(UNIX)
    # Enable NASM explicitly
    enable_language(ASM_NASM)
    set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

    # Optionally add NASM flags (e.g. debug symbols)
    set(CMAKE_ASM_NASM_FLAGS "${CMAKE_ASM_NASM_FLAGS} -g")

    message(STATUS "🧱 Using NASM assembler on UNIX/Linux (format: ${CMAKE_ASM_NASM_OBJECT_FORMAT})")
endif()


# ==========================================================
# 🚫 Prevent in-source builds
# ==========================================================
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "❌ In-source builds are not allowed! Please use a separate build directory.")
endif()

# ==========================================================
# 📦 Package Managers (Vcpkg)
# ==========================================================
include(cmake/Vcpkg.cmake)

# ==========================================================
# 📁 Source & Header Files
# ==========================================================
include(cmake/SourcesAndHeaders.cmake)
message(STATUS "📂 Found project sources and headers")

# ==========================================================
# 🧱 Build Mode Logic
# ==========================================================
if(${PROJECT_NAME}_BUILD_EXECUTABLE)
  message(STATUS "🏗️ Building as EXECUTABLE")
  add_executable(${PROJECT_NAME} ${exe_sources})
  set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE C)

elseif(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  message(STATUS "📜 Building as HEADER-ONLY library")
  add_library(${PROJECT_NAME} INTERFACE)

elseif(${PROJECT_NAME}_BUILD_SHARED)
  message(STATUS "🔗 Building as SHARED library (.so)")
  add_library(${PROJECT_NAME} SHARED ${headers} ${sources})

else()
  message(STATUS "📦 Building as STATIC library (.a)")
  add_library(${PROJECT_NAME} STATIC ${headers} ${sources})
endif()

if(${PROJECT_NAME}_VERBOSE_OUTPUT)
  verbose_message("Found the following headers:")
  foreach(header IN LISTS headers)
    verbose_message("* ${header}")
  endforeach()
endif()

# ==========================================================
# 🧾 Output directories
# ==========================================================
set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}"
)

if(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
  set_target_properties(
    ${PROJECT_NAME}_LIB
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    OUTPUT_NAME ${PROJECT_NAME}
  )
endif()

# ==========================================================
# 🔗 Dependencies
# ==========================================================
#find_package('Target' CONFIG REQUIRED)

# non vcpkg libraries
include(cmake/ExternalLib.cmake)

if(NOT ${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  target_link_libraries(${PROJECT_NAME}
    PRIVATE
        ${EXTERNAL_LIBS}
  )
  target_include_directories( ${PROJECT_NAME}
    PUBLIC 
        ${EXTERNAL_LIBS_INCLUDE}
  )
endif()

# ==========================================================
# 📚 Include Directories
# ==========================================================
if(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  target_include_directories(
    ${PROJECT_NAME}
    INTERFACE
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )
else()
  target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/src
  )
  # Allow usage of header files in the 'src' directory, but only for utilities
  if(${PROJECT_NAME}_BUILD_EXECUTABLE AND ${PROJECT_NAME}_ENABLE_UNIT_TESTING)
    target_include_directories(
      ${PROJECT_NAME}_LIB
      PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/src
    )
  endif()
endif()

message(STATUS "✅ Include directories configured.")

# ==========================================================
# 📦 Installation Rules
# ==========================================================
install(
  TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(
  DIRECTORY include/${PROJECT_NAME_LOWERCASE}
  DESTINATION include
)

verbose_message("Install targets successfully built. Install with `cmake --build <build_directory> --target install --config <build_config>`.")

message(STATUS "📦 Installation setup complete.")

# ==========================================================
# 🧪 Unit Testing
# ==========================================================
if(${PROJECT_NAME}_ENABLE_UNIT_TESTING)
  enable_testing()
  message(STATUS "🧪 Unit testing ENABLED — looking for tests in /test/")
  add_subdirectory(test)
endif()

# ==========================================================
# 🧠 Build Summary
# ==========================================================
message(STATUS "")
message(STATUS "====== ${PROJECT_NAME} Configuration Summary ======")
message(STATUS "🔧 Build type:            ${CMAKE_BUILD_TYPE}")
message(STATUS "⚙️  Executable:            ${${PROJECT_NAME}_BUILD_EXECUTABLE}")
message(STATUS "📜 Headers-only:          ${${PROJECT_NAME}_BUILD_HEADERS_ONLY}")
message(STATUS "🔗 Shared library:        ${${PROJECT_NAME}_BUILD_SHARED}")
message(STATUS "🧪 Unit testing enabled:  ${${PROJECT_NAME}_ENABLE_UNIT_TESTING}")
message(STATUS "📦 Install prefix:        ${CMAKE_INSTALL_PREFIX}")
message(STATUS "=====================================================")
message(STATUS "")