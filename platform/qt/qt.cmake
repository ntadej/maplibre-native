message(STATUS "Configuring MapLibre Native with Qt platform")

option(MLN_QT_LIBRARY_ONLY "Build only MapLibre Native Qt bindings libraries" OFF)
option(MLN_QT_WITH_INTERNAL_SQLITE "Build MapLibre Native Qt bindings with internal sqlite" OFF)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR}
             COMPONENTS Gui
                        Network
             REQUIRED)

if(NOT MLN_QT_WITH_INTERNAL_SQLITE)
    find_package(Qt${QT_VERSION_MAJOR}Sql REQUIRED)
else()
    message(STATUS "Using internal sqlite")
    include(${PROJECT_SOURCE_DIR}/vendor/sqlite.cmake)
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    find_package(Threads REQUIRED)

    option(MLN_QT_WITH_INTERNAL_ICU "Build MapLibre Native Qt bindings with internal ICU" OFF)
    if(NOT MLN_QT_WITH_INTERNAL_ICU)
       find_package(ICU COMPONENTS uc REQUIRED)
    else()
       message(STATUS "Using internal ICU")
       include(${PROJECT_SOURCE_DIR}/vendor/icu.cmake)
    endif()
endif()

# Debugging & ccache on Windows
if (MSVC)
    foreach(config DEBUG RELWITHDEBINFO)
        foreach(lang C CXX)
            set(flags_var "CMAKE_${lang}_FLAGS_${config}")
            string(REPLACE "/Zi" "/Z7" ${flags_var} "${${flags_var}}")
            set(${flags_var} "${${flags_var}}" PARENT_SCOPE)
        endforeach()
    endforeach()
endif()

target_sources(
    mbgl-core
    PRIVATE
        ${PROJECT_SOURCE_DIR}/platform/$<IF:$<PLATFORM_ID:Linux>,default/src/mbgl/text/bidi.cpp,qt/src/mbgl/bidi.cpp>
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_frontend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gl/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_frontend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gl/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/i18n/collator.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/layermanager/layer_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/platform/time.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/asset_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/database_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/main_resource_loader.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/mbtiles_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_database.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_download.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/online_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/$<IF:$<BOOL:${MLN_QT_WITH_INTERNAL_SQLITE}>,default/src/mbgl/storage/sqlite3.cpp,qt/src/mbgl/sqlite3.cpp>
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/compression.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/monotonic_timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/async_task.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/async_task_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/gl_functions.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/headless_backend_qt.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/http_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/http_file_source.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/http_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/http_request.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/image.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/number_format.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/local_glyph_rasterizer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/logging_qt.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/run_loop.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/run_loop_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/string_stdlib.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/thread.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/thread_local.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/timer_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/mbgl/utf.cpp
)

target_compile_definitions(
    mbgl-core
    PRIVATE QT_IMAGE_DECODERS
    PUBLIC __QT__ MBGL_USE_GLES2
)

target_include_directories(
    mbgl-core
    PRIVATE ${PROJECT_SOURCE_DIR}/platform/default/include
)

include(${PROJECT_SOURCE_DIR}/vendor/nunicode.cmake)

set_property(TARGET mbgl-core PROPERTY AUTOMOC ON)
if (Qt6_FOUND AND COMMAND qt_enable_autogen_tool)
    qt_enable_autogen_tool(mbgl-core "moc" ON)
endif()

target_link_libraries(
    mbgl-core
    PRIVATE
        $<$<PLATFORM_ID:Linux>:${CMAKE_THREAD_LIBS_INIT}>
        $<$<NOT:$<OR:$<PLATFORM_ID:Windows>,$<PLATFORM_ID:Emscripten>>>:z>
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::Network
        $<IF:$<BOOL:${MLN_QT_WITH_INTERNAL_SQLITE}>,mbgl-vendor-sqlite,Qt${QT_VERSION_MAJOR}::Sql>
        $<$<PLATFORM_ID:Linux>:$<IF:$<BOOL:${MLN_QT_WITH_INTERNAL_ICU}>,mbgl-vendor-icu,ICU::uc>>
        mbgl-vendor-nunicode
)

if(NOT MLN_QT_LIBRARY_ONLY)
    # test runner
    add_executable(
        mbgl-test-runner
        ${PROJECT_SOURCE_DIR}/platform/qt/test/main.cpp
    )

    target_include_directories(
        mbgl-test-runner
        PRIVATE ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/test/include
    )

    target_compile_definitions(
        mbgl-test-runner
        PRIVATE
            WORK_DIRECTORY=${PROJECT_SOURCE_DIR}
            $<$<PLATFORM_ID:Windows>:MBGL_BUILDING_LIB>
    )

    target_link_libraries(
        mbgl-test-runner
        PRIVATE
            Qt${QT_VERSION_MAJOR}::Gui
            mbgl-compiler-options
    )

    if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
        target_link_libraries(
            mbgl-test-runner
            PRIVATE -Wl,-force_load mbgl-test
        )
    else()
        target_link_libraries(
            mbgl-test-runner
            PRIVATE -Wl,--whole-archive mbgl-test -Wl,--no-whole-archive
        )
    endif()

    add_test(NAME mbgl-test-runner COMMAND mbgl-test-runner WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endif()
