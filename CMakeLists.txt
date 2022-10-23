#
cmake_minimum_required (VERSION 3.16)

project ("mi-lib-starter" LANGUAGES CXX C)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/build/bin")
set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/build/lib")
set(PROJECT_BINARY_DIR "${PROJECT_SOURCE_DIR}/build/bin")
set(CMAKE_BINARY_DIR "${PROJECT_SOURCE_DIR}/build/bin")
set(CMAKE_CXX_STANDARD 17)


# Switch build type
if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "" FORCE)
endif(NOT CMAKE_BUILD_TYPE)


# libxml2 ----------------------------------------------------------------------

# libxml2 setting
set(LIBXML2_WITH_ICONV OFF)
set(LIBXML2_WITH_LZMA OFF)
set(LIBXML2_WITH_PYTHON OFF)
set(LIBXML2_WITH_ZLIB OFF)
set(BUILD_SHARED_LIBS OFF)

add_subdirectory("libxml2")


# mi-lib ----------------------------------------------------------------------

# TODO remove for DLL
add_compile_definitions("__STATIC_BUILD")


# zeda ----------------------------------------------------------------------

set(ZEDA_SOURCES
  zeda/src/zeda_array.c
  zeda/src/zeda_binfile.c
  zeda/src/zeda_bit.c
  zeda/src/zeda_csv.c
  zeda/src/zeda_index.c
  zeda/src/zeda_list.c
  zeda/src/zeda_misc.c
  zeda/src/zeda_option.c
  zeda/src/zeda_rand.c
  zeda/src/zeda_rrtab.c
  zeda/src/zeda_stream.c
  zeda/src/zeda_string.c
  zeda/src/zeda_strlist.c
  zeda/src/zeda_xml.c
  zeda/src/zeda_ztk.c
)

# TODO change from STATIC for DLL
add_library(zeda STATIC
  ${ZEDA_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(zeda PUBLIC /std:c17)
  target_compile_definitions(zeda PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZEDA_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(zeda PUBLIC ${ZEDA_INCLUDE_DIR})

add_dependencies(zeda LibXml2)

add_compile_definitions(__ZEDA_USE_LIBXML true)


# zeda test ----------------------------------------------------------------------

set(ZEDA_TEST_LINK_LIB
  zeda
  LibXml2
)

set(ZEDA_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/test"
)

add_executable( array_test
  zeda/test/array_test.c
)
target_include_directories( array_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( array_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( binfile_test
  zeda/test/binfile_test.c
)
target_include_directories( binfile_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( binfile_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( binfile_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( bit_test
  zeda/test/bit_test.c
)
target_include_directories( bit_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( bit_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( bit_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( defs_test
  zeda/test/defs_test.c
)
target_include_directories( defs_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( defs_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( defs_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( heap_test
  zeda/test/heap_test.c
)
target_include_directories( heap_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( heap_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( heap_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( index_test
 zeda/test/index_test.c
)
target_include_directories( index_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( index_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( index_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( zm_misc_test
  zeda/test/misc_test.c
)
target_include_directories( zm_misc_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( zm_misc_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( zm_misc_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( name_test
  zeda/test/name_test.c
)
target_include_directories( name_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( name_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( name_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( option_test
  zeda/test/option_test.c
)
target_include_directories( option_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( option_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( option_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( ring_test
  zeda/test/ring_test.c
)
target_include_directories( ring_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ring_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( ring_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( rrtab_test
  zeda/test/rrtab_test.c
)
target_include_directories( rrtab_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( rrtab_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( rrtab_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( string_test
  zeda/test/string_test.c
)
target_include_directories( string_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( string_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( string_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_TEST_OUTPUT_DIR}
)

add_executable( strlist_test
  zeda/test/strlist_test.c
)
target_include_directories( strlist_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( strlist_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( strlist_test PROPERTIES
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


set(ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/array"
)

add_executable( array_append_test
  zeda/example/array/array_append_test.c
)
target_include_directories( array_append_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_append_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( array_append_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR}
)

add_executable( array_delete_test
  zeda/example/array/array_delete_test.c
)
target_include_directories( array_delete_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_delete_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( array_delete_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR}
)

add_executable( array_insert_test
  zeda/example/array/array_insert_test.c
)
target_include_directories( array_insert_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_insert_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( array_insert_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR}
)

add_executable( array_quicksort_test
  zeda/example/array/array_quicksort_test.c
)
target_include_directories( array_quicksort_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( array_quicksort_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( array_quicksort_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ARRAY_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_LIST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/list"
)

add_executable( list_append_test
  zeda/example/list/list_append_test.c
)
target_include_directories( list_append_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_append_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_append_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_purge_test
  zeda/example/list/list_purge_test.c
)
target_include_directories( list_purge_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_purge_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_purge_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_quicksort_test
  zeda/example/list/list_quicksort_test.c
)
target_include_directories( list_quicksort_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_quicksort_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_quicksort_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)

add_executable( list_swap_test
  zeda/example/list/list_swap_test.c
)
target_include_directories( list_swap_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( list_swap_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( list_swap_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_LIST_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_MISC_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/misc"
)

add_executable( alloc_test
  zeda/example/misc/alloc_test.c
)
target_include_directories( alloc_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( alloc_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( alloc_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_MISC_OUTPUT_DIR}
)

add_executable( ordinal_str_test
  zeda/example/misc/ordinal_str_test.c
)
target_include_directories( ordinal_str_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ordinal_str_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ordinal_str_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_MISC_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_OPTION_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/option"
)

add_executable( option_test_example
  zeda/example/option/option_test.c
)
target_include_directories( option_test_example PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( option_test_example PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( option_test_example PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_OPTION_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_RAND_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/rand"
)

add_executable( randf_test
  zeda/example/rand/randf_test.c
)
target_include_directories( randf_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( randf_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( randf_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_RAND_OUTPUT_DIR}
)

add_executable( randi_test
  zeda/example/rand/randi_test.c
)
target_include_directories( randi_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( randi_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( randi_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_RAND_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_STREAM_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/stream"
)

add_executable( csv_test
  zeda/example/stream/csv_test.c
)
target_include_directories( csv_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( csv_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( csv_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_STREAM_OUTPUT_DIR}
)

add_executable( stream_test
  zeda/example/stream/stream_test.c
)
target_include_directories( stream_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( stream_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( stream_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_STREAM_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_STRING_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/string"
)

add_executable( read_int_test
  zeda/example/string/read_int_test.c
)
target_include_directories( read_int_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( read_int_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( read_int_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_STRING_OUTPUT_DIR}
)

add_custom_command(TARGET read_int_test
  POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy
  ${PROJECT_SOURCE_DIR}/zeda/example/string/tag.txt
  ${PROJECT_SOURCE_DIR}/zeda/example/string/test.txt
  $<TARGET_FILE_DIR:read_int_test>/
)

add_executable( token_test
  zeda/example/string/token_test.c
)
target_include_directories( token_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( token_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( token_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_STRING_OUTPUT_DIR}
)


set(ZEDA_EXAMPLE_ZTK_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zeda/example/ztk"
)

add_executable( ztk_count_test
  zeda/example/ztk/ztk_count_test.c
)
target_include_directories( ztk_count_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztk_count_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_count_test PROPERTIES
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
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ZTK_OUTPUT_DIR}
)

add_executable( ztk_parse_test
  zeda/example/ztk/ztk_parse_test.c
)
target_include_directories( ztk_parse_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( ztk_parse_test PUBLIC ${ZEDA_EXAMPLE_LINK_LIB} )
set_target_properties( ztk_parse_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEDA_EXAMPLE_ZTK_OUTPUT_DIR}
)


# zm ----------------------------------------------------------------------

set(ZM_SOURCES
  zm/src/zm_cmat.c
  zm/src/zm_complex.c
  zm/src/zm_complex_arith.c
  zm/src/zm_complex_pe.c
  zm/src/zm_cvec.c
  zm/src/zm_data.c
  zm/src/zm_data_fft.c
  zm/src/zm_data_ransac.c
  zm/src/zm_eig.c
  zm/src/zm_fourier.c
  zm/src/zm_graph.c
  zm/src/zm_graph_search.c
  zm/src/zm_ieee.c
  zm/src/zm_intg.c
  zm/src/zm_ip.c
  zm/src/zm_ip_akima.c
  zm/src/zm_ip_clothoid.c
  zm/src/zm_ip_lagrange.c
  zm/src/zm_ip_lin.c
  zm/src/zm_ip_pchip.c
  zm/src/zm_ip_pex.c
  zm/src/zm_ip_spline.c
  zm/src/zm_le.c
  zm/src/zm_le_gen.c
  zm/src/zm_le_lq.c
  zm/src/zm_le_lu.c
  zm/src/zm_le_lyapnov.c
  zm/src/zm_le_minv.c
  zm/src/zm_le_mpinv.c
  zm/src/zm_le_pivot.c
  zm/src/zm_le_tridiag.c
  zm/src/zm_mat.c
  zm/src/zm_mca.c
  zm/src/zm_mca_cluster.c
  zm/src/zm_mca_gmm.c
  zm/src/zm_misc.c
  zm/src/zm_nle_dm.c
  zm/src/zm_nle_se.c
  zm/src/zm_nle_ss.c
  zm/src/zm_nurbs.c
  zm/src/zm_ode.c
  zm/src/zm_ode2.c
  zm/src/zm_ode_adams.c
  zm/src/zm_ode_beuler.c
  zm/src/zm_ode_bk4.c
  zm/src/zm_ode_dc.c
  zm/src/zm_ode_erk.c
  zm/src/zm_ode_euler.c
  zm/src/zm_ode_gear.c
  zm/src/zm_ode_heun.c
  zm/src/zm_ode_rk4.c
  zm/src/zm_ode_rkg.c
  zm/src/zm_opt_direct.c
  zm/src/zm_opt_dm.c
  zm/src/zm_opt_ga.c
  zm/src/zm_opt_lcp_ip.c
  zm/src/zm_opt_lcp_lemke.c
  zm/src/zm_opt_line.c
  zm/src/zm_opt_lp_pdip.c
  zm/src/zm_opt_lp_simplex.c
  zm/src/zm_opt_lp_stdcnv.c
  zm/src/zm_opt_nm.c
  zm/src/zm_opt_pso.c
  zm/src/zm_opt_qp.c
  zm/src/zm_oscil_kura.c
  zm/src/zm_oscil_vdp.c
  zm/src/zm_parse.c
  zm/src/zm_pex.c
  zm/src/zm_pex_eq.c
  zm/src/zm_rand.c
  zm/src/zm_raw_mat.c
  zm/src/zm_raw_vec.c
  zm/src/zm_rrt.c
  zm/src/zm_seq.c
  zm/src/zm_sf_bessel.c
  zm/src/zm_sf_erf.c
  zm/src/zm_sf_fresnel.c
  zm/src/zm_sf_gamma.c
  zm/src/zm_stat.c
  zm/src/zm_vec.c
  zm/src/zm_vec_array.c
  zm/src/zm_vec_list.c
  zm/src/zm_vec_ring.c
  zm/src/zm_vec_tree.c
)

# TODO change from STATIC for DLL
add_library(zm STATIC 
  ${ZM_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(zm PUBLIC /std:c17)
  target_compile_definitions(zm PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZM_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(zm PUBLIC ${ZM_INCLUDE_DIR})

add_dependencies(zm zeda LibXml2)


# zm test ----------------------------------------------------------------------

set(ZM_TEST_LINK_LIB
  zm
  zeda
  LibXml2
)

set(ZM_TEST_OUTPUT_DIR
  "${PROJECT_SOURCE_DIR}/build/bin/zm/test"
)

add_executable( complex_test
  zm/test/complex_test.c
)
target_link_libraries( complex_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( complex_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( cvec_test
  zm/test/cvec_test.c
)
target_link_libraries( cvec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( cvec_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( data_test
  zm/test/data_test.c
)
target_link_libraries( data_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( data_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( ieee_test
  zm/test/ieee_test.c
)
target_link_libraries( ieee_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( ieee_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( le_test
  zm/test/le_test.c
)
target_link_libraries( le_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( le_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( mat_test
  zm/test/mat_test.c
)
target_link_libraries( mat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( mat_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( zeda_misc_test
  zm/test/misc_test.c
)
target_link_libraries( zeda_misc_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( zeda_misc_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( pex_test
  zm/test/pex_test.c
)
target_link_libraries( pex_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( pex_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( raw_mat_test
  zm/test/raw_mat_test.c
)
target_link_libraries( raw_mat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( raw_mat_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( raw_vec_test
  zm/test/raw_vec_test.c
)
target_link_libraries( raw_vec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( raw_vec_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( stat_test
  zm/test/stat_test.c
)
target_link_libraries( stat_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( stat_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_TEST_OUTPUT_DIR}
)

add_executable( vec_test
  zm/test/vec_test.c
)
target_link_libraries( vec_test PUBLIC ${ZM_TEST_LINK_LIB} )
set_target_properties( vec_test PROPERTIES
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

add_executable( deg2rad
  zm/app/deg2rad.c
)
target_link_libraries( deg2rad PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( deg2rad PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( rad2deg
  zm/app/rad2deg.c
)
target_link_libraries( rad2deg PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( rad2deg PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_ave
  zm/app/zm_ave.c
)
target_link_libraries( zm_ave PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_ave PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_le
  zm/app/zm_le.c
)
target_link_libraries( zm_le PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_le PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_pexp
  zm/app/zm_pexp.c
)
target_link_libraries( zm_pexp PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_pexp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_psolve
  zm/app/zm_psolve.c
)
target_link_libraries( zm_psolve PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_psolve PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)

add_executable( zm_seqmod
  zm/app/zm_seqmod.c
)
target_link_libraries( zm_seqmod PUBLIC ${ZM_APP_LINK_LIB} )
set_target_properties( zm_seqmod PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZM_APP_OUTPUT_DIR}
)


# neuz ----------------------------------------------------------------------

set(NEUZ_SOURCES
  neuz/src/neuz_activator.c
  neuz/src/neuz_neuron.c
)

# TODO change from STATIC for DLL
add_library(neuz STATIC 
  ${NEUZ_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(neuz PUBLIC /std:c17)
  target_compile_definitions(neuz PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(NEUZ_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/neuz/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(neuz PUBLIC ${NEUZ_INCLUDE_DIR})

add_dependencies(neuz zm zeda LibXml2)


# dzco ----------------------------------------------------------------------

set(DZCO_SOURCES
  dzco/src/dz_ident_lag.c
  dzco/src/dz_lin.c
  dzco/src/dz_sys.c
  dzco/src/dz_sys_fg.c
  dzco/src/dz_sys_filt_bw.c
  dzco/src/dz_sys_filt_maf.c
  dzco/src/dz_sys_lag.c
  dzco/src/dz_sys_lin.c
  dzco/src/dz_sys_misc.c
  dzco/src/dz_sys_pid.c
  dzco/src/dz_sys_tf.c
  dzco/src/dz_tf.c
  dzco/src/dz_tf_fr.c
)

# TODO change from STATIC for DLL
add_library(dzco STATIC 
  ${DZCO_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(dzco PUBLIC /std:c17)
  target_compile_definitions(dzco PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(DZCO_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/dzco/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(dzco PUBLIC ${DZCO_INCLUDE_DIR})

add_dependencies(dzco zm zeda LibXml2)


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

add_executable( lin_test
  dzco/test/lin_test.c
)
target_link_libraries( lin_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( lin_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( sys_misc_test
  dzco/test/sys_misc_test.c
)
target_link_libraries( sys_misc_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( sys_misc_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( sys_pid_test
  dzco/test/sys_pid_test.c
)
target_link_libraries( sys_pid_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( sys_pid_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_TEST_OUTPUT_DIR}
)

add_executable( tf_test
  dzco/test/tf_test.c
)
target_link_libraries( tf_test PUBLIC ${DZCO_TEST_LINK_LIB} )
set_target_properties( tf_test PROPERTIES
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

add_executable( dz_bode
  dzco/app/dz_bode.c
)
target_link_libraries( dz_bode PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_bode PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_fr2tf
  dzco/app/dz_fr2tf.c
)
target_link_libraries( dz_fr2tf PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_fr2tf PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_frconv
  dzco/app/dz_frconv.c
)
target_link_libraries( dz_frconv PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_frconv PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_nyquist
  dzco/app/dz_nyquist.c
)
target_link_libraries( dz_nyquist PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_nyquist PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_sim
  dzco/app/dz_sim.c
)
target_link_libraries( dz_sim PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_sim PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)

add_executable( dz_tf2zeropole
  dzco/app/dz_tf2zeropole.c
)
target_link_libraries( dz_tf2zeropole PUBLIC ${DZCO_APP_LINK_LIB} )
set_target_properties( dz_tf2zeropole PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${DZCO_APP_OUTPUT_DIR}
)



# zeo ----------------------------------------------------------------------

set(ZEO_SOURCES 
  zeo/src/zeo_brep.c
  zeo/src/zeo_brep_bool.c
  zeo/src/zeo_brep_trunc.c
  zeo/src/zeo_bv2d_aabb.c
  zeo/src/zeo_bv2d_bdisk.c
  zeo/src/zeo_bv2d_ch.c
  zeo/src/zeo_bv3d_aabb.c
  zeo/src/zeo_bv3d_bball.c
  zeo/src/zeo_bv3d_ch.c
  zeo/src/zeo_bv3d_obb.c
  zeo/src/zeo_col.c
  zeo/src/zeo_col_box.c
  zeo/src/zeo_col_gjk.c
  zeo/src/zeo_col_minkowski.c
  zeo/src/zeo_col_mpr.c
  zeo/src/zeo_col_ph.c
  zeo/src/zeo_elem2d.c
  zeo/src/zeo_elem3d.c
  zeo/src/zeo_elem3d_list.c
  zeo/src/zeo_ep.c
  zeo/src/zeo_frame3d.c
  zeo/src/zeo_map.c
  zeo/src/zeo_mapnet.c
  zeo/src/zeo_map_terra.c
  zeo/src/zeo_mat2d.c
  zeo/src/zeo_mat3d.c
  zeo/src/zeo_mat6d.c
  zeo/src/zeo_misc.c
  zeo/src/zeo_mshape3d.c
  zeo/src/zeo_nurbs.c
  zeo/src/zeo_ph.c
  zeo/src/zeo_ph_dae.c
  zeo/src/zeo_ph_obj.c
  zeo/src/zeo_ph_ply.c
  zeo/src/zeo_ph_stl.c
  zeo/src/zeo_pointcloud.c
  zeo/src/zeo_render_color.c
  zeo/src/zeo_render_optic.c
  zeo/src/zeo_render_texture.c
  zeo/src/zeo_shape3d.c
  zeo/src/zeo_shape3d_box.c
  zeo/src/zeo_shape3d_cone.c
  zeo/src/zeo_shape3d_cyl.c
  zeo/src/zeo_shape3d_ecyl.c
  zeo/src/zeo_shape3d_ellips.c
  zeo/src/zeo_shape3d_list.c
  zeo/src/zeo_shape3d_nurbs.c
  zeo/src/zeo_shape3d_ph.c
  zeo/src/zeo_shape3d_sphere.c
  zeo/src/zeo_vec2d.c
  zeo/src/zeo_vec2d_list.c
  zeo/src/zeo_vec3d.c
  zeo/src/zeo_vec3d_list.c
  zeo/src/zeo_vec3d_pca.c
  zeo/src/zeo_vec3d_tree.c
  zeo/src/zeo_vec6d.c
  zeo/src/zeo_voronoi2d.c
)

# TODO change from STATIC for DLL
add_library(zeo STATIC 
  ${ZEO_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(zeo PUBLIC /std:c17)
  target_compile_definitions(zeo PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ZEO_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(zeo PUBLIC ${ZEO_INCLUDE_DIR})

add_dependencies(zeo zm zeda LibXml2)


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

add_executable( bball_test
  zeo/test/bball_test.c
)
target_link_libraries( bball_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( bball_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( box_test
  zeo/test/box_test.c
)
target_link_libraries( box_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( box_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( color_test
  zeo/test/color_test.c
)
target_link_libraries( color_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( color_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( cone_test
  zeo/test/cone_test.c
)
target_link_libraries( cone_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( cone_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( cyl_test
  zeo/test/cyl_test.c
)
target_link_libraries( cyl_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( cyl_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ecyl_test
  zeo/test/ecyl_test.c
)
target_link_libraries( ecyl_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ecyl_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( elem2d_test
  zeo/test/elem2d_test.c
)
target_link_libraries( elem2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( elem2d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( elem3d_test
  zeo/test/elem3d_test.c
)
target_link_libraries( elem3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( elem3d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ellipsoid_test
  zeo/test/ellipsoid_test.c
)
target_link_libraries( ellipsoid_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ellipsoid_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( ep_test
  zeo/test/ep_test.c
)
target_link_libraries( ep_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( ep_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( frame_test
  zeo/test/frame_test.c
)
target_link_libraries( frame_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( frame_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat2d_test
  zeo/test/mat2d_test.c
)
target_link_libraries( mat2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat2d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat3d_test
  zeo/test/mat3d_test.c
)
target_link_libraries( mat3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat3d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( mat6d_test
  zeo/test/mat6d_test.c
)
target_link_libraries( mat6d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( mat6d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( shape_test
  zeo/test/shape_test.c
)
target_link_libraries( shape_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( shape_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( sphere_test
  zeo/test/sphere_test.c
)
target_link_libraries( sphere_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( sphere_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec2d_test
  zeo/test/vec2d_test.c
)
target_link_libraries( vec2d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec2d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec3d_test
  zeo/test/vec3d_test.c
)
target_link_libraries( vec3d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec3d_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec3d_tree_test
  zeo/test/vec3d_tree_test.c
)
target_link_libraries( vec3d_tree_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec3d_tree_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_TEST_OUTPUT_DIR}
)

add_executable( vec6d_test
  zeo/test/vec6d_test.c
)
target_link_libraries( vec6d_test PUBLIC ${ZEO_TEST_LINK_LIB} )
set_target_properties( vec6d_test PROPERTIES
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

add_executable( mshape2gp
  zeo/app/mshape2gp.c
)
target_link_libraries( mshape2gp PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( mshape2gp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_gjk
  zeo/app/zeo_gjk.c
)
target_link_libraries( zeo_gjk PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_gjk PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_phconv
  zeo/app/zeo_phconv.c
)
target_link_libraries( zeo_phconv PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_phconv PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_qhull
  zeo/app/zeo_qhull.c
)
target_link_libraries( zeo_qhull PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_qhull PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)

add_executable( zeo_stl2ztk
  zeo/app/zeo_stl2ztk.c
)
target_link_libraries( zeo_stl2ztk PUBLIC ${ZEO_APP_LINK_LIB} )
set_target_properties( zeo_stl2ztk PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ZEO_APP_OUTPUT_DIR}
)


# roki ------------------------------------------------------------------

set(ROKI_SOURCES 
  roki/src/rk_abi.c
  roki/src/rk_body.c
  roki/src/rk_cd.c
  roki/src/rk_cd_brep.c
  roki/src/rk_cd_brep_trunc.c
  roki/src/rk_chain.c
  roki/src/rk_contact.c
  roki/src/rk_force.c
  roki/src/rk_g3d.c
  roki/src/rk_ik.c
  roki/src/rk_ik_cell.c
  roki/src/rk_ik_imp.c
  roki/src/rk_ik_seq.c
  roki/src/rk_jacobi.c
  roki/src/rk_joint.c
  roki/src/rk_joint_brfloat.c
  roki/src/rk_joint_cylin.c
  roki/src/rk_joint_fixed.c
  roki/src/rk_joint_float.c
  roki/src/rk_joint_hooke.c
  roki/src/rk_joint_prism.c
  roki/src/rk_joint_revol.c
  roki/src/rk_joint_spher.c
  roki/src/rk_link.c
  roki/src/rk_motor.c
  roki/src/rk_motor_dc.c
  roki/src/rk_motor_none.c
  roki/src/rk_motor_trq.c
)

# TODO change from STATIC for DLL
add_library(roki STATIC 
  ${ROKI_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(roki PUBLIC /std:c17)
  target_compile_definitions(roki PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

set(ROKI_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/roki/include
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(roki PUBLIC ${ROKI_INCLUDE_DIR})

add_dependencies(roki zeo zm zeda LibXml2)


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

add_executable( body_test
  roki/test/body_test.c
)
target_link_libraries( body_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( body_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( chain_test
  roki/test/chain_test.c
)
target_link_libraries( chain_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( chain_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( contact_test
  roki/test/contact_test.c
)
target_link_libraries( contact_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( contact_test PROPERTIES
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
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( ik_test
  roki/test/ik_test.c
)
target_link_libraries( ik_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( ik_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( invpend_test
  roki/test/invpend_test.c
)
target_link_libraries( invpend_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( invpend_test PROPERTIES
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
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( joint_test
  roki/test/joint_test.c
)
target_link_libraries( joint_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( joint_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( link_test
  roki/test/link_test.c
)
target_link_libraries( link_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( link_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_TEST_OUTPUT_DIR}
)

add_executable( pend_abi_test
  roki/test/pend_abi_test.c
)
target_link_libraries( pend_abi_test PUBLIC ${ROKI_TEST_LINK_LIB} )
set_target_properties( pend_abi_test PROPERTIES
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

add_executable( cad2ztk
  roki/app/cad2ztk.c
)
target_link_libraries( cad2ztk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( cad2ztk PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( chain2gp
  roki/app/chain2gp.c
)
target_link_libraries( chain2gp PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( chain2gp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( chain2mshape
  roki/app/chain2mshape.c
)
target_link_libraries( chain2mshape PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( chain2mshape PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( mshape2chain
  roki/app/mshape2chain.c
)
target_link_libraries( mshape2chain PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( mshape2chain PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_fk
  roki/app/rk_fk.c
)
target_link_libraries( rk_fk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_fk PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ground
  roki/app/rk_ground.c
)
target_link_libraries( rk_ground PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ground PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_id
  roki/app/rk_id.c
)
target_link_libraries( rk_id PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_id PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ik
  roki/app/rk_ik.c
)
target_link_libraries( rk_ik PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ik PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_ikcell_merge
  roki/app/rk_ikcell_merge.c
)
target_link_libraries( rk_ikcell_merge PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_ikcell_merge PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( rk_mp
  roki/app/rk_mp.c
)
target_link_libraries( rk_mp PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( rk_mp PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( urdf2ztk
  roki/app/urdf2ztk.c
)
target_link_libraries( urdf2ztk PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( urdf2ztk PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( zvs2zkci
  roki/app/zvs2zkci.c
)
target_link_libraries( zvs2zkci PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( zvs2zkci PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)

add_executable( zvs2zkcs
  roki/app/zvs2zkcs.c
)
target_link_libraries( zvs2zkcs PUBLIC ${ROKI_APP_LINK_LIB} )
set_target_properties( zvs2zkcs PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${ROKI_APP_OUTPUT_DIR}
)


# roki-fd ------------------------------------------------------------------

set(ROKI-FD_SOURCES
  roki-fd/src/rkfd_cd.c
  roki-fd/src/rkfd_mlcp.c
  roki-fd/src/rkfd_penalty.c
  roki-fd/src/rkfd_property.c
  roki-fd/src/rkfd_sim.c
  roki-fd/src/rkfd_solver.c
  roki-fd/src/rkfd_util.c
  roki-fd/src/rkfd_vert.c
  roki-fd/src/rkfd_volume.c
)

# TODO change from STATIC for DLL
add_library(roki-fd STATIC 
  ${ROKI-FD_SOURCES}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(roki-fd PUBLIC /std:c17)
endif()

set(ROKI-FD_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/roki-fd/include
  ${PROJECT_SOURCE_DIR}/roki/include
  ${PROJECT_SOURCE_DIR}/zeo/include
  ${PROJECT_SOURCE_DIR}/zm/include
  ${PROJECT_SOURCE_DIR}/zeda/include
  ${LIBXML2_XMLCONF_WORKING_DIR}
  ${PROJECT_SOURCE_DIR}/libxml2/include
)

target_include_directories(roki-fd PUBLIC ${ROKI-FD_INCLUDE_DIR})

add_dependencies(roki-fd roki zeo zm zeda LibXml2)


# test include & link ------------------------------------------------------------------

add_executable( mi-lib-starter_test
  test/mi-lib-starter_test.c
)
target_include_directories(mi-lib-starter_test PUBLIC roki-fd/include)
target_include_directories(mi-lib-starter_test PUBLIC roki/include)
target_include_directories(mi-lib-starter_test PUBLIC zeo/include)
target_include_directories(mi-lib-starter_test PUBLIC neuz/include)
target_include_directories(mi-lib-starter_test PUBLIC dzco/include)
target_include_directories(mi-lib-starter_test PUBLIC zm/include)
target_include_directories(mi-lib-starter_test PUBLIC zeda/include)
target_include_directories(mi-lib-starter_test PUBLIC libxml2/include)
target_link_libraries(mi-lib-starter_test PUBLIC roki-fd)
target_link_libraries(mi-lib-starter_test PUBLIC roki)
target_link_libraries(mi-lib-starter_test PUBLIC zeo)
target_link_libraries(mi-lib-starter_test PUBLIC neuz)
target_link_libraries(mi-lib-starter_test PUBLIC dzco)
target_link_libraries(mi-lib-starter_test PUBLIC zm)
target_link_libraries(mi-lib-starter_test PUBLIC zeda)
target_link_libraries(mi-lib-starter_test PUBLIC LibXml2)