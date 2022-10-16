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

set(ZEDA_HEADERS
  zeda/include/zeda/zeda.h
  zeda/include/zeda/zeda_array.h
  zeda/include/zeda/zeda_binfile.h
  zeda/include/zeda/zeda_bit.h
  zeda/include/zeda/zeda_compat.h
  zeda/include/zeda/zeda_csv.h
  zeda/include/zeda/zeda_defs.h
  zeda/include/zeda/zeda_errmsg.h
  zeda/include/zeda/zeda_index.h
  zeda/include/zeda/zeda_list.h
  zeda/include/zeda/zeda_misc.h
  zeda/include/zeda/zeda_name.h
  zeda/include/zeda/zeda_option.h
  zeda/include/zeda/zeda_rand.h
  zeda/include/zeda/zeda_ring.h
  zeda/include/zeda/zeda_rrtab.h
  zeda/include/zeda/zeda_stream.h
  zeda/include/zeda/zeda_string.h
  zeda/include/zeda/zeda_strlist.h
  zeda/include/zeda/zeda_tree.h
  zeda/include/zeda/zeda_xml.h
  zeda/include/zeda/zeda_ztk.h
)

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
  ${ZEDA_HEADERS}
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

add_executable( misc_test
  zeda/test/misc_test.c
)
target_include_directories( misc_test PUBLIC ${ZEDA_INCLUDE_DIR})
target_link_libraries( misc_test PUBLIC ${ZEDA_TEST_LINK_LIB} )
set_target_properties( misc_test PROPERTIES
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

set(ZM_HEADERS
  zm/include/zm/zm.h
  zm/include/zm/zm_cmat.h
  zm/include/zm/zm_complex.h
  zm/include/zm/zm_complex_arith.h
  zm/include/zm/zm_complex_pe.h
  zm/include/zm/zm_cvec.h
  zm/include/zm/zm_data.h
  zm/include/zm/zm_data_fft.h
  zm/include/zm/zm_data_ransac.h
  zm/include/zm/zm_eig.h
  zm/include/zm/zm_errmsg.h
  zm/include/zm/zm_fourier.h
  zm/include/zm/zm_graph.h
  zm/include/zm/zm_graph_search.h
  zm/include/zm/zm_ieee.h
  zm/include/zm/zm_intg.h
  zm/include/zm/zm_ip.h
  zm/include/zm/zm_ip_akima.h
  zm/include/zm/zm_ip_clothoid.h
  zm/include/zm/zm_ip_lagrange.h
  zm/include/zm/zm_ip_lin.h
  zm/include/zm/zm_ip_pchip.h
  zm/include/zm/zm_ip_pex.h
  zm/include/zm/zm_ip_spline.h
  zm/include/zm/zm_le.h
  zm/include/zm/zm_le_gen.h
  zm/include/zm/zm_le_lq.h
  zm/include/zm/zm_le_lu.h
  zm/include/zm/zm_le_lyapnov.h
  zm/include/zm/zm_le_minv.h
  zm/include/zm/zm_le_mpinv.h
  zm/include/zm/zm_le_pivot.h
  zm/include/zm/zm_le_tridiag.h
  zm/include/zm/zm_mat.h
  zm/include/zm/zm_mca.h
  zm/include/zm/zm_mca_cluster.h
  zm/include/zm/zm_mca_gmm.h
  zm/include/zm/zm_misc.h
  zm/include/zm/zm_nle.h
  zm/include/zm/zm_nle_dm.h
  zm/include/zm/zm_nle_se.h
  zm/include/zm/zm_nle_ss.h
  zm/include/zm/zm_nurbs.h
  zm/include/zm/zm_ode.h
  zm/include/zm/zm_ode2.h
  zm/include/zm/zm_ode_adams.h
  zm/include/zm/zm_ode_beuler.h
  zm/include/zm/zm_ode_bk4.h
  zm/include/zm/zm_ode_dc.h
  zm/include/zm/zm_ode_erk.h
  zm/include/zm/zm_ode_euler.h
  zm/include/zm/zm_ode_gear.h
  zm/include/zm/zm_ode_heun.h
  zm/include/zm/zm_ode_rk4.h
  zm/include/zm/zm_ode_rkg.h
  zm/include/zm/zm_opt.h
  zm/include/zm/zm_opt_direct.h
  zm/include/zm/zm_opt_dm.h
  zm/include/zm/zm_opt_ga.h
  zm/include/zm/zm_opt_lcp.h
  zm/include/zm/zm_opt_line.h
  zm/include/zm/zm_opt_lp.h
  zm/include/zm/zm_opt_nm.h
  zm/include/zm/zm_opt_pso.h
  zm/include/zm/zm_opt_qp.h
  zm/include/zm/zm_oscil.h
  zm/include/zm/zm_parse.h
  zm/include/zm/zm_pex.h
  zm/include/zm/zm_pex_eq.h
  zm/include/zm/zm_pi.h
  zm/include/zm/zm_rand.h
  zm/include/zm/zm_raw.h
  zm/include/zm/zm_raw_mat.h
  zm/include/zm/zm_raw_vec.h
  zm/include/zm/zm_rrt.h
  zm/include/zm/zm_seq.h
  zm/include/zm/zm_sf.h
  zm/include/zm/zm_sf_bessel.h
  zm/include/zm/zm_sf_erf.h
  zm/include/zm/zm_sf_fresnel.h
  zm/include/zm/zm_sf_gamma.h
  zm/include/zm/zm_stat.h
  zm/include/zm/zm_vec.h
  zm/include/zm/zm_vec_array.h
  zm/include/zm/zm_vec_list.h
  zm/include/zm/zm_vec_ring.h
  zm/include/zm/zm_vec_tree.h
)

# TODO change from STATIC for DLL
add_library(zm STATIC 
  ${ZM_SOURCES}
  ${ZM_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(zm PUBLIC /std:c17)
  target_compile_definitions(zm PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(zm PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
add_dependencies(zm zeda LibXml2)

# neuz ----------------------------------------------------------------------

set(NEUZ_SOURCES
  neuz/src/neuz_activator.c
  neuz/src/neuz_neuron.c
)

set(NEUZ_HEADERS
  neuz/include/neuz/neuz.h
  neuz/include/neuz/neuz_activator.h
  neuz/include/neuz/neuz_errmsg.h
  neuz/include/neuz/neuz_neuron.h
)

add_library(neuz STATIC 
  ${NEUZ_SOURCES}
  ${NEUZ_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(neuz PUBLIC /std:c17)
  target_compile_definitions(neuz PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(neuz PUBLIC ${PROJECT_SOURCE_DIR}/neuz/include)
target_include_directories(neuz PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(neuz PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(neuz PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(neuz PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
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

set(DZCO_HEADERS
  dzco/include/dzco/dzco.h
  dzco/include/dzco/dz_errmsg.h
  dzco/include/dzco/dz_ident_lag.h
  dzco/include/dzco/dz_lin.h
  dzco/include/dzco/dz_sys.h
  dzco/include/dzco/dz_sys_fg.h
  dzco/include/dzco/dz_sys_filt_bw.h
  dzco/include/dzco/dz_sys_filt_maf.h
  dzco/include/dzco/dz_sys_lag.h
  dzco/include/dzco/dz_sys_lin.h
  dzco/include/dzco/dz_sys_misc.h
  dzco/include/dzco/dz_sys_pid.h
  dzco/include/dzco/dz_sys_tf.h
  dzco/include/dzco/dz_tf.h
  dzco/include/dzco/dz_tf_fr.h
)

add_library(dzco STATIC 
  ${DZCO_SOURCES}
  ${DZCO_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(dzco PUBLIC /std:c17)
  target_compile_definitions(dzco PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(dzco PUBLIC ${PROJECT_SOURCE_DIR}/dzco/include)
target_include_directories(dzco PUBLIC ${PROJECT_SOURCE_DIR}/neuz/include)
target_include_directories(dzco PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(dzco PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(dzco PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(dzco PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
add_dependencies(dzco zm zeda LibXml2)


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

set(ZEO_HEADERS
  zeo/include/zeo/zeo.h
  zeo/include/zeo/zeo_brep.h
  zeo/include/zeo/zeo_brep_bool.h
  zeo/include/zeo/zeo_brep_trunc.h
  zeo/include/zeo/zeo_bv2d.h
  zeo/include/zeo/zeo_bv2d_aabb.h
  zeo/include/zeo/zeo_bv2d_bdisk.h
  zeo/include/zeo/zeo_bv2d_ch.h
  zeo/include/zeo/zeo_bv3d.h
  zeo/include/zeo/zeo_bv3d_aabb.h
  zeo/include/zeo/zeo_bv3d_bball.h
  zeo/include/zeo/zeo_bv3d_ch.h
  zeo/include/zeo/zeo_bv3d_obb.h
  zeo/include/zeo/zeo_col.h
  zeo/include/zeo/zeo_col_box.h
  zeo/include/zeo/zeo_col_gjk.h
  zeo/include/zeo/zeo_col_minkowski.h
  zeo/include/zeo/zeo_col_mpr.h
  zeo/include/zeo/zeo_col_ph.h
  zeo/include/zeo/zeo_elem2d.h
  zeo/include/zeo/zeo_elem3d.h
  zeo/include/zeo/zeo_elem3d_list.h
  zeo/include/zeo/zeo_ep.h
  zeo/include/zeo/zeo_errmsg.h
  zeo/include/zeo/zeo_frame3d.h
  zeo/include/zeo/zeo_map.h
  zeo/include/zeo/zeo_mapnet.h
  zeo/include/zeo/zeo_map_terra.h
  zeo/include/zeo/zeo_mat2d.h
  zeo/include/zeo/zeo_mat3d.h
  zeo/include/zeo/zeo_mat6d.h
  zeo/include/zeo/zeo_misc.h
  zeo/include/zeo/zeo_mshape3d.h
  zeo/include/zeo/zeo_nurbs.h
  zeo/include/zeo/zeo_ph.h
  zeo/include/zeo/zeo_ph_dae.h
  zeo/include/zeo/zeo_ph_obj.h
  zeo/include/zeo/zeo_ph_ply.h
  zeo/include/zeo/zeo_ph_stl.h
  zeo/include/zeo/zeo_pointcloud.h
  zeo/include/zeo/zeo_render_color.h
  zeo/include/zeo/zeo_render_optic.h
  zeo/include/zeo/zeo_render_texture.h
  zeo/include/zeo/zeo_shape3d.h
  zeo/include/zeo/zeo_shape3d_box.h
  zeo/include/zeo/zeo_shape3d_cone.h
  zeo/include/zeo/zeo_shape3d_cyl.h
  zeo/include/zeo/zeo_shape3d_ecyl.h
  zeo/include/zeo/zeo_shape3d_ellips.h
  zeo/include/zeo/zeo_shape3d_list.h
  zeo/include/zeo/zeo_shape3d_nurbs.h
  zeo/include/zeo/zeo_shape3d_ph.h
  zeo/include/zeo/zeo_shape3d_sphere.h
  zeo/include/zeo/zeo_vec2d.h
  zeo/include/zeo/zeo_vec2d_list.h
  zeo/include/zeo/zeo_vec3d.h
  zeo/include/zeo/zeo_vec3d_list.h
  zeo/include/zeo/zeo_vec3d_pca.h
  zeo/include/zeo/zeo_vec3d_tree.h
  zeo/include/zeo/zeo_vec6d.h
  zeo/include/zeo/zeo_voronoi2d.h
)

# TODO change from STATIC for DLL
add_library(zeo STATIC 
  ${ZEO_SOURCES}
  ${ZEO_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(zeo PUBLIC /std:c17)
  target_compile_definitions(zeo PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(zeo PUBLIC ${PROJECT_SOURCE_DIR}/zeo/include)
target_include_directories(zeo PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(zeo PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(zeo PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(zeo PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
add_dependencies(zeo zm zeda LibXml2)


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

set(ROKI_HEADERS
  roki/include/roki/rk_abi.h
  roki/include/roki/rk_body.h
  roki/include/roki/rk_cd.h
  roki/include/roki/rk_cd_brep.h
  roki/include/roki/rk_cd_brep_trunc.h
  roki/include/roki/rk_chain.h
  roki/include/roki/rk_contact.h
  roki/include/roki/rk_errmsg.h
  roki/include/roki/rk_force.h
  roki/include/roki/rk_g.h
  roki/include/roki/rk_g3d.h
  roki/include/roki/rk_ik.h
  roki/include/roki/rk_ik_cell.h
  roki/include/roki/rk_ik_imp.h
  roki/include/roki/rk_ik_seq.h
  roki/include/roki/rk_jacobi.h
  roki/include/roki/rk_joint.h
  roki/include/roki/rk_joint_brfloat.h
  roki/include/roki/rk_joint_cylin.h
  roki/include/roki/rk_joint_fixed.h
  roki/include/roki/rk_joint_float.h
  roki/include/roki/rk_joint_hooke.h
  roki/include/roki/rk_joint_prism.h
  roki/include/roki/rk_joint_revol.h
  roki/include/roki/rk_joint_spher.h
  roki/include/roki/rk_link.h
  roki/include/roki/rk_motor.h
  roki/include/roki/rk_motor_dc.h
  roki/include/roki/rk_motor_none.h
  roki/include/roki/rk_motor_trq.h
  roki/include/roki/roki.h
)

# TODO change from STATIC for DLL
add_library(roki STATIC 
  ${ROKI_SOURCES}
  ${ROKI_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(roki PUBLIC /std:c17)
  target_compile_definitions(roki PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(roki PUBLIC ${PROJECT_SOURCE_DIR}/roki/include)
target_include_directories(roki PUBLIC ${PROJECT_SOURCE_DIR}/zeo/include)
target_include_directories(roki PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(roki PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(roki PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(roki PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
add_dependencies(roki zeo zm zeda LibXml2)


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

set(ROKI-FD_HEADERS
  roki-fd/include/roki-fd/rkfd_array.h
  roki-fd/include/roki-fd/rkfd_cd.h
  roki-fd/include/roki-fd/rkfd_chain.h
  roki-fd/include/roki-fd/rkfd_defs.h
  roki-fd/include/roki-fd/rkfd_mlcp.h
  roki-fd/include/roki-fd/rkfd_penalty.h
  roki-fd/include/roki-fd/rkfd_property.h
  roki-fd/include/roki-fd/rkfd_sim.h
  roki-fd/include/roki-fd/rkfd_solver.h
  roki-fd/include/roki-fd/rkfd_util.h
  roki-fd/include/roki-fd/rkfd_vert.h
  roki-fd/include/roki-fd/rkfd_volume.h
  roki-fd/include/roki-fd/roki-fd.h
)

# TODO change from STATIC for DLL
add_library(roki-fd STATIC 
  ${ROKI-FD_SOURCES}
  ${ROKI-FD_HEADERS}
)

if (MSVC)
  # default C version is ANSI C89/90 at MSVC
  target_compile_options(roki-fd PUBLIC /std:c17)
endif()

target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/roki-fd/include)
target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/roki/include)
target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/zeo/include)
target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(roki-fd PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(roki-fd PUBLIC ${PROJECT_SOURCE_DIR}/libxml2/include)
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