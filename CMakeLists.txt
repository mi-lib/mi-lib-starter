#
cmake_minimum_required (VERSION 3.16)

project ("mi-lib-starter" LANGUAGES CXX C)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/build/bin")
set(LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/out/build/lib")
set(PROJECT_BINARY_DIR "${PROJECT_SOURCE_DIR}/out/build/bin")
set(CMAKE_BINARY_DIR "${PROJECT_SOURCE_DIR}/out/build/bin")
set(CMAKE_CXX_STANDARD 17)


# Switch build type
if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "" FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# libxml2 setting
set(LIBXML2_WITH_ICONV OFF)
set(LIBXML2_WITH_LZMA OFF)
set(LIBXML2_WITH_PYTHON OFF)
set(LIBXML2_WITH_ZLIB OFF)
set(BUILD_SHARED_LIBS OFF)


add_compile_definitions("__STATIC_BUILD")

add_subdirectory("libxml")

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

add_library(zeda STATIC
  ${ZEDA_SOURCES}
  ${ZEDA_HEADERS}
)

if (MSVC)
  target_compile_options(zeda PUBLIC /std:c17)
  target_compile_definitions(zeda PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(zeda PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(zeda PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(zeda PUBLIC ${PROJECT_SOURCE_DIR}/libxml/include)

add_dependencies(zeda LibXml2)



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

add_library(zm STATIC 
  ${ZM_SOURCES}
  ${ZM_HEADERS}
)

if (MSVC)
  target_compile_options(zm PUBLIC /std:c17)
  target_compile_definitions(zm PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()

target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/zm/include)
target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/zeda/include)
target_include_directories(zm PUBLIC ${LIBXML2_XMLCONF_WORKING_DIR})
target_include_directories(zm PUBLIC ${PROJECT_SOURCE_DIR}/libxml/include)
add_dependencies(zm zeda LibXml2)

