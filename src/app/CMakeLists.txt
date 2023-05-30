add_executable(app main.cpp)

target_link_libraries(app PRIVATE myproject::myproject_options myproject::myproject_warnings Utils)

target_link_system_libraries(
  app
  PRIVATE
  CLI11::CLI11
  fmt::fmt
  spdlog::spdlog)

target_include_directories(app PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
