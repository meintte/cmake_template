include(GenerateExportHeader)

add_library(Utils Random.cpp Sampler2d.cpp)

add_library(myproject::Utils ALIAS Utils)

target_link_libraries(Utils PRIVATE myproject_options myproject_warnings)
target_link_system_libraries(Utils PRIVATE Eigen3::Eigen)

target_include_directories(Utils ${WARNING_GUARD} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                         $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

target_compile_features(Utils PUBLIC cxx_std_${CMAKE_CXX_STANDARD})

set_target_properties(
  Utils
  PROPERTIES VERSION ${PROJECT_VERSION}
             CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES)

generate_export_header(Utils EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/include/myproject/Utils_export.hpp)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(Utils PUBLIC Utils_STATIC_DEFINE)
endif()
