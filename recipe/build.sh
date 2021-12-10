#!/bin/bash

# work-around for https://bitbucket.org/icl/blaspp/issues/13
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    export CMAKE_ARGS="${CMAKE_ARGS} -Dblas_config_cache=${PREFIX}/lib/libblas${SHLIB_EXT}"
    export CMAKE_ARGS="${CMAKE_ARGS} -Dcblas_config_cache=${PREFIX}/lib/libblas${SHLIB_EXT} -Dblaspp_cblas_libraries=-lcblas"
fi

cmake -S . -B build             \
    -DCMAKE_INSTALL_LIBDIR=lib        \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}  \
    -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DBUILD_SHARED_LIBS=ON      \
    -Dbuild_tests=OFF           \
    -Duse_cmake_find_blas=ON    \
    -Duse_openmp=ON             \
    -Dgpu_backend=none          \
    -DBLAS_LIBRARIES=${PREFIX}/lib/libblas${SHLIB_EXT} \
    ${CMAKE_ARGS}

cmake --build build --parallel ${CPU_COUNT}

cmake --build build --target install
