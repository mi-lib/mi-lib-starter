# Search installed libxml2 include & library packages

# Search libxml2 include directory from directory name libxml2/
find_path(XML2_INCLUDE_DIR libxml2
  # Searching Target Path
  PATHS
    # # Environment Variable if exists
    # ENV XML2_ROOT
    # ENV XML2_INCLUDE_DIR
    # # CMake Variable if defines
    # ${XML2_ROOT}
    /usr
    /usr/local
  PATH_SUFFIXES
    include
  )
# Search library path from the library name
find_library(XML2_LIBRARY
  NAMES
    xml2
  PATHS
    # # Environment Variable if exists
    # ENV XML2_ROOT
    # ENV XML2_LIB_DIR
    # # CMake Variable if defines
    # ${XML2_ROOT}
    /usr
    /usr/local
  PATH_SUFFIXES
    lib
  )
# Hide above variables if not advanced mode
mark_as_advanced(XML2_INCLUDE_DIR XML2_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(xml2
  REQUIRED_VARS
    XML2_INCLUDE_DIR
    XML2_LIBRARY
  )

# if Found xml2 And if name "LibXml2" is not defined
if(XML2_FOUND AND NOT TARGET LibXml2)

  message(STATUS "XML2_FOUND AND NEW TARGET LibXml2 IS DEFINED.")
  message(STATUS "XML2_LIBRARY = ${XML2_LIBRARY}")
  message(STATUS "XML2_INCLUDE_DIR = ${XML2_INCLUDE_DIR}/libxml2")

  # Define libxml2 library with Target Name XML2::XML2
  # UNKNOWN means the library which is not decided which STATIC or SHARED
  # IMPORTED means the target which is not belong to this cmake project
  add_library(LibXml2 UNKNOWN IMPORTED)
  set_target_properties(LibXml2 PROPERTIES
    # "C" is C language, "CXX" is C++
    IMPORTED_LINK_INTERFACE_LANGUAGES "C"
    IMPORTED_LOCATION ${XML2_LIBRARY}
    INTERFACE_INCLUDE_DIRECTORIES ${XML2_INCLUDE_DIR}/libxml2
  )

  set(LIBXML2_INCLUDE_DIRECTORY
    ${XML2_INCLUDE_DIR}/libxml2
  )

else()

  message(STATUS "XML2_NOT_FOUND OR TARGET LibXml2 IS ALREADY DEFINED,")

  # libxml2 setting
  set(LIBXML2_WITH_ICONV OFF)
  set(LIBXML2_WITH_LZMA OFF)
  set(LIBXML2_WITH_PYTHON OFF)
  set(LIBXML2_WITH_ZLIB OFF)
  set(BUILD_SHARED_LIBS OFF)

  # source package
  # (LibXml2 is Defined at the libxml2/CMakeLists.txt)
  add_subdirectory(${PROJECT_SOURCE_DIR}/libxml2)

  set(LIBXML2_INCLUDE_DIRECTORY
    ${XML2_INCLUDE_DIR}/libxml2/include
  )

endif()
