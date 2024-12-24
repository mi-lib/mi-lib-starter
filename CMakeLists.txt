#
cmake_minimum_required (VERSION 3.16)

project ("mi-lib-starter" LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (MSVC)
  message("BUILD_TARGET_OS is windows")
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
  unset(CMAKE_C_FLAGS)
  unset(CMAKE_C_FLAGS_DEBUG)
  unset(CMAKE_C_FLAGS_RELEASE)
  unset(CMAKE_CXX_FLAGS)
  unset(CMAKE_CXX_FLAGS_DEBUG)
  unset(CMAKE_CXX_FLAGS_RELEASE)

  set(CLANG_CL_PATH "$ENV{VCINSTALLDIR}Tools/Llvm/x64/bin/clang-cl.exe")
  string(REPLACE "\\" "/" CLANG_CL_PATH ${CLANG_CL_PATH})

  # set(CMAKE_C_COMPILER ${CLANG_CL_PATH})
  # set(CMAKE_CXX_COMPILER ${CLANG_CL_PATH})
endif()

set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/build/bin")
set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/build/lib")
set(PROJECT_BINARY_DIR "${PROJECT_SOURCE_DIR}/build/bin")
set(CMAKE_BINARY_DIR "${PROJECT_SOURCE_DIR}/build/bin")

# Switch build type
if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "" FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# add cmakes path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmakes)

# libxml2 ----------------------------------------------------------------------

find_package(LibXml2 REQUIRED)
# include(cmakes/FindLibXml2.cmake)


if(TARGET LibXml2)
  message(STATUS "target LibXml2 is found.")
  message(STATUS "LIBXML2_INCLUDE_DIRECTORY = ${LIBXML2_INCLUDE_DIRECTORY}")
else()
  message(FATAL_ERROR "target LibXml2 is not found.")
  message(STATUS "LIBXML2_INCLUDE_DIRECTORY = ${LIBXML2_INCLUDE_DIRECTORY}")
  return()
endif()


# mi-lib ----------------------------------------------------------------------

add_compile_definitions(__BUILD_DLL__ true)


# zeda ----------------------------------------------------------------------

file(GLOB ZEDA_SOURCES
  zeda/src/?*.c
)

set_source_files_properties(${ZEDA_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ZEDA_HEADERS
  zeda/include/zeda/?*.h
)

set_source_files_properties(${ZEDA_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(zeda SHARED
  ${ZEDA_SOURCES}
  # ${ZEDA_HEADERS}
)

target_precompile_headers(zeda PUBLIC ${ZEDA_HEADERS})

target_compile_definitions(zeda PRIVATE __ZEDA_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(zeda PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZEDA_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(zeda PUBLIC ${ZEDA_INCLUDE_DIR})

add_dependencies(zeda LibXml2)

target_link_libraries(zeda LibXml2)

if (NOT MSVC)
  find_library(MATH_LIBRARY m)
  target_link_libraries(zeda ${MATH_LIBRARY})
endif()

add_compile_definitions(__ZEDA_USE_LIBXML true)


# zeda test ----------------------------------------------------------------------

set(ZEDA_TEST_LINK_LIB
  zeda
  LibXml2
)

set(ZEDA_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/test"
)

file(GLOB ZEDA_TEST_SOURCES
  zeda/test/?*.c
)
set_source_files_properties(${ZEDA_TEST_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( array_test
  zeda/test/array_test.c
)
target_include_directories( array_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( array_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( binfile_test
  zeda/test/binfile_test.c
)
target_include_directories( binfile_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( binfile_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( binfile_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( bit_test
  zeda/test/bit_test.c
)
target_include_directories( bit_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( bit_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( bit_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( defs_test
  zeda/test/defs_test.c
)
target_include_directories( defs_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( defs_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( defs_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( heap_test
  zeda/test/heap_test.c
)
target_include_directories( heap_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( heap_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( heap_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( index_test
 zeda/test/index_test.c
)
target_include_directories( index_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( index_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( index_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( list_test
 zeda/test/list_test.c
)
target_include_directories( list_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( list_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( zeda_misc_test
  zeda/test/misc_test.c
)
target_include_directories( zeda_misc_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( zeda_misc_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( zeda_misc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( name_test
  zeda/test/name_test.c
)
target_include_directories( name_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( name_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( name_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( option_test
  zeda/test/option_test.c
)
target_include_directories( option_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( option_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( option_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( rand_test_zeda
  zeda/test/rand_test.c
)
target_include_directories( rand_test_zeda PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( rand_test_zeda PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( rand_test_zeda PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( ring_test
  zeda/test/ring_test.c
)
target_include_directories( ring_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ring_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( ring_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( rrtab_test
  zeda/test/rrtab_test.c
)
target_include_directories( rrtab_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( rrtab_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( rrtab_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( string_test
  zeda/test/string_test.c
)
target_include_directories( string_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( string_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( string_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_custom_command(TARGET string_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeda/test/string_num_test.txt
  ${PROJECT_SOURCE_DIR}/zeda/test/string_test.txt
  ${PROJECT_SOURCE_DIR}/zeda/test/string_ws_test.txt
  $<TARGET_FILE_DIR:string_test>/
)

add_executable( strlist_test
  zeda/test/strlist_test.c
)
target_include_directories( strlist_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( strlist_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( strlist_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)


# zeda example ----------------------------------------------------------------------

set(ZEDA_EXAMPLE_LINK_LIB
  zeda
  LibXml2
)

set(ZEDA_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example"
)

file(GLOB_RECURSE ZEDA_EXAMPLE_SOURCES
  zeda/example/?*.c
)
# message(STATUS "ZEDA_EXAMPLE_SOURCES=${ZEDA_EXAMPLE_SOURCES}")
set_source_files_properties(${ZEDA_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )

set(ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/array"
)

add_executable( array_quicksort_test
  zeda/example/array/array_quicksort_test.c
)
target_include_directories( array_quicksort_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_quicksort_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( array_quicksort_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_CSV_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/csv"
)

add_executable( csv_test
  zeda/example/csv/csv_test.c
)
target_include_directories( csv_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( csv_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( csv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_CSV_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_LIST_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/list"
)

add_executable( list_append_test
  zeda/example/list/list_append_test.c
)
target_include_directories( list_append_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_append_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_append_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_dup_test
  zeda/example/list/list_dup_test.c
)
target_include_directories( list_dup_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_dup_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_dup_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_purge_test
  zeda/example/list/list_purge_test.c
)
target_include_directories( list_purge_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_purge_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_purge_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_quicksort_test
  zeda/example/list/list_quicksort_test.c
)
target_include_directories( list_quicksort_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_quicksort_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_quicksort_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_swap_test
  zeda/example/list/list_swap_test.c
)
target_include_directories( list_swap_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_swap_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_swap_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_MISC_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/misc"
)

add_executable( alloc_test
  zeda/example/misc/alloc_test.c
)
target_include_directories( alloc_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( alloc_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( alloc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( echo_test
  zeda/example/misc/echo_test.c
)
target_include_directories( echo_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( echo_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( echo_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_MISC_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_OPTION_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/option"
)

add_executable( option_test_example
  zeda/example/option/option_test.c
)
target_include_directories( option_test_example PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( option_test_example PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( option_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_OPTION_OUTPUT_DIR}
)

set(ZEDA_EXAMPLE_RAND_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/rand"
)

add_executable( randf_test
  zeda/example/rand/randf_test.c
)
target_include_directories( randf_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( randf_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( randf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( randi_test
  zeda/example/rand/randi_test.c
)
target_include_directories( randi_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( randi_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( randi_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_RAND_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_STRING_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/string"
)

add_executable( read_int_test
  zeda/example/string/read_int_test.c
)
target_include_directories( read_int_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( read_int_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( read_int_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_STRING_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_ZTK_OUTPUT_DIR
  "${ZEDA_EXAMPLE_OUTPUT_DIR}/ztk"
)

add_executable( ztk_count_test
  zeda/example/ztk/ztk_count_test.c
)
target_include_directories( ztk_count_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztk_count_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_count_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ZTK_OUTPUT_DIR}
)

add_custom_command(TARGET ztk_count_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeda/example/ztk/calcurator.ztk
  ${PROJECT_SOURCE_DIR}/zeda/example/ztk/counttest.ztk
  ${PROJECT_SOURCE_DIR}/zeda/example/ztk/test1.ztk
  ${PROJECT_SOURCE_DIR}/zeda/example/ztk/test2.ztk
  ${PROJECT_SOURCE_DIR}/zeda/example/ztk/test3.ztk
  $<TARGET_FILE_DIR:ztk_count_test>/
)

add_executable( ztk_eval_test
  zeda/example/ztk/ztk_eval_test.c
)
target_include_directories( ztk_eval_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztk_eval_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_eval_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ZTK_OUTPUT_DIR}
)

add_executable( ztk_keysize_test
  zeda/example/ztk/ztk_keysize_test.c
)
target_include_directories( ztk_keysize_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztk_keysize_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_keysize_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ZTK_OUTPUT_DIR}
)

# zeda app ----------------------------------------------------------------

set(ZEDA_APP_LINK_LIB
  zeda
  LibXml2
)

set(ZEDA_APP_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/app"
)

file(GLOB ZEDA_APP_SOURCES
  zeda/app/?*.c
)
set_source_files_properties(${ZEDA_APP_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( ztkdump
  zeda/app/ztkdump.c
)
target_include_directories( ztkdump PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztkdump PUBLIC ${ZEDA_APP_LINK_LIB} )
set_target_properties( ztkdump PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_APP_OUTPUT_DIR}
)



# zm ----------------------------------------------------------------------

file(GLOB ZM_SOURCES
  zm/src/?*.c
)

set_source_files_properties(${ZM_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ZM_HEADERS
  zm/include/zm/?*.h
)

set_source_files_properties(${ZM_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(zm SHARED
  ${ZM_SOURCES}
  # ${ZM_HEADERS}
)

target_precompile_headers(zm PUBLIC ${ZM_HEADERS})

target_compile_definitions(zm PRIVATE __ZM_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(zm PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZM_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(zm PUBLIC ${ZM_INCLUDE_DIR})

add_dependencies(zm zeda LibXml2)

target_link_libraries(zm PUBLIC zeda LibXml2)


# zm test ----------------------------------------------------------------------

set(ZM_TEST_LINK_LIB
  zm
  zeda
  LibXml2
)

set(ZM_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zm/test"
)

file(GLOB ZM_TEST_SOURCES
  zm/test/?*.c
)
set_source_files_properties(${ZM_TEST_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( complex_test
  zm/test/complex_test.c
)
target_include_directories( complex_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( complex_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( complex_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( cvec_test
  zm/test/cvec_test.c
)
target_include_directories( cvec_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( cvec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( cvec_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( data_test
  zm/test/data_test.c
)
target_include_directories( data_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( data_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( data_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( dijkstra_test
  zm/test/dijkstra_test.c
)
target_include_directories( dijkstra_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( dijkstra_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( dijkstra_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( ieee_test
  zm/test/ieee_test.c
)
target_include_directories( ieee_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( ieee_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( ieee_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( le_test
  zm/test/le_test.c
)
target_include_directories( le_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( le_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( le_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( mat_test
  zm/test/mat_test.c
)
target_include_directories( mat_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( mat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( mat_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( zm_misc_test
  zm/test/misc_test.c
)
target_include_directories( zm_misc_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_misc_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( zm_misc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( pex_test
  zm/test/pex_test.c
)
target_include_directories( pex_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( pex_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( pex_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( raw_mat_test
  zm/test/raw_mat_test.c
)
target_include_directories( raw_mat_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( raw_mat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( raw_mat_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( raw_vec_test
  zm/test/raw_vec_test.c
)
target_include_directories( raw_vec_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( raw_vec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( raw_vec_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( stat_test
  zm/test/stat_test.c
)
target_include_directories( stat_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( stat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( stat_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( vec_test
  zm/test/vec_test.c
)
target_include_directories( vec_test PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( vec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( vec_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)


# zm app ----------------------------------------------------------------------

set(ZM_APP_LINK_LIB
  zm
  zeda
  LibXml2
)

set(ZM_APP_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zm/app"
)

file(GLOB ZM_APP_SOURCES
  zm/app/?*.c
)
set_source_files_properties(${ZM_APP_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( deg2rad
  zm/app/deg2rad.c
)
target_include_directories( deg2rad PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( deg2rad PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( deg2rad PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( rad2deg
  zm/app/rad2deg.c
)
target_include_directories( rad2deg PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( rad2deg PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( rad2deg PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_ave
  zm/app/zm_ave.c
)
target_include_directories( zm_ave PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_ave PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_ave PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_kmeans
  zm/app/zm_kmeans.c
)
target_include_directories( zm_kmeans PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_kmeans PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_kmeans PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_le
  zm/app/zm_le.c
)
target_include_directories( zm_le PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_le PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_le PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_pexp
  zm/app/zm_pexp.c
)
target_include_directories( zm_pexp PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_pexp PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_pexp PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_psolve
  zm/app/zm_psolve.c
)
target_include_directories( zm_psolve PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_psolve PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_psolve PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_seqmod
  zm/app/zm_seqmod.c
)
target_include_directories( zm_seqmod PUBLIC ${ZM_INCLUDE_DIR})
target_link_libraries( zm_seqmod PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_seqmod PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)


# zm example ----------------------------------------------------------------------

set(ZM_EXAMPLE_LINK_LIB
  zm
  zeda
  LibXml2
)

set(ZM_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zm/example"
)

file(GLOB_RECURSE ZM_EXAMPLE_SOURCES
  zm/example/?*.c
)
# message(STATUS "ZM_EXAMPLE_SOURCES=${ZM_EXAMPLE_SOURCES}")
set_source_files_properties(${ZM_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )


set(ZM_EXAMPLE_COMPLEX_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/complex"
)

add_executable( complex_test_example
  zm/example/complex/complex_test.c
)
target_include_directories( complex_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( complex_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( complex_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_COMPLEX_OUTPUT_DIR}
)

add_executable( complex_ztk_test
  zm/example/complex/complex_ztk_test.c
)
target_include_directories( complex_ztk_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( complex_ztk_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( complex_ztk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_COMPLEX_OUTPUT_DIR}
)
add_custom_command(TARGET complex_ztk_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zm/example/complex/complex.ztk
  $<TARGET_FILE_DIR:complex_ztk_test>/
)

add_executable( realpow_test
  zm/example/complex/realpow_test.c
)
target_include_directories( realpow_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( realpow_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( realpow_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_COMPLEX_OUTPUT_DIR}
)


set(ZM_EXAMPLE_DATA_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/data"
)

add_executable( peak_test
  zm/example/data/peak_test.c
)
target_include_directories( peak_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( peak_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( peak_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_DATA_OUTPUT_DIR}
)

add_executable( ransac_test
  zm/example/data/ransac_test.c
)
target_include_directories( ransac_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ransac_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ransac_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_DATA_OUTPUT_DIR}
)

add_executable( sg_test
  zm/example/data/sg_test.c
)
target_include_directories( sg_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sg_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_DATA_OUTPUT_DIR}
)


set(ZM_EXAMPLE_EIG_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/eig"
)

add_executable( condnum_test
  zm/example/eig/condnum_test.c
)
target_include_directories( condnum_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( condnum_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( condnum_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( dqr_test
  zm/example/eig/dqr_test.c
)
target_include_directories( dqr_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( dqr_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( dqr_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( eigsys_test
  zm/example/eig/eigsys_test.c
)
target_include_directories( eigsys_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( eigsys_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( eigsys_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( eigsys_large_test
  zm/example/eig/eigsys_large_test.c
)
target_include_directories( eigsys_large_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( eigsys_large_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( eigsys_large_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( hessenberg_test
  zm/example/eig/hessenberg_test.c
)
target_include_directories( hessenberg_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( hessenberg_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( hessenberg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( jacobi_test_example
  zm/example/eig/jacobi_test.c
)
target_include_directories( jacobi_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( jacobi_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( jacobi_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( power_test
  zm/example/eig/power_test.c
)
target_include_directories( power_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( power_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( power_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( svd_large_test
  zm/example/eig/svd_large_test.c
)
target_include_directories( svd_large_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( svd_large_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( svd_large_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( svd_maxmin_test
  zm/example/eig/svd_maxmin_test.c
)
target_include_directories( svd_maxmin_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( svd_maxmin_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( svd_maxmin_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( svd_test
  zm/example/eig/svd_test.c
)
target_include_directories( svd_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( svd_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( svd_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)

add_executable( sym_eig_test
  zm/example/eig/sym_eig_test.c
)
target_include_directories( sym_eig_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sym_eig_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sym_eig_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_EIG_OUTPUT_DIR}
)


set(ZM_EXAMPLE_FOURIER_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/fourier"
)

add_executable( fourier_test
  zm/example/fourier/fourier_test.c
)
target_include_directories( fourier_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( fourier_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( fourier_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_FOURIER_OUTPUT_DIR}
)


set(ZM_EXAMPLE_GRAPH_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/graph"
)

add_executable( astar_inc_test
  zm/example/graph/astar_inc_test.c
)
target_include_directories( astar_inc_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( astar_inc_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( astar_inc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( astar_dijkstra_test
  zm/example/graph/astar_dijkstra_test.c
)
target_include_directories( astar_dijkstra_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( astar_dijkstra_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( astar_dijkstra_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( graph_test
  zm/example/graph/graph_test.c
)
target_include_directories( graph_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( graph_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( graph_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( rrt_test
  zm/example/graph/rrt_test.c
)
target_include_directories( rrt_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rrt_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rrt_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( rrt_connect_test
  zm/example/graph/rrt_connect_test.c
)
target_include_directories( rrt_connect_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rrt_connect_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rrt_connect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( rrt_escape_test
  zm/example/graph/rrt_escape_test.c
)
target_include_directories( rrt_escape_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rrt_escape_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rrt_escape_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)

add_executable( rrt_star_test
  zm/example/graph/rrt_star_test.c
)
target_include_directories( rrt_star_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rrt_star_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rrt_star_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_GRAPH_OUTPUT_DIR}
)


set(ZM_EXAMPLE_INTG_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/intg"
)
add_executable( cmp_test
  zm/example/intg/cmp_test.c
)
target_include_directories( cmp_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cmp_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cmp_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_INTG_OUTPUT_DIR}
)


set(ZM_EXAMPLE_IP_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/ip"
)

add_executable( clothoid_test
  zm/example/ip/clothoid_test.c
)
target_include_directories( clothoid_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( clothoid_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( clothoid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( ip_benchmark_test
  zm/example/ip/ip_benchmark_test.c
)
target_include_directories( ip_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ip_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ip_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( pex_test_example
  zm/example/ip/pex_test.c
)
target_include_directories( pex_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( pex_lsm_test
  zm/example/ip/pex_lsm_test.c
)
target_include_directories( pex_lsm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_lsm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_lsm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( pex_boundary_test
  zm/example/ip/pex_boundary_test.c
)
target_include_directories( pex_boundary_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_boundary_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_boundary_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( pex_boundary_lsm_test
  zm/example/ip/pex_boundary_lsm_test.c
)
target_include_directories( pex_boundary_lsm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_boundary_lsm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_boundary_lsm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)

add_executable( seg_test
  zm/example/ip/seg_test.c
)
target_include_directories( seg_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( seg_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( seg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_IP_OUTPUT_DIR}
)


set(ZM_EXAMPLE_LE_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/le"
)

add_executable( hotelling_test
  zm/example/le/hotelling_test.c
)
target_include_directories( hotelling_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( hotelling_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( hotelling_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_benchmark_test
  zm/example/le/le_benchmark_test.c
)
target_include_directories( le_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_gen_benchmark_test
  zm/example/le/le_gen_benchmark_test.c
)
target_include_directories( le_gen_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_gen_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_gen_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_mpnull_test
  zm/example/le/le_mpnull_test.c
)
target_include_directories( le_mpnull_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_mpnull_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_mpnull_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_nullspace_test
  zm/example/le/le_nullspace_test.c
)
target_include_directories( le_nullspace_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_nullspace_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_nullspace_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_ref_test
  zm/example/le/le_ref_test.c
)
target_include_directories( le_ref_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_ref_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_ref_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( le_sr_nullspace_test
  zm/example/le/le_sr_nullspace_test.c
)
target_include_directories( le_sr_nullspace_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( le_sr_nullspace_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( le_sr_nullspace_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( lyapnov_test
  zm/example/le/lyapnov_test.c
)
target_include_directories( lyapnov_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( lyapnov_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( lyapnov_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( mat_inv_test
  zm/example/le/mat_inv_test.c
)
target_include_directories( mat_inv_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mat_inv_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mat_inv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( matdecomp_benchmark_test
  zm/example/le/matdecomp_benchmark_test.c
)
target_include_directories( matdecomp_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( matdecomp_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( matdecomp_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( mpinv_test
  zm/example/le/mpinv_test.c
)
target_include_directories( mpinv_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mpinv_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mpinv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( mul_inv_test
  zm/example/le/mul_inv_test.c
)
target_include_directories( mul_inv_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mul_inv_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mul_inv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( sweep_out_test
  zm/example/le/sweep_out_test.c
)
target_include_directories( sweep_out_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sweep_out_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sweep_out_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)

add_executable( tridiagonal_test
  zm/example/le/tridiagonal_test.c
)
target_include_directories( tridiagonal_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( tridiagonal_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( tridiagonal_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_LE_OUTPUT_DIR}
)


set(ZM_EXAMPLE_MAT_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/mat"
)

add_executable( mat_img_test
  zm/example/mat/mat_img_test.c
)
target_include_directories( mat_img_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mat_img_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mat_img_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MAT_OUTPUT_DIR}
)

add_executable( mat_norm_test
  zm/example/mat/mat_norm_test.c
)
target_include_directories( mat_norm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mat_norm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mat_norm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MAT_OUTPUT_DIR}
)

add_executable( mat_reg_test
  zm/example/mat/mat_reg_test.c
)
target_include_directories( mat_reg_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mat_reg_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mat_reg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MAT_OUTPUT_DIR}
)


set(ZM_EXAMPLE_MCA_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/mca"
)

add_executable( cluster_gen_test
  zm/example/mca/cluster_gen_test.c
)
target_include_directories( cluster_gen_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cluster_gen_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cluster_gen_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( gmm_bic_test
  zm/example/mca/gmm_bic_test.c
)
target_include_directories( gmm_bic_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gmm_bic_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gmm_bic_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( gmm_lsm_test
  zm/example/mca/gmm_lsm_test.c
)
target_include_directories( gmm_lsm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gmm_lsm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gmm_lsm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( gng_test
  zm/example/mca/gng_test.c
)
target_include_directories( gng_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gng_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gng_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( kmeans_lsm_test
  zm/example/mca/kmeans_lsm_test.c
)
target_include_directories( kmeans_lsm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( kmeans_lsm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( kmeans_lsm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( kmeans_test
  zm/example/mca/kmeans_test.c
)
target_include_directories( kmeans_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( kmeans_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( kmeans_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( kmedoids_test
  zm/example/mca/kmedoids_test.c
)
target_include_directories( kmedoids_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( kmedoids_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( kmedoids_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( pca_test
  zm/example/mca/pca_test.c
)
target_include_directories( pca_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pca_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pca_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( rand_test
  zm/example/mca/rand_test.c
)
target_include_directories( rand_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rand_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rand_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( xmeans_bic_test
  zm/example/mca/xmeans_bic_test.c
)
target_include_directories( xmeans_bic_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( xmeans_bic_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( xmeans_bic_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)

add_executable( xmeans_test
  zm/example/mca/xmeans_test.c
)
target_include_directories( xmeans_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( xmeans_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( xmeans_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MCA_OUTPUT_DIR}
)


set(ZM_EXAMPLE_MISC_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/misc"
)

add_executable( ceil_test
  zm/example/misc/ceil_test.c
)
target_include_directories( ceil_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ceil_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ceil_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( cycloid_test
  zm/example/misc/cycloid_test.c
)
target_include_directories( cycloid_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cycloid_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cycloid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( line_test
  zm/example/misc/line_test.c
)
target_include_directories( line_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( line_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( line_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( sigmoid_test
  zm/example/misc/sigmoid_test.c
)
target_include_directories( sigmoid_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sigmoid_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sigmoid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( smoothstep_test
  zm/example/misc/smoothstep_test.c
)
target_include_directories( smoothstep_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( smoothstep_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( smoothstep_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_MISC_OUTPUT_DIR}
)


set(ZM_EXAMPLE_NLE_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/nle"
)

add_executable( dm_test
  zm/example/nle/dm_test.c
)
target_include_directories( dm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( dm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( dm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NLE_OUTPUT_DIR}
)

# add_executable( lm_test
#   zm/example/nle/lm_test.c
# )
# target_include_directories( lm_test PUBLIC ${ZM_INCLUDE_DIR} )
# target_link_libraries( lm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
# set_target_properties( lm_test PROPERTIES
#   LINKER_LANGUAGE CXX
# )

add_executable( single_test
  zm/example/nle/single_test.c
)
target_include_directories( single_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( single_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( single_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NLE_OUTPUT_DIR}
)

add_executable( ss_test
  zm/example/nle/ss_test.c
)
target_include_directories( ss_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ss_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ss_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NLE_OUTPUT_DIR}
)

add_executable( steffensen_test
  zm/example/nle/steffensen_test.c
)
target_include_directories( steffensen_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( steffensen_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( steffensen_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NLE_OUTPUT_DIR}
)


set(ZM_EXAMPLE_NURBS_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/nurbs"
)

add_executable( nurbs_circle_test
  zm/example/nurbs/nurbs_circle_test.c
)
target_include_directories( nurbs_circle_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( nurbs_circle_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_circle_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_diff_test
  zm/example/nurbs/nurbs_diff_test.c
)
target_include_directories( nurbs_diff_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( nurbs_diff_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_diff_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_nn_test
  zm/example/nurbs/nurbs_nn_test.c
)
target_include_directories( nurbs_nn_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( nurbs_nn_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_nn_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_test
  zm/example/nurbs/nurbs_test.c
)
target_include_directories( nurbs_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( nurbs_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_NURBS_OUTPUT_DIR}
)


set(ZM_EXAMPLE_ODE_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/ode"
)

add_executable( adams_test
  zm/example/ode/adams_test.c
)
target_include_directories( adams_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( adams_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( adams_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( beuler_test
  zm/example/ode/beuler_test.c
)
target_include_directories( beuler_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( beuler_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( beuler_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( cmp_test_example
  zm/example/ode/cmp_test.c
)
target_include_directories( cmp_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cmp_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cmp_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( cmp2_test
  zm/example/ode/cmp2_test.c
)
target_include_directories( cmp2_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cmp2_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cmp2_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( cmp_dc_test
  zm/example/ode/cmp_dc_test.c
)
target_include_directories( cmp_dc_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cmp_dc_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cmp_dc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( deferred_correction_test
  zm/example/ode/deferred_correction_test.c
)
target_include_directories( deferred_correction_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( deferred_correction_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( deferred_correction_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( dualpend_test
  zm/example/ode/dualpend_test.c
)
target_include_directories( dualpend_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( dualpend_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( dualpend_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)
add_custom_command(TARGET dualpend_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zm/example/ode/dualpend.conf
  $<TARGET_FILE_DIR:dualpend_test>/
)

add_executable( euler_test
  zm/example/ode/euler_test.c
)
target_include_directories( euler_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( euler_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( euler_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( gauss_test
  zm/example/ode/gauss_test.c
)
target_include_directories( gauss_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gauss_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gauss_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( gear_test
  zm/example/ode/gear_test.c
)
target_include_directories( gear_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gear_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gear_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( heun_test
  zm/example/ode/heun_test.c
)
target_include_directories( heun_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( heun_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( heun_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( ode2_leapfrog_test
  zm/example/ode/ode2_leapfrog_test.c
)
target_include_directories( ode2_leapfrog_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ode2_leapfrog_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ode2_leapfrog_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( ode2_regular_test
  zm/example/ode/ode2_regular_test.c
)
target_include_directories( ode2_regular_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ode2_regular_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ode2_regular_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( ode2_sympl_test
  zm/example/ode/ode2_sympl_test.c
)
target_include_directories( ode2_sympl_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( ode2_sympl_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( ode2_sympl_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( radau_test
  zm/example/ode/radau_test.c
)
target_include_directories( radau_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( radau_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( radau_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( rk4_test
  zm/example/ode/rk4_test.c
)
target_include_directories( rk4_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rk4_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rk4_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( rk5_test
  zm/example/ode/rk5_test.c
)
target_include_directories( rk5_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rk5_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rk5_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( rkf45_test
  zm/example/ode/rkf45_test.c
)
target_include_directories( rkf45_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rkf45_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rkf45_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( rkg_test
  zm/example/ode/rkg_test.c
)
target_include_directories( rkg_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rkg_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rkg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)

add_executable( tr_test
  zm/example/ode/tr_test.c
)
target_include_directories( tr_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( tr_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( tr_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_ODE_OUTPUT_DIR}
)


set(ZM_EXAMPLE_OPT_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/opt"
)

add_executable( dm_test_example
  zm/example/opt/dm_test.c
)
target_include_directories( dm_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( dm_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( dm_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( lcp_benchmark_test
  zm/example/opt/lcp_benchmark_test.c
)
target_include_directories( lcp_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( lcp_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( lcp_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( line_search_test
  zm/example/opt/line_search_test.c
)
target_include_directories( line_search_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( line_search_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( line_search_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( lp_benchmark_test
  zm/example/opt/lp_benchmark_test.c
)
target_include_directories( lp_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( lp_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( lp_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( lp_stdcnv_solve_test
  zm/example/opt/lp_stdcnv_solve_test.c
)
target_include_directories( lp_stdcnv_solve_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( lp_stdcnv_solve_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( lp_stdcnv_solve_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( lp_stdcnv_test
  zm/example/opt/lp_stdcnv_test.c
)
target_include_directories( lp_stdcnv_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( lp_stdcnv_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( lp_stdcnv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( opt_benchmark_test
  zm/example/opt/opt_benchmark_test.c
)
target_include_directories( opt_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( opt_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( opt_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( qp_benchmark_test
  zm/example/opt/qp_benchmark_test.c
)
target_include_directories( qp_benchmark_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( qp_benchmark_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( qp_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)

add_executable( qp_test
  zm/example/opt/qp_test.c
)
target_include_directories( qp_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( qp_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( qp_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OPT_OUTPUT_DIR}
)


set(ZM_EXAMPLE_OSCILLATOR_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/oscillator"
)

add_executable( kuramoto_test
  zm/example/oscillator/kuramoto_test.c
)
target_include_directories( kuramoto_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( kuramoto_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( kuramoto_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OSCILLATOR_OUTPUT_DIR}
)

add_executable( matsuoka_test
  zm/example/oscillator/matsuoka_test.c
)
target_include_directories( matsuoka_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( matsuoka_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( matsuoka_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OSCILLATOR_OUTPUT_DIR}
)

add_executable( vandelpol_test
  zm/example/oscillator/vandelpol_test.c
)
target_include_directories( vandelpol_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( vandelpol_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( vandelpol_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_OSCILLATOR_OUTPUT_DIR}
)


set(ZM_EXAMPLE_PARSE_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/parse"
)

add_executable( parse_test
  zm/example/parse/parse_test.c
)
target_include_directories( parse_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( parse_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( parse_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_PARSE_OUTPUT_DIR}
)


set(ZM_EXAMPLE_PEX_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/pex"
)

add_executable( pex_diff_test
  zm/example/pex/pex_diff_test.c
)
target_include_directories( pex_diff_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_diff_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_diff_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_PEX_OUTPUT_DIR}
)

add_executable( pex_io_test
  zm/example/pex/pex_io_test.c
)
target_include_directories( pex_io_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_io_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_io_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_PEX_OUTPUT_DIR}
)
add_custom_command(TARGET pex_io_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zm/example/pex/pex_test.dat
  $<TARGET_FILE_DIR:pex_io_test>/
)

add_executable( pex_modulo_test
  zm/example/pex/pex_modulo_test.c
)
target_include_directories( pex_modulo_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_modulo_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_modulo_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_PEX_OUTPUT_DIR}
)

add_executable( pex_out_test
  zm/example/pex/pex_out_test.c
)
target_include_directories( pex_out_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pex_out_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pex_out_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_PEX_OUTPUT_DIR}
)


set(ZM_EXAMPLE_RAND_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/rand"
)

add_executable( rand_beta_test
  zm/example/rand/beta_test.c
)
target_include_directories( rand_beta_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( rand_beta_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( rand_beta_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( binom2_test
  zm/example/rand/binom2_test.c
)
target_include_directories( binom2_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( binom2_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( binom2_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( binom_test
  zm/example/rand/binom_test.c
)
target_include_directories( binom_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( binom_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( binom_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( cauchy_test
  zm/example/rand/cauchy_test.c
)
target_include_directories( cauchy_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( cauchy_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( cauchy_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( chisqr_test
  zm/example/rand/chisqr_test.c
)
target_include_directories( chisqr_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( chisqr_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( chisqr_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( exp_test
  zm/example/rand/exp_test.c
)
target_include_directories( exp_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( exp_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( exp_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( f_test
  zm/example/rand/f_test.c
)
target_include_directories( f_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( f_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( f_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( gamma_test
  zm/example/rand/gamma_test.c
)
target_include_directories( gamma_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gamma_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gamma_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( geo_test
  zm/example/rand/geo_test.c
)
target_include_directories( geo_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( geo_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( geo_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( logistic_test
  zm/example/rand/logistic_test.c
)
target_include_directories( logistic_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( logistic_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( logistic_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( montecarlo_test
  zm/example/rand/montecarlo_test.c
)
target_include_directories( montecarlo_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( montecarlo_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( montecarlo_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( mt_test
  zm/example/rand/mt_test.c
)
target_include_directories( mt_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( mt_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( mt_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( nd_test
  zm/example/rand/nd_test.c
)
target_include_directories( nd_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( nd_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( nd_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( normal_test
  zm/example/rand/normal_test.c
)
target_include_directories( normal_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( normal_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( normal_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( poisson_test
  zm/example/rand/poisson_test.c
)
target_include_directories( poisson_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( poisson_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( poisson_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( power_test_example
  zm/example/rand/power_test.c
)
target_include_directories( power_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( power_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( power_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( t_test
  zm/example/rand/t_test.c
)
target_include_directories( t_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( t_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( t_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( tri_test
  zm/example/rand/tri_test.c
)
target_include_directories( tri_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( tri_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( tri_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( weibull_test
  zm/example/rand/weibull_test.c
)
target_include_directories( weibull_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( weibull_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( weibull_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_RAND_OUTPUT_DIR}
)


set(ZM_EXAMPLE_SEQ_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/seq"
)

add_executable( seq_add_test
  zm/example/seq/seq_add_test.c
)
target_include_directories( seq_add_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( seq_add_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( seq_add_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SEQ_OUTPUT_DIR}
)

add_executable( seq_del_test
  zm/example/seq/seq_del_test.c
)
target_include_directories( seq_del_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( seq_del_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( seq_del_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SEQ_OUTPUT_DIR}
)

add_executable( seq_jump_test
  zm/example/seq/seq_jump_test.c
)
target_include_directories( seq_jump_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( seq_jump_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( seq_jump_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SEQ_OUTPUT_DIR}
)
add_custom_command(TARGET seq_jump_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zm/example/seq/test.zvs
  $<TARGET_FILE_DIR:seq_jump_test>/
)


set(ZM_EXAMPLE_SF_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/sf"
)

add_executable( bessel_i_test
  zm/example/sf/bessel_i_test.c
)
target_include_directories( bessel_i_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( bessel_i_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( bessel_i_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( bessel_j_test
  zm/example/sf/bessel_j_test.c
)
target_include_directories( bessel_j_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( bessel_j_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( bessel_j_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( bessel_k_test
  zm/example/sf/bessel_k_test.c
)
target_include_directories( bessel_k_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( bessel_k_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( bessel_k_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( bessel_y_test_example
  zm/example/sf/bessel_y_test.c
)
target_include_directories( bessel_y_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( bessel_y_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( bessel_y_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( sf_beta_test
  zm/example/sf/beta_test.c
)
target_include_directories( sf_beta_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sf_beta_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sf_beta_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( erf_test
  zm/example/sf/erf_test.c
)
target_include_directories( erf_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( erf_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( erf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( fresnel_gen_test
  zm/example/sf/fresnel_gen_test.c
)
target_include_directories( fresnel_gen_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( fresnel_gen_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( fresnel_gen_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( fresnel_test
  zm/example/sf/fresnel_test.c
)
target_include_directories( fresnel_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( fresnel_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( fresnel_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)

add_executable( gamma_test_example
  zm/example/sf/gamma_test.c
)
target_include_directories( gamma_test_example PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( gamma_test_example PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( gamma_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_SF_OUTPUT_DIR}
)


set(ZM_EXAMPLE_STAT_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/stat"
)

add_executable( combi_measure_test
  zm/example/stat/combi_measure_test.c
)
target_include_directories( combi_measure_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( combi_measure_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( combi_measure_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( distrib_test
  zm/example/stat/distrib_test.c
)
target_include_directories( distrib_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( distrib_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( distrib_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( max_min_test
  zm/example/stat/max_min_test.c
)
target_include_directories( max_min_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( max_min_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( max_min_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( normaldistrib_test
  zm/example/stat/normaldistrib_test.c
)
target_include_directories( normaldistrib_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( normaldistrib_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( normaldistrib_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( pascal_test
  zm/example/stat/pascal_test.c
)
target_include_directories( pascal_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( pascal_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( pascal_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( perm_test
  zm/example/stat/perm_test.c
)
target_include_directories( perm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( perm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( perm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)

add_executable( sum_test
  zm/example/stat/sum_test.c
)
target_include_directories( sum_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( sum_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( sum_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_STAT_OUTPUT_DIR}
)


set(ZM_EXAMPLE_VEC_OUTPUT_DIR
  "${ZM_EXAMPLE_OUTPUT_DIR}/vec"
)

add_executable( tree_test
  zm/example/vec/tree_test.c
)
target_include_directories( tree_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( tree_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( tree_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_VEC_OUTPUT_DIR}
)

add_executable( vec_norm_test
  zm/example/vec/vec_norm_test.c
)
target_include_directories( vec_norm_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( vec_norm_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( vec_norm_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_VEC_OUTPUT_DIR}
)

add_executable( vec_ring_cat_test
  zm/example/vec/vec_ring_cat_test.c
)
target_include_directories( vec_ring_cat_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( vec_ring_cat_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( vec_ring_cat_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_VEC_OUTPUT_DIR}
)

add_executable( vec_sort_test
  zm/example/vec/vec_sort_test.c
)
target_include_directories( vec_sort_test PUBLIC ${ZM_INCLUDE_DIR} )
target_link_libraries( vec_sort_test PUBLIC ${ZM_EXAMPLE_LINK_LIB} )
set_target_properties( vec_sort_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZM_EXAMPLE_VEC_OUTPUT_DIR}
)


# neuz ----------------------------------------------------------------------

file(GLOB NEUZ_SOURCES
  neuz/src/neuz_activator.c
  neuz/src/neuz_neuron.c
)

set_source_files_properties(${NEUZ_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB NEUZ_HEADERS
  neuz/include/neuz/?*.h
)

set_source_files_properties(${NEUZ_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(neuz SHARED
  ${NEUZ_SOURCES}
  # ${NEUZ_HEADERS}
)

target_precompile_headers(neuz PUBLIC ${NEUZ_HEADERS})

target_compile_definitions(neuz PRIVATE __NEUZ_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(neuz PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(NEUZ_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/neuz/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(neuz PUBLIC ${NEUZ_INCLUDE_DIR})

add_dependencies(neuz zm zeda LibXml2)

target_link_libraries(neuz PUBLIC zm zeda LibXml2 )

# neuz example ----------------------------------------------------------------------

set(NEUZ_EXAMPLE_LINK_LIB
  neuz
  zm
  zeda
  LibXml2
)

set(NEUZ_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/neuz/example"
)

file(GLOB_RECURSE NEUZ_EXAMPLE_SOURCES
  neuz/example/?*.c
)
# message(STATUS "NEUZ_EXAMPLE_SOURCES=${NEUZ_EXAMPLE_SOURCES}")
set_source_files_properties(${NEUZ_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )


add_executable( activator_test
  neuz/example/activator_test.c
)

target_compile_definitions(neuz PRIVATE __NEUZ_BUILD_DLL__)

target_include_directories( activator_test PUBLIC ${NEUZ_INCLUDE_DIR} )
target_link_libraries( activator_test PUBLIC ${NEUZ_EXAMPLE_LINK_LIB} )
set_target_properties( activator_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${NEUZ_EXAMPLE_OUTPUT_DIR}
)

add_executable( autoencoder_test
  neuz/example/autoencoder_test.c
)
target_include_directories( autoencoder_test PUBLIC ${NEUZ_INCLUDE_DIR} )
target_link_libraries( autoencoder_test PUBLIC ${NEUZ_EXAMPLE_LINK_LIB} )
set_target_properties( autoencoder_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${NEUZ_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET autoencoder_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/neuz/example/sin_ae.ztk
  $<TARGET_FILE_DIR:autoencoder_test>/
)

add_executable( sin_test
  neuz/example/sin_test.c
)
target_include_directories( sin_test PUBLIC ${NEUZ_INCLUDE_DIR} )
target_link_libraries( sin_test PUBLIC ${NEUZ_EXAMPLE_LINK_LIB} )
set_target_properties( sin_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${NEUZ_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET sin_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/neuz/example/sin.ztk
  $<TARGET_FILE_DIR:sin_test>/
)

add_executable( xor_test
  neuz/example/xor_test.c
)
target_include_directories( xor_test PUBLIC ${NEUZ_INCLUDE_DIR} )
target_link_libraries( xor_test PUBLIC ${NEUZ_EXAMPLE_LINK_LIB} )
set_target_properties( xor_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${NEUZ_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET xor_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/neuz/example/xor.ztk
  $<TARGET_FILE_DIR:xor_test>/
)

# dzco ----------------------------------------------------------------------

file(GLOB DZCO_SOURCES
  dzco/src/?*.c
)

set_source_files_properties(${DZCO_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB DZCO_HEADERS
  dzco/include/dzco/?*.h
)

set_source_files_properties(${DZCO_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(dzco SHARED
  ${DZCO_SOURCES}
  # ${DZCO_HEADERS}
)

target_precompile_headers(dzco PUBLIC ${ZEDA_HEADERS})

target_compile_definitions(dzco PRIVATE __DZCO_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(dzco PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(DZCO_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/dzco/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(dzco PUBLIC ${DZCO_INCLUDE_DIR})

add_dependencies(dzco zm zeda LibXml2)

target_link_libraries(dzco PUBLIC zm zeda LibXml2)

# dzco test ----------------------------------------------------------------------

set(DZCO_TEST_LINK_LIB
  dzco
  zm
  zeda
  LibXml2
)

set(DZCO_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/dzco/test"
)

file(GLOB DZCO_TEST_SOURCES
  dzco/test/?*.c
)
set_source_files_properties(${DZCO_TEST_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( lin_test
  dzco/test/lin_test.c
)
target_link_libraries( lin_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( lin_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( sys_misc_test
  dzco/test/sys_misc_test.c
)
target_link_libraries( sys_misc_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( sys_misc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( sys_pid_test
  dzco/test/sys_pid_test.c
)
target_link_libraries( sys_pid_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( sys_pid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( tf_test
  dzco/test/tf_test.c
)
target_link_libraries( tf_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( tf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)


# dzco app ----------------------------------------------------------------------

set(DZCO_APP_LINK_LIB
  dzco
  zm
  zeda
  LibXml2
)

set(DZCO_APP_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/dzco/app"
)

file(GLOB DZCO_APP_SOURCES
  dzco/app/?*.c
)
set_source_files_properties(${DZCO_APP_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( dz_bode
  dzco/app/dz_bode.c
)
target_link_libraries( dz_bode PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_bode PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_fr2tf
  dzco/app/dz_fr2tf.c
)
target_link_libraries( dz_fr2tf PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_fr2tf PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_frconv
  dzco/app/dz_frconv.c
)
target_link_libraries( dz_frconv PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_frconv PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_nyquist
  dzco/app/dz_nyquist.c
)
target_link_libraries( dz_nyquist PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_nyquist PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_sim
  dzco/app/dz_sim.c
)
target_link_libraries( dz_sim PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_sim PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_tf2zeropole
  dzco/app/dz_tf2zeropole.c
)
target_link_libraries( dz_tf2zeropole PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_tf2zeropole PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

# dzco example ----------------------------------------------------------------------

set(DZCO_EXAMPLE_LINK_LIB
  dzco
  zm
  zeda
  LibXml2
)

set(DZCO_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/dzco/example"
)

file(GLOB_RECURSE DZCO_EXAMPLE_SOURCES
  dzco/example/?*.c
)
# message(STATUS "DZCO_EXAMPLE_SOURCES=${DZCO_EXAMPLE_SOURCES}")
set_source_files_properties(${DZCO_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )

set(DZCO_EXAMPLE_IDENT_OUTPUT_DIR
  "${DZCO_EXAMPLE_OUTPUT_DIR}/ident"
)

add_executable( fol_ident_test
  dzco/example/ident/fol_ident_test.c
)
target_include_directories( fol_ident_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( fol_ident_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( fol_ident_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_IDENT_OUTPUT_DIR}
)

add_executable( sol_ident_test
  dzco/example/ident/sol_ident_test.c
)
target_include_directories( sol_ident_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( sol_ident_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( sol_ident_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_IDENT_OUTPUT_DIR}
)


set(DZCO_EXAMPLE_LIN_OUTPUT_DIR
  "${DZCO_EXAMPLE_OUTPUT_DIR}/lin"
)

add_executable( co_check_test
  dzco/example/lin/co_check_test.c
)
target_include_directories( co_check_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( co_check_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( co_check_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( invpend_test_dzco
  dzco/example/lin/invpend_test.c
)
target_include_directories( invpend_test_dzco PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( invpend_test_dzco PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( invpend_test_dzco PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)
add_custom_command(TARGET invpend_test_dzco
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/dzco/example/lin/invpend.conf
  $<TARGET_FILE_DIR:invpend_test_dzco>/
)

add_executable( lqr_test
  dzco/example/lin/lqr_test.c
)
target_include_directories( lqr_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( lqr_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( lqr_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( obs_test
  dzco/example/lin/obs_test.c
)
target_include_directories( obs_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( obs_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( obs_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( pole_assign_test
  dzco/example/lin/pole_assign_test.c
)
target_include_directories( pole_assign_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( pole_assign_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( pole_assign_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( riccati_benchmark_test
  dzco/example/lin/riccati_benchmark_test.c
)
target_include_directories( riccati_benchmark_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( riccati_benchmark_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( riccati_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( statefeedback_test
  dzco/example/lin/statefeedback_test.c
)
target_include_directories( statefeedback_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( statefeedback_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( statefeedback_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)

add_executable( tf2lin_test
  dzco/example/lin/tf2lin_test.c
)
target_include_directories( tf2lin_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( tf2lin_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( tf2lin_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_LIN_OUTPUT_DIR}
)


set(DZCO_EXAMPLE_SYS_OUTPUT_DIR
  "${DZCO_EXAMPLE_OUTPUT_DIR}/sys"
)

add_executable( adapt_test
  dzco/example/sys/adapt_test.c
)
target_include_directories( adapt_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( adapt_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( adapt_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( butterworth_test
  dzco/example/sys/butterworth_test.c
)
target_include_directories( butterworth_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( butterworth_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( butterworth_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( chain_test_dzco
  dzco/example/sys/chain_test.c
)
target_include_directories( chain_test_dzco PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( chain_test_dzco PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( chain_test_dzco PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( connect_test_dzco
  dzco/example/sys/connect_test.c
)
target_include_directories( connect_test_dzco PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( connect_test_dzco PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( connect_test_dzco PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)
add_custom_command(TARGET connect_test_dzco
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/dzco/example/sys/connect_test.ztk
  $<TARGET_FILE_DIR:connect_test_dzco>/
)

add_executable( fg_test
  dzco/example/sys/fg_test.c
)
target_include_directories( fg_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( fg_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( fg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( fol_test
  dzco/example/sys/fol_test.c
)
target_include_directories( fol_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( fol_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( fol_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( maf_test
  dzco/example/sys/maf_test.c
)
target_include_directories( maf_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( maf_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( maf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( pc_test
  dzco/example/sys/pc_test.c
)
target_include_directories( pc_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( pc_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( pc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( qpd_test
  dzco/example/sys/qpd_test.c
)
target_include_directories( qpd_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( qpd_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( qpd_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( sol_test
  dzco/example/sys/sol_test.c
)
target_include_directories( sol_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( sol_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( sol_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)

add_executable( ztk_read_test
  dzco/example/sys/ztk_read_test.c
)
target_include_directories( ztk_read_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( ztk_read_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_read_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_SYS_OUTPUT_DIR}
)
add_custom_command(TARGET ztk_read_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/dzco/example/sys/read_test.ztk
  $<TARGET_FILE_DIR:ztk_read_test>/
)


set(DZCO_EXAMPLE_TF_OUTPUT_DIR
  "${DZCO_EXAMPLE_OUTPUT_DIR}/tf"
)

add_executable( bandpass_bode_test
  dzco/example/tf/bandpass_bode_test.c
)
target_include_directories( bandpass_bode_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( bandpass_bode_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( bandpass_bode_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( bode_nyquist_test
  dzco/example/tf/bode_nyquist_test.c
)
target_include_directories( bode_nyquist_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( bode_nyquist_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( bode_nyquist_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( fol_tf_test
  dzco/example/tf/fol_tf_test.c
)
target_include_directories( fol_tf_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( fol_tf_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( fol_tf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( freqres_test
  dzco/example/tf/freqres_test.c
)
target_include_directories( freqres_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( freqres_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( freqres_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( pc_bode_test
  dzco/example/tf/pc_bode_test.c
)
target_include_directories( pc_bode_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( pc_bode_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( pc_bode_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( pid_tf_test
  dzco/example/tf/pid_tf_test.c
)
target_include_directories( pid_tf_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( pid_tf_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( pid_tf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( sol_tf_test
  dzco/example/tf/sol_tf_test.c
)
target_include_directories( sol_tf_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( sol_tf_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( sol_tf_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( tf_io_test
  dzco/example/tf/tf_io_test.c
)
target_include_directories( tf_io_test PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( tf_io_test PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( tf_io_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)

add_executable( tf_test_example
  dzco/example/tf/tf_test.c
)
target_include_directories( tf_test_example PUBLIC ${DZCO_INCLUDE_DIR} )
target_link_libraries( tf_test_example PUBLIC ${DZCO_EXAMPLE_LINK_LIB} )
set_target_properties( tf_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_EXAMPLE_TF_OUTPUT_DIR}
)
add_custom_command(TARGET tf_test_example
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/dzco/example/tf/tf_test.ztk
  ${PROJECT_SOURCE_DIR}/dzco/example/tf/tf_zeropole_test.ztk
  $<TARGET_FILE_DIR:tf_test_example>/
)


# zeo ----------------------------------------------------------------------

file(GLOB ZEO_SOURCES
  zeo/src/?*.c
)

set_source_files_properties(${ZEO_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ZEO_HEADERS
  zeo/include/zeo/?*.h
)

set_source_files_properties(${ZEO_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(zeo SHARED
  ${ZEO_SOURCES}
  # ${ZEO_HEADERS}
)

target_precompile_headers(zeo PUBLIC ${ZEO_HEADERS})

target_compile_definitions(zeo PRIVATE __ZEO_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(zeo PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZEO_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(zeo PUBLIC ${ZEO_INCLUDE_DIR})

add_dependencies(zeo zm zeda LibXml2)

target_link_libraries(zeo PUBLIC zm zeda LibXml2)


# zeo test ------------------------------------------------------------------

set(ZEO_TEST_LINK_LIB
  zeo
  zm
  zeda
  LibXml2
)

set(ZEO_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeo/test"
)

file(GLOB ZEO_TEST_SOURCES
  zeo/test/?*.c
)
set_source_files_properties(${ZEO_TEST_SOURCES} PROPERTIES LANGUAGE CXX )


add_executable( boundingball_test
  zeo/test/boundingball_test.c
)
target_link_libraries( boundingball_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( boundingball_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( box_test
  zeo/test/box_test.c
)
target_link_libraries( box_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( box_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( color_test
  zeo/test/color_test.c
)
target_link_libraries( color_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( color_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( cone_test
  zeo/test/cone_test.c
)
target_link_libraries( cone_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( cone_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( coord2d_test
  zeo/test/coord2d_test.c
)
target_link_libraries( coord2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( coord2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( cyl_test
  zeo/test/cyl_test.c
)
target_link_libraries( cyl_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( cyl_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ecyl_test
  zeo/test/ecyl_test.c
)
target_link_libraries( ecyl_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ecyl_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( elem2d_test
  zeo/test/elem2d_test.c
)
target_link_libraries( elem2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( elem2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( elem3d_test
  zeo/test/elem3d_test.c
)
target_link_libraries( elem3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( elem3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ellipsoid_test
  zeo/test/ellipsoid_test.c
)
target_link_libraries( ellipsoid_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ellipsoid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ep_test
  zeo/test/ep_test.c
)
target_link_libraries( ep_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ep_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( frame2d_test
  zeo/test/frame2d_test.c
)
target_link_libraries( frame2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( frame2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( frame3d_test
  zeo/test/frame3d_test.c
)
target_link_libraries( frame3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( frame3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( gjk_test
  zeo/test/gjk_test.c
)
target_link_libraries( gjk_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( gjk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat2d_test
  zeo/test/mat2d_test.c
)
target_link_libraries( mat2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat3d_test
  zeo/test/mat3d_test.c
)
target_link_libraries( mat3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat6d_test
  zeo/test/mat6d_test.c
)
target_link_libraries( mat6d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat6d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( zeo_misc_test
  zeo/test/misc_test.c
)
target_link_libraries( zeo_misc_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( zeo_misc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( shape_test
  zeo/test/shape_test.c
)
target_link_libraries( shape_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( shape_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( sphere_test
  zeo/test/sphere_test.c
)
target_link_libraries( sphere_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( sphere_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec_data_test
  zeo/test/vec_data_test.c
)
target_link_libraries( vec_data_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec_data_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec2d_test
  zeo/test/vec2d_test.c
)
target_link_libraries( vec2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec3d_test
  zeo/test/vec3d_test.c
)
target_link_libraries( vec3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec3d_tree_test
  zeo/test/vec3d_tree_test.c
)
target_link_libraries( vec3d_tree_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec3d_tree_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec6d_test
  zeo/test/vec6d_test.c
)
target_link_libraries( vec6d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec6d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)


# zeo app ------------------------------------------------------------------

set(ZEO_APP_LINK_LIB
  zeo
  zm
  zeda
  LibXml2
)

set(ZEO_APP_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeo/app"
)

file(GLOB ZEO_APP_SOURCES
  zeo/app/?*.c
)
set_source_files_properties(${ZEO_APP_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( mshape2gp
  zeo/app/mshape2gp.c
)
target_link_libraries( mshape2gp PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( mshape2gp PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_gjk
  zeo/app/zeo_gjk.c
)
target_link_libraries( zeo_gjk PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_gjk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_phconv
  zeo/app/zeo_phconv.c
)
target_link_libraries( zeo_phconv PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_phconv PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_qhull
  zeo/app/zeo_qhull.c
)
target_link_libraries( zeo_qhull PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_qhull PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_stl2ztk
  zeo/app/zeo_stl2ztk.c
)
target_link_libraries( zeo_stl2ztk PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_stl2ztk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)


# zeo example ----------------------------------------------------------------------

set(ZEO_EXAMPLE_LINK_LIB
  zeo
  zm
  zeda
  LibXml2
)

set(ZEO_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeo/example"
)

file(GLOB_RECURSE ZEO_EXAMPLE_SOURCES
  zeo/example/?*.c
)
# message(STATUS "ZEO_EXAMPLE_SOURCES=${ZEO_EXAMPLE_SOURCES}")
set_source_files_properties(${ZEO_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )

set(ZEO_EXAMPLE_BREP_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/brep"
)

add_executable( intersect_test
  zeo/example/brep/intersect_test.c
)
target_include_directories( intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BREP_OUTPUT_DIR}
)

add_executable( merge_test
  zeo/example/brep/merge_test.c
)
target_include_directories( merge_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( merge_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( merge_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BREP_OUTPUT_DIR}
)
make_directory(${ZEO_EXAMPLE_OUTPUT_DIR}/model)
add_custom_command(TARGET merge_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeo/example/model/octahedron.ztk
  ${ZEO_EXAMPLE_OUTPUT_DIR}/model/
)

add_executable( ph2brep_test
  zeo/example/brep/ph2brep_test.c
)
target_include_directories( ph2brep_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ph2brep_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ph2brep_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BREP_OUTPUT_DIR}
)

add_executable( trunc_ph_test
  zeo/example/brep/trunc_ph_test.c
)
target_include_directories( trunc_ph_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( trunc_ph_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( trunc_ph_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BREP_OUTPUT_DIR}
)

add_executable( trunc_test
  zeo/example/brep/trunc_test.c
)
target_include_directories( trunc_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( trunc_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( trunc_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BREP_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_BV_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/bv"
)
add_executable( aabb2d_test
  zeo/example/bv/aabb2d_test.c
)
target_include_directories( aabb2d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb2d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( aabb3d_test
  zeo/example/bv/aabb3d_test.c
)
target_include_directories( aabb3d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb3d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( aabb3d_xform_test
  zeo/example/bv/aabb3d_xform_test.c
)
target_include_directories( aabb3d_xform_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb3d_xform_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb3d_xform_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( boundingdisk2d_test
  zeo/example/bv/boundingdisk2d_test.c
)
target_include_directories( boundingdisk2d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( boundingdisk2d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( boundingdisk2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( convexhull2d_proximity_test
  zeo/example/bv/convexhull2d_proximity_test.c
)
target_include_directories( convexhull2d_proximity_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( convexhull2d_proximity_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( convexhull2d_proximity_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( convexhull2d_test
  zeo/example/bv/convexhull2d_test.c
)
target_include_directories( convexhull2d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( convexhull2d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( convexhull2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( convexhull3d_test
  zeo/example/bv/convexhull3d_test.c
)
target_include_directories( convexhull3d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( convexhull3d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( convexhull3d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( obb2aabb_test
  zeo/example/bv/obb2aabb_test.c
)
target_include_directories( obb2aabb_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( obb2aabb_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( obb2aabb_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

add_executable( obb_test
  zeo/example/bv/obb_test.c
)
target_include_directories( obb_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( obb_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( obb_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_BV_OUTPUT_DIR}
)

set(ZEO_EXAMPLE_COLCHK_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/colchk"
)

add_executable( aabb_intersect_test
  zeo/example/colchk/aabb_intersect_test.c
)
target_include_directories( aabb_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)
add_custom_command(TARGET aabb_intersect_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeo/example/model/box.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/cube.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/cyl.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/octahedron.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/sphere.ztk
  $<TARGET_FILE_DIR:aabb_intersect_test>/
)

add_executable( aabb_plane_intersect_test
  zeo/example/colchk/aabb_plane_intersect_test.c
)
target_include_directories( aabb_plane_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb_plane_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb_plane_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( aabb_tri_intersect_test
  zeo/example/colchk/aabb_tri_intersect_test.c
)
target_include_directories( aabb_tri_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aabb_tri_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aabb_tri_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( box_colchk_test
  zeo/example/colchk/box_colchk_test.c
)
target_include_directories( box_colchk_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( box_colchk_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( box_colchk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( edge_tri_intersect_test
  zeo/example/colchk/edge_tri_intersect_test.c
)
target_include_directories( edge_tri_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( edge_tri_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( edge_tri_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( gjk_critical_test
  zeo/example/colchk/gjk_critical_test.c
)
target_include_directories( gjk_critical_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( gjk_critical_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( gjk_critical_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( gjk_list_test
  zeo/example/colchk/gjk_list_test.c
)
target_include_directories( gjk_list_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( gjk_list_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( gjk_list_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( gjk_mpr_test
  zeo/example/colchk/gjk_mpr_test.c
)
target_include_directories( gjk_mpr_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( gjk_mpr_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( gjk_mpr_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( gjk_point_test
  zeo/example/colchk/gjk_point_test.c
)
target_include_directories( gjk_point_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( gjk_point_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( gjk_point_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( minkowski_sub_test
  zeo/example/colchk/minkowski_sub_test.c
)
target_include_directories( minkowski_sub_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( minkowski_sub_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( minkowski_sub_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( ph_intersect_test
  zeo/example/colchk/ph_intersect_test.c
)
target_include_directories( ph_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ph_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ph_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( vast_colchk_test
  zeo/example/colchk/vast_colchk_test.c
)
target_include_directories( vast_colchk_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( vast_colchk_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( vast_colchk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)

add_executable( veclist_plane_intersect_test
  zeo/example/colchk/veclist_plane_intersect_test.c
)
target_include_directories( veclist_plane_intersect_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( veclist_plane_intersect_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( veclist_plane_intersect_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLCHK_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_COLOR_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/color"
)

add_executable( hue_circle_test
  zeo/example/color/hue_circle_test.c
)
target_include_directories( hue_circle_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( hue_circle_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( hue_circle_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLOR_OUTPUT_DIR}
)

add_executable( rgb_decode_test
  zeo/example/color/rgb_decode_test.c
)
target_include_directories( rgb_decode_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( rgb_decode_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( rgb_decode_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLOR_OUTPUT_DIR}
)

add_executable( rgb_hsv_test
  zeo/example/color/rgb_hsv_test.c
)
target_include_directories( rgb_hsv_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( rgb_hsv_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( rgb_hsv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_COLOR_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_ELEM_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/elem"
)

add_executable( edge2d_closest_test
  zeo/example/elem/edge2d_closest_test.c
)
target_include_directories( edge2d_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( edge2d_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( edge2d_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( edge3d_point_test
  zeo/example/elem/edge3d_point_test.c
)
target_include_directories( edge3d_point_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( edge3d_point_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( edge3d_point_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( plane3d_mean_test
  zeo/example/elem/plane3d_mean_test.c
)
target_include_directories( plane3d_mean_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( plane3d_mean_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( plane3d_mean_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( tri3d_align_test
  zeo/example/elem/tri3d_align_test.c
)
target_include_directories( tri3d_align_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tri3d_align_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tri3d_align_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( tri3d_closest_test
  zeo/example/elem/tri3d_closest_test.c
)
target_include_directories( tri3d_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tri3d_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tri3d_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( tri3d_point_test
  zeo/example/elem/tri3d_point_test.c
)
target_include_directories( tri3d_point_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tri3d_point_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tri3d_point_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)

add_executable( triangulate_test
  zeo/example/elem/triangulate_test.c
)
target_include_directories( triangulate_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( triangulate_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( triangulate_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_ELEM_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_EP_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/ep"
)

add_executable( cascade_test
  zeo/example/ep/cascade_test.c
)
target_include_directories( cascade_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( cascade_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( cascade_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( ep_dif_test
  zeo/example/ep/ep_dif_test.c
)
target_include_directories( ep_dif_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ep_dif_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ep_dif_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( ep_intg_test
  zeo/example/ep/ep_intg_test.c
)
target_include_directories( ep_intg_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ep_intg_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ep_intg_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( ep_ip_test
  zeo/example/ep/ep_ip_test.c
)
target_include_directories( ep_ip_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ep_ip_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ep_ip_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( ep_rot_test
  zeo/example/ep/ep_rot_test.c
)
target_include_directories( ep_rot_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ep_rot_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ep_rot_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( ep_sub_test
  zeo/example/ep/ep_sub_test.c
)
target_include_directories( ep_sub_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ep_sub_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ep_sub_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( slerp_test
  zeo/example/ep/slerp_test.c
)
target_include_directories( slerp_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( slerp_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( slerp_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)

add_executable( torsion_test
  zeo/example/ep/torsion_test.c
)
target_include_directories( torsion_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( torsion_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( torsion_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_EP_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_FRAME_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/frame"
)

add_executable( aa_test
  zeo/example/frame/aa_test.c
)
target_include_directories( aa_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( aa_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( aa_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_FRAME_OUTPUT_DIR}
)

add_executable( euler_test_example
  zeo/example/frame/euler_test.c
)
target_include_directories( euler_test_example PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( euler_test_example PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( euler_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_FRAME_OUTPUT_DIR}
)

add_executable( twist_test
  zeo/example/frame/twist_test.c
)
target_include_directories( twist_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( twist_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( twist_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_FRAME_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_MAP_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/map"
)

add_executable( terra_test
  zeo/example/map/terra_test.c
)
target_include_directories( terra_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( terra_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( terra_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MAP_OUTPUT_DIR}
)

add_executable( terra_ztk_test
  zeo/example/map/terra_ztk_test.c
)
target_include_directories( terra_ztk_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( terra_ztk_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( terra_ztk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MAP_OUTPUT_DIR}
)

set(ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/mshape"
)

add_executable( bball_test_example
  zeo/example/mshape/bball_test.c
)
target_include_directories( bball_test_example PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( bball_test_example PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( bball_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)
add_custom_command(TARGET bball_test_example
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeo/example/model/box.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/mirror.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/octahedron.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/scc.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/sphere.ztk
  $<TARGET_FILE_DIR:bball_test_example>/
)

add_executable( clone_test
  zeo/example/mshape/clone_test.c
)
target_include_directories( clone_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( clone_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( clone_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)

add_executable( closest_test
  zeo/example/mshape/closest_test.c
)
target_include_directories( closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)

add_executable( contig_test
  zeo/example/mshape/contig_test.c
)
target_include_directories( contig_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( contig_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( contig_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)

add_executable( handmade_test
  zeo/example/mshape/handmade_test.c
)
target_include_directories( handmade_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( handmade_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( handmade_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)

add_executable( inside_test
  zeo/example/mshape/inside_test.c
)
target_include_directories( inside_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( inside_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( inside_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_MSHAPE_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_NURBS_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/nurbs"
)

add_executable( nurbs_closest_test
  zeo/example/nurbs/nurbs_closest_test.c
)
target_include_directories( nurbs_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( nurbs_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_NURBS_OUTPUT_DIR}
)
add_custom_command(TARGET nurbs_closest_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeo/example/model/nurbs.ztk
  $<TARGET_FILE_DIR:nurbs_closest_test>/
)

add_executable( nurbs_curve_test
  zeo/example/nurbs/nurbs_curve_test.c
)
target_include_directories( nurbs_curve_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( nurbs_curve_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_curve_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_test_example
  zeo/example/nurbs/nurbs_test.c
)
target_include_directories( nurbs_test_example PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( nurbs_test_example PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_to_ph_test
  zeo/example/nurbs/nurbs_to_ph_test.c
)
target_include_directories( nurbs_to_ph_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( nurbs_to_ph_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_to_ph_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_NURBS_OUTPUT_DIR}
)

add_executable( nurbs_xform_test
  zeo/example/nurbs/nurbs_xform_test.c
)
target_include_directories( nurbs_xform_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( nurbs_xform_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( nurbs_xform_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_NURBS_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_PH_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/ph"
)

add_executable( lathe_test
  zeo/example/ph/lathe_test.c
)
target_include_directories( lathe_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( lathe_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( lathe_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_PH_OUTPUT_DIR}
)

add_executable( prism_test
  zeo/example/ph/prism_test.c
)
target_include_directories( prism_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( prism_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( prism_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_PH_OUTPUT_DIR}
)

add_executable( pyramid_test
  zeo/example/ph/pyramid_test.c
)
target_include_directories( pyramid_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( pyramid_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( pyramid_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_PH_OUTPUT_DIR}
)

add_executable( torus_test
  zeo/example/ph/torus_test.c
)
target_include_directories( torus_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( torus_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( torus_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_PH_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_POINTCLOUD_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/pointcloud"
)

add_executable( pca_test_example
  zeo/example/pointcloud/pca_test.c
)
target_include_directories( pca_test_example PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( pca_test_example PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( pca_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_POINTCLOUD_OUTPUT_DIR}
)

add_executable( pcd_io_test
  zeo/example/pointcloud/pcd_io_test.c
)
target_include_directories( pcd_io_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( pcd_io_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( pcd_io_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_POINTCLOUD_OUTPUT_DIR}
)
add_custom_command(TARGET pcd_io_test
 POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
 ${PROJECT_SOURCE_DIR}/zeo/example/pointcloud/sample.pcd
 $<TARGET_FILE_DIR:pcd_io_test>/
)


set(ZEO_EXAMPLE_SHAPE_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/shape"
)

add_executable( box_closest_test
  zeo/example/shape/box_closest_test.c
)
target_include_directories( box_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( box_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( box_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)
add_custom_command(TARGET box_closest_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeo/example/model/box.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/cone.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/cube.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/cyl.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/ellips.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/mirror.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/nurbs.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/octahedron.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/scc.ztk
  ${PROJECT_SOURCE_DIR}/zeo/example/model/sphere.ztk
  $<TARGET_FILE_DIR:box_closest_test>/
)


add_executable( cone_closest_test
  zeo/example/shape/cone_closest_test.c
)
target_include_directories( cone_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( cone_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( cone_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( cone_inside_test
  zeo/example/shape/cone_inside_test.c
)
target_include_directories( cone_inside_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( cone_inside_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( cone_inside_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( cyl_closest_test
  zeo/example/shape/cyl_closest_test.c
)
target_include_directories( cyl_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( cyl_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( cyl_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( ecyl_closest_test
  zeo/example/shape/ecyl_closest_test.c
)
target_include_directories( ecyl_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ecyl_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ecyl_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( ellipsoid_closest_test
  zeo/example/shape/ellipsoid_closest_test.c
)
target_include_directories( ellipsoid_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( ellipsoid_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( ellipsoid_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( sphere_closest_test
  zeo/example/shape/sphere_closest_test.c
)
target_include_directories( sphere_closest_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( sphere_closest_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( sphere_closest_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( sphere_fit_test
  zeo/example/shape/sphere_fit_test.c
)
target_include_directories( sphere_fit_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( sphere_fit_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( sphere_fit_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)

add_executable( toph_test
  zeo/example/shape/toph_test.c
)
target_include_directories( toph_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( toph_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( toph_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_SHAPE_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_VEC_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/vec"
)

add_executable( tree_array_test
  zeo/example/vec/tree_array_test.c
)
target_include_directories( tree_array_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tree_array_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tree_array_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_VEC_OUTPUT_DIR}
)

add_executable( tree_list_test
  zeo/example/vec/tree_list_test.c
)
target_include_directories( tree_list_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tree_list_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tree_list_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_VEC_OUTPUT_DIR}
)

add_executable( tree_test_example
  zeo/example/vec/tree_test.c
)
target_include_directories( tree_test_example PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( tree_test_example PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( tree_test_example PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_VEC_OUTPUT_DIR}
)


set(ZEO_EXAMPLE_VORONOI_OUTPUT_DIR
  "${ZEO_EXAMPLE_OUTPUT_DIR}/voronoi"
)

add_executable( voronoi2d_test
  zeo/example/voronoi/voronoi2d_test.c
)
target_include_directories( voronoi2d_test PUBLIC ${ZEO_INCLUDE_DIR} )
target_link_libraries( voronoi2d_test PUBLIC ${ZEO_EXAMPLE_LINK_LIB} )
set_target_properties( voronoi2d_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_EXAMPLE_VORONOI_OUTPUT_DIR}
)


# roki ------------------------------------------------------------------

file(GLOB ROKI_SOURCES
  roki/src/?*.c
)

set_source_files_properties(${ROKI_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ROKI_HEADERS
  roki/include/roki/?*.h
)

set_source_files_properties(${ROKI_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(roki SHARED
  ${ROKI_SOURCES}
  # ${ROKI_HEADERS}
)

target_precompile_headers(roki PUBLIC ${ROKI_HEADERS})

target_compile_definitions(roki PRIVATE __ROKI_BUILD_DLL__)

# set_target_properties(roki PROPERTIES CXX_STANDARD 17)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(roki PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ROKI_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/roki/include
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(roki PUBLIC ${ROKI_INCLUDE_DIR})

add_dependencies(roki zeo zm zeda LibXml2)

target_link_libraries(roki PUBLIC zeo zm zeda LibXml2)


# roki test ------------------------------------------------------------------

set(ROKI_TEST_LINK_LIB
  roki
  zeo
  zm
  zeda
  LibXml2
)

set(ROKI_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/roki/test"
)

file(GLOB ROKI_TEST_SOURCES
  roki/test/?*.c
)
set_source_files_properties(${ROKI_TEST_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( body_test
  roki/test/body_test.c
)
target_link_libraries( body_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( body_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( chain_test
  roki/test/chain_test.c
)
target_link_libraries( chain_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( chain_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( contact_test
  roki/test/contact_test.c
)
target_link_libraries( contact_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( contact_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)
add_custom_command(TARGET contact_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/roki/test/contact.ztk
  $<TARGET_FILE_DIR:contact_test>/
)

add_executable( force_test
  roki/test/force_test.c
)
target_link_libraries( force_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( force_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( ik_test
  roki/test/ik_test.c
)
target_link_libraries( ik_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( ik_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( invpend_test
  roki/test/invpend_test.c
)
target_link_libraries( invpend_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( invpend_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)
add_custom_command(TARGET invpend_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/roki/test/invpend.ztk
  $<TARGET_FILE_DIR:invpend_test>/
)

add_executable( jacobi_test
  roki/test/jacobi_test.c
)
target_link_libraries( jacobi_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( jacobi_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_clone_test
  roki/test/joint_clone_test.c
)
target_link_libraries( joint_clone_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_clone_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_cylin_test
  roki/test/joint_cylin_test.c
)
target_link_libraries( joint_cylin_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_cylin_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_float_test
  roki/test/joint_float_test.c
)
target_link_libraries( joint_float_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_float_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_hooke_test
  roki/test/joint_hooke_test.c
)
target_link_libraries( joint_hooke_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_hooke_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_spher_test
  roki/test/joint_spher_test.c
)
target_link_libraries( joint_spher_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_spher_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_test
  roki/test/joint_test.c
)
target_link_libraries( joint_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( link_test
  roki/test/link_test.c
)
target_link_libraries( link_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( link_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( pend_abi_test
  roki/test/pend_abi_test.c
)
target_link_libraries( pend_abi_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( pend_abi_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)
add_custom_command(TARGET pend_abi_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/roki/test/simple_pend.ztk
  $<TARGET_FILE_DIR:pend_abi_test>/
)

add_executable( scara_fk_test
  roki/test/scara_fk_test.c
)
target_link_libraries( scara_fk_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( scara_fk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)


# roki app ------------------------------------------------------------------

set(ROKI_APP_LINK_LIB
  roki
  zeo
  zm
  zeda
  LibXml2
)

set(ROKI_APP_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/roki/app"
)

file(GLOB ROKI_APP_SOURCES
  roki/app/?*.c
)
set_source_files_properties(${ROKI_APP_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( bvh2ztk
  roki/app/bvh2ztk.c
)
target_link_libraries( bvh2ztk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( bvh2ztk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( cad2ztk
  roki/app/cad2ztk.c
)
target_link_libraries( cad2ztk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( cad2ztk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( chain2gp
  roki/app/chain2gp.c
)
target_link_libraries( chain2gp PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( chain2gp PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( chain2mshape
  roki/app/chain2mshape.c
)
target_link_libraries( chain2mshape PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( chain2mshape PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( mshape2chain
  roki/app/mshape2chain.c
)
target_link_libraries( mshape2chain PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( mshape2chain PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_chain_convexify
  roki/app/rk_chain_convexify.c
)
target_link_libraries( rk_chain_convexify PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_chain_convexify PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_fk
  roki/app/rk_fk.c
)
target_link_libraries( rk_fk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_fk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ground
  roki/app/rk_ground.c
)
target_link_libraries( rk_ground PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ground PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_id
  roki/app/rk_id.c
)
target_link_libraries( rk_id PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_id PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ik
  roki/app/rk_ik.c
)
target_link_libraries( rk_ik PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ik PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ikcell_merge
  roki/app/rk_ikcell_merge.c
)
target_link_libraries( rk_ikcell_merge PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ikcell_merge PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_mp
  roki/app/rk_mp.c
)
target_link_libraries( rk_mp PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_mp PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)
add_custom_command(TARGET rk_mp
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/roki/app/test.zv
  $<TARGET_FILE_DIR:rk_mp>/
)

add_executable( urdf2ztk
  roki/app/urdf2ztk.c
)
target_link_libraries( urdf2ztk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( urdf2ztk PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( zvs2zkci
  roki/app/zvs2zkci.c
)
target_link_libraries( zvs2zkci PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( zvs2zkci PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( zvs2zkcs
  roki/app/zvs2zkcs.c
)
target_link_libraries( zvs2zkcs PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( zvs2zkcs PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

# roki example ------------------------------------------------------------------

set(ROKI_EXAMPLE_LINK_LIB
  roki
  zeo
  zm
  zeda
  LibXml2
)

set(ROKI_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/roki/example"
)

file(GLOB_RECURSE ROKI_EXAMPLE_SOURCES
  roki/example/?*.c
)
# message(STATUS "ROKI_EXAMPLE_SOURCES=${ROKI_EXAMPLE_SOURCES}")
set_source_files_properties(${ROKI_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( body_am_test
  roki/example/body/body_am_test.c
)
target_link_libraries( body_am_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( body_am_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET body_am_test
  PRE_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${PROJECT_SOURCE_DIR}/roki/example/model
  ${ROKI_EXAMPLE_OUTPUT_DIR}/
)

add_executable( body_com_test
  roki/example/body/body_com_test.c
)
target_link_libraries( body_com_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( body_com_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( body_wrench_test
  roki/example/body/body_wrench_test.c
)
target_link_libraries( body_wrench_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( body_wrench_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( combine_test
  roki/example/body/combine_test.c
)
target_link_libraries( combine_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( combine_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( body_contig_test
  roki/example/body/contig_test.c
)
target_link_libraries( body_contig_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( body_contig_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( mp_xform_test
  roki/example/body/mp_xform_test.c
)
target_link_libraries( mp_xform_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( mp_xform_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( org_inertia_test
  roki/example/body/org_inertia_test.c
)
target_link_libraries( org_inertia_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( org_inertia_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)


add_executable( cd_test
  roki/example/cd/cd_test.c
)
target_link_libraries( cd_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( cd_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)


add_executable( chain_boundingball_test
  roki/example/chain/boundingball_test.c
)
target_link_libraries( chain_boundingball_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( chain_boundingball_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( chain2vert_test
  roki/example/chain/chain2vert_test.c
)
target_link_libraries( chain2vert_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( chain2vert_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( com_vel_spher_test
  roki/example/chain/com_vel_spher_test.c
)
target_link_libraries( com_vel_spher_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( com_vel_spher_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( com_vel_test
  roki/example/chain/com_vel_test.c
)
target_link_libraries( com_vel_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( com_vel_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( gravity_test
  roki/example/chain/gravity_test.c
)
target_link_libraries( gravity_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( gravity_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( inertia_mat_benchmark_test
  roki/example/chain/inertia_mat_benchmark_test.c
)
target_link_libraries( inertia_mat_benchmark_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( inertia_mat_benchmark_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( joint_index_size_test
  roki/example/chain/joint_index_size_test.c
)
target_link_libraries( joint_index_size_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( joint_index_size_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( joint_index_test
  roki/example/chain/joint_index_test.c
)
target_link_libraries( joint_index_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( joint_index_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( joint_vec_test
  roki/example/chain/joint_vec_test.c
)
target_link_libraries( joint_vec_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( joint_vec_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( zmp_test
  roki/example/chain/zmp_test.c
)
target_link_libraries( zmp_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( zmp_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( contact_ztk_test
  roki/example/contact/ztk_test.c
)
target_link_libraries( contact_ztk_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( contact_ztk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET contact_ztk_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/roki/example/contact/contact.ztk
  $<TARGET_FILE_DIR:contact_ztk_test>/
)

add_executable( H5_ik_test
  roki/example/ik/H5_ik_test.c
)
target_link_libraries( H5_ik_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( H5_ik_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( ik_conf_ztk_test
  roki/example/ik/ik_conf_ztk_test.c
)
target_link_libraries( ik_conf_ztk_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( ik_conf_ztk_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( prioritized_ik_test
  roki/example/ik/prioritized_ik_test.c
)
target_link_libraries( prioritized_ik_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( prioritized_ik_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( example_ik_test
  roki/example/ik/ik_test.c
)
target_link_libraries( example_ik_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( example_ik_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( puma_ik_test
  roki/example/ik/puma_ik_test.c
)
target_link_libraries( puma_ik_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( puma_ik_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( puma_vel_track_test
  roki/example/ik/puma_vel_track_test.c
)
target_link_libraries( puma_vel_track_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( puma_vel_track_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)


add_executable( manip_test
  roki/example/jacobi/manip_test.c
)
target_link_libraries( manip_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( manip_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( sv_test
  roki/example/jacobi/sv_test.c
)
target_link_libraries( sv_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( sv_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( resttorque_test
  roki/example/joint/resttorque_test.c
)
target_link_libraries( resttorque_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( resttorque_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)

add_executable( revol_dyn_test
  roki/example/joint/revol_dyn_test.c
)
target_link_libraries( revol_dyn_test PUBLIC ${ROKI_EXAMPLE_LINK_LIB} )
set_target_properties( revol_dyn_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_EXAMPLE_OUTPUT_DIR}
)


# roki-fd ------------------------------------------------------------------

file(GLOB ROKI_FD_SOURCES
  roki-fd/src/?*.c
)

set_source_files_properties(${ROKI_FD_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ROKI_FD_HEADERS
  roki-fd/include/roki_fd/?*.h
)

set_source_files_properties(${ROKI_FD_HEADERS} PROPERTIES LANGUAGE CXX)

add_library(roki-fd SHARED
  ${ROKI_FD_SOURCES}
  # ${ROKI_FD_HEADERS}
)

target_precompile_headers(roki-fd PUBLIC ${ROKI_FD_HEADERS})

target_compile_definitions(roki-fd PRIVATE __ROKI_FD_BUILD_DLL__)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(roki-fd PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ROKI-FD_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/roki-fd/include
  ${PROJECT_SOURCE_DIR}/roki/include
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(roki-fd PUBLIC ${ROKI-FD_INCLUDE_DIR})

add_dependencies(roki-fd roki zeo zm zeda LibXml2)

target_link_libraries(roki-fd PUBLIC roki zeo zm zeda LibXml2)


# roki-fd example ------------------------------------------------------------------

set(ROKI_FD_EXAMPLE_LINK_LIB
  roki-fd
  roki
  zeo
  zm
  zeda
  LibXml2
)

set(ROKI_FD_EXAMPLE_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/roki-fd/example"
)

file(GLOB_RECURSE ROKI_FD_EXAMPLE_SOURCES
  roki-fd/example/?*.c
)
# message(STATUS "ROKI_FD_EXAMPLE_SOURCES=${ROKI_FD_EXAMPLE_SOURCES}")
set_source_files_properties(${ROKI_FD_EXAMPLE_SOURCES} PROPERTIES LANGUAGE CXX )

add_executable( arm_box_test
  roki-fd/example/chain/arm_box_test.c
)
target_link_libraries( arm_box_test PUBLIC ${ROKI_FD_EXAMPLE_LINK_LIB} )
set_target_properties( arm_box_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_FD_EXAMPLE_OUTPUT_DIR}
)
add_custom_command(TARGET arm_box_test
  PRE_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${PROJECT_SOURCE_DIR}/roki-fd/example/model
  ${ROKI_FD_EXAMPLE_OUTPUT_DIR}/
)

add_executable( arm_box_trq_test
  roki-fd/example/chain/arm_box_trq_test.c
)
target_link_libraries( arm_box_trq_test PUBLIC ${ROKI_FD_EXAMPLE_LINK_LIB} )
set_target_properties( arm_box_trq_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_FD_EXAMPLE_OUTPUT_DIR}
)

add_executable( arm_wall_test
  roki-fd/example/chain/arm_wall_test.c
)
target_link_libraries( arm_wall_test PUBLIC ${ROKI_FD_EXAMPLE_LINK_LIB} )
set_target_properties( arm_wall_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_FD_EXAMPLE_OUTPUT_DIR}
)

add_executable( boxdrop_hardsoft_test
  roki-fd/example/chain/boxdrop_hardsoft_test.c
)
target_link_libraries( boxdrop_hardsoft_test PUBLIC ${ROKI_FD_EXAMPLE_LINK_LIB} )
set_target_properties( boxdrop_hardsoft_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_FD_EXAMPLE_OUTPUT_DIR}
)

add_executable( boxdrop_test
  roki-fd/example/chain/boxdrop_test.c
)
target_link_libraries( boxdrop_test PUBLIC ${ROKI_FD_EXAMPLE_LINK_LIB} )
set_target_properties( boxdrop_test PROPERTIES
  LINKER_LANGUAGE CXX
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_FD_EXAMPLE_OUTPUT_DIR}
)

# roki-gl ------------------------------------------------------------------

file(GLOB ROKI_GL_SOURCES
  roki-gl/src/?*.c
)
list(FILTER ROKI_GL_SOURCES EXCLUDE REGEX ".*roki_glx.c$")
list(FILTER ROKI_GL_SOURCES EXCLUDE REGEX ".*roki_glut.c$")

set_source_files_properties(${ROKI_GL_SOURCES} PROPERTIES LANGUAGE CXX)

file(GLOB ROKI_GL_HEADERS
  roki-gl/include/roki_gl/?*.h
)

set_source_files_properties(${ROKI_GL_HEADERS} PROPERTIES LANGUAGE CXX)

list(FILTER ROKI_GL_HEADERS EXCLUDE REGEX ".*roki_glx.h$")
list(FILTER ROKI_GL_HEADERS EXCLUDE REGEX ".*roki_glut.h$")

add_library(roki-gl SHARED
  ${ROKI_GL_SOURCES}
  # ${ROKI_GL_HEADERS}
)

target_precompile_headers(roki-gl PUBLIC ${ROKI_GL_HEADERS})

target_compile_definitions(roki-gl PRIVATE __ROKI_GL_BUILD_DLL__)

# set_target_properties(roki-gl PROPERTIES CXX_STANDARD 17)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_definitions(roki-gl PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ROKI_GL_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/roki-gl/include
  ${PROJECT_SOURCE_DIR}/roki/include
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${LIBXML2_INCLUDE_DIRECTORY}
)

target_include_directories(roki-gl PUBLIC ${ROKI_GL_INCLUDE_DIR})

add_dependencies(roki-gl roki zeo zm zeda LibXml2)

target_link_libraries(roki-gl PUBLIC roki zeo zm zeda LibXml2 GL GLU glfw jpeg tiff z png GLEW )


# test include & link ------------------------------------------------------------------

set_source_files_properties(test/mi-lib-starter_test.c PROPERTIES LANGUAGE CXX )

add_executable( mi-lib-starter_test
  test/mi-lib-starter_test.c
)
target_include_directories(mi-lib-starter_test PUBLIC roki-gl/include)
target_include_directories(mi-lib-starter_test PUBLIC roki-fd/include)
target_include_directories(mi-lib-starter_test PUBLIC roki/include)
target_include_directories(mi-lib-starter_test PUBLIC zeo/include)
target_include_directories(mi-lib-starter_test PUBLIC neuz/include)
target_include_directories(mi-lib-starter_test PUBLIC dzco/include)
target_include_directories(mi-lib-starter_test PUBLIC zm/include)
target_include_directories(mi-lib-starter_test PUBLIC zeda/include)
target_include_directories(mi-lib-starter_test PUBLIC libxml2/include)
target_link_libraries(mi-lib-starter_test PUBLIC roki-gl)
target_link_libraries(mi-lib-starter_test PUBLIC roki-fd)
target_link_libraries(mi-lib-starter_test PUBLIC roki)
target_link_libraries(mi-lib-starter_test PUBLIC zeo)
target_link_libraries(mi-lib-starter_test PUBLIC neuz)
target_link_libraries(mi-lib-starter_test PUBLIC dzco)
target_link_libraries(mi-lib-starter_test PUBLIC zm)
target_link_libraries(mi-lib-starter_test PUBLIC zeda)
target_link_libraries(mi-lib-starter_test PUBLIC LibXml2)


