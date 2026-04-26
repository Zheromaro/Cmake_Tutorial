cmake_minimum_required(VERSION 3.15)

# ==========================================================
# 🧩 Project details
# ==========================================================
project(
  ${CMAKE_PROJECT_NAME}Tests
  LANGUAGES CXX
)

# ==========================================================
# ⚙️  Compiler Settings
# ==========================================================
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

verbose_message("🧪 Adding tests under ${CMAKE_PROJECT_NAME}Tests...")

# ==========================================================
# 📁 Iterate over test directories
# ==========================================================
message(STATUS "")
foreach(dir ${test_dirs})
  if(NOT EXISTS ${dir})
    message(WARNING "⚠️  Test directory not found: ${dir}")
    continue()
  endif()

  # Get all source files
  file(GLOB dir_sources CONFIGURE_DEPENDS "${dir}/*.cpp" "${dir}/*.c")

  if(dir_sources STREQUAL "")
    message(WARNING "⚠️  No .cpp or .c files found in ${dir}")
    continue()
  endif()

  # Extract the directory name to use as target name
  get_filename_component(dir_name ${dir} NAME)

  # ========================================================
  # 🧱 Build test executable
  # ========================================================
  add_executable(${dir_name}_Test ${dir_sources} ${test_helper_sources})
  target_compile_features(${dir_name}_Test PUBLIC cxx_std_17)
  target_include_directories( ${dir_name}_Test PUBLIC ${test_dirs})

  # ========================================================
  # 🔗 Link with main project & GTest
  # ========================================================
  if(${CMAKE_PROJECT_NAME}_BUILD_EXECUTABLE)
    set(${CMAKE_PROJECT_NAME}_TEST_LIB ${CMAKE_PROJECT_NAME}_LIB)
  else()
    set(${CMAKE_PROJECT_NAME}_TEST_LIB ${CMAKE_PROJECT_NAME})
  endif()

  if(${CMAKE_PROJECT_NAME}_USE_GTEST)
    find_package(GTest REQUIRED)

    # Optionally include Google Mock
    set(GTEST_LIBS GTest::GTest GTest::Main)
    if(${CMAKE_PROJECT_NAME}_USE_GOOGLE_MOCK)
      list(APPEND GTEST_LIBS GTest::gmock GTest::gmock_main)
    endif()

    target_link_libraries(
      ${dir_name}_Test
      PRIVATE
        ${GTEST_LIBS}
        ${${CMAKE_PROJECT_NAME}_TEST_LIB}
    )
  else()
    message(FATAL_ERROR "❌ Unknown testing library. Please enable GTest with `${CMAKE_PROJECT_NAME}_USE_GTEST=ON`.")
  endif()

  # ========================================================
  # 🧪 Register with CTest
  # ========================================================
  add_test(
    NAME ${dir_name}
    COMMAND ${dir_name}_Test
  )

  message(STATUS "✅ Added test: ${dir_name}_Test")
endforeach()

verbose_message("🏁 Finished adding unit tests for ${CMAKE_PROJECT_NAME}.")
