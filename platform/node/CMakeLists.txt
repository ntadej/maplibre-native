set(NODE_MODULE_MINIMUM_ABI 83) # Minimum supported Node.js version: 14
set(NODE_MODULE_CACHE_DIR ${CMAKE_BINARY_DIR}/headers)

if(DEFINED ENV{MSYSTEM})
    message(FATAL "MSYS2 is not supported, Node.js in Windows only has binary compatibility with Microsoft Visual C++.")
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmake/module.cmake)

add_node_module(
    mbgl-node
    INSTALL_PATH ${PROJECT_SOURCE_DIR}/platform/node/lib/{node_abi}/mbgl.node
    NAN_VERSION 2.22.2
    EXCLUDE_NODE_ABIS
        46
        47
        48
        51
        137
)

if(WIN32)
    find_package(LIBUV REQUIRED)
else()
    find_package(PkgConfig REQUIRED)
    pkg_search_module(LIBUV libuv REQUIRED)
endif()

add_library(mbgl-node-loop STATIC)

target_sources(
    mbgl-node-loop
    PRIVATE
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/async_task.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/run_loop.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/timer.cpp
)

target_include_directories(
    mbgl-node-loop
    PUBLIC
        ${PROJECT_SOURCE_DIR}/include
        ${PROJECT_SOURCE_DIR}/platform/default/include
        ${PROJECT_SOURCE_DIR}/src
    PRIVATE ${LIBUV_INCLUDE_DIRS}
)

target_link_libraries(
    mbgl-node-loop
    PUBLIC
        MapLibreNative::Base
)

target_sources(
    mbgl-node
    INTERFACE
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_conversion.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_expression.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_expression.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_feature.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_feature.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_logging.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_logging.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_map.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_map.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_mapbox_gl_native.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/node_request.hpp
        ${PROJECT_SOURCE_DIR}/platform/node/src/util/async_queue.hpp
)

target_link_libraries(
    mbgl-node
    INTERFACE mbgl-node-loop
    INTERFACE Mapbox::Map
)

# FIXME: Node bindings only run fully on Linux now because it requires libuv RunLoop (which is the default on Linux). Also, Sanitizer will
# not work here because node will do a dlopen(), which is not currently supported.
if(CMAKE_SYSTEM_NAME STREQUAL Linux AND NOT MLN_WITH_SANITIZER)
    add_test(NAME mbgl-node-memory COMMAND npm run test-memory WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
    add_test(NAME mbgl-node-test COMMAND npm run test WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endif()

# needed because v8config.h uses __cplusplus
# https://learn.microsoft.com/en-us/cpp/build/reference/zc-cplusplus?view=msvc-170
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:__cplusplus")
endif()
