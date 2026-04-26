if(${PROJECT_NAME}_ENABLE_VCPKG)
  set(VCPKG_CMAKE_PATH "${CMAKE_BINARY_DIR}/vcpkg.cmake")

  if(NOT EXISTS "${VCPKG_CMAKE_PATH}")
    message(STATUS "🌐 Downloading vcpkg.cmake...")
    file(DOWNLOAD
      "https://github.com/microsoft/vcpkg/raw/master/scripts/buildsystems/vcpkg.cmake"
      "${VCPKG_CMAKE_PATH}"
      STATUS DOWNLOAD_STATUS
    )
    list(GET DOWNLOAD_STATUS 0 STATUS_CODE)
    if(NOT STATUS_CODE EQUAL 0)
      message(WARNING "⚠️ Failed to download vcpkg.cmake! Continuing without Vcpkg integration.")
      return()
    endif()
    message(STATUS "✅ Vcpkg toolchain downloaded successfully.")
  endif()

  if(${PROJECT_NAME}_VERBOSE_OUTPUT)
		set(VCPKG_VERBOSE ON)
	endif()
  set(CMAKE_TOOLCHAIN_FILE "${VCPKG_CMAKE_PATH}" CACHE STRING "Vcpkg toolchain" FORCE)
endif()
