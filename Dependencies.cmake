include(cmake/CPM.cmake)

# Done as a function so that updates to variables like
# CMAKE_CXX_FLAGS don't propagate out to other
# targets
function(myproject_setup_dependencies)

  # For each dependency, see if it's
  # already been provided to us by a parent project
  set(CPM_USE_LOCAL_PACKAGES ON)

  if(NOT TARGET fmtlib::fmtlib)
    cpmaddpackage("gh:fmtlib/fmt#10.2.1")
  endif()

  if(NOT TARGET spdlog::spdlog)
    cpmaddpackage(
      NAME
      spdlog
      GITHUB_REPOSITORY
      "gabime/spdlog"
      VERSION
      1.14.1
      OPTIONS
      "SPDLOG_FMT_EXTERNAL ON"
      EXCLUDE_FROM_ALL
      YES)
  endif()

  if(NOT TARGET Catch2::Catch2WithMain)
    cpmaddpackage("gh:catchorg/Catch2@3.6.0")
  endif()

  if(NOT TARGET CLI11::CLI11)
    cpmaddpackage("gh:CLIUtils/CLI11@2.4.2")
  endif()

  if(NOT TARGET ftxui::screen)
    cpmaddpackage(
      NAME
      FTXUI
      GITHUB_REPOSITORY
      "ArthurSonzogni/FTXUI"
      GIT_TAG
      "v4.1.1"
      OPTIONS
      "FTXUI_BUILD_EXAMPLES OFF"
      "FTXUI_BUILD_DOCS OFF"
      "FTXUI_BUILD_TESTS OFF"
      "FTXUI_BUILD_TESTS_FUZZER OFF"
      "FTXUI_ENABLE_INSTALL OFF"
      EXCLUDE_FROM_ALL
      YES)
  endif()

  if(NOT TARGET tools::tools)
    cpmaddpackage("gh:lefticus/tools#update_build_system")
  endif()

  # if(NOT TARGET glfw::glfw)
  #   cpmaddpackage(
  #     NAME
  #     glfw
  #     GITHUB_REPOSITORY
  #     "glfw/glfw"
  #     GIT_TAG
  #     "3.3.8"
  #     OPTIONS
  #     "GLFW_BUILD_EXAMPLES OFF"
  #     "GLFW_BUILD_TESTS OFF"
  #     "GLFW_BUILD_DOCS OFF"
  #     "GLFW_INSTALL OFF"
  #     EXCLUDE_FROM_ALL
  #     YES)
  # endif()

  # if(NOT TARGET imgui::imgui)
  #   cpmaddpackage(
  #     NAME
  #     imgui
  #     GITHUB_REPOSITORY
  #     "ocornut/imgui"
  #     GIT_TAG
  #     "docking"
  #     EXCLUDE_FROM_ALL
  #     YES)
  # endif()

  if(NOT TARGET nlohmann_json::nlohmann_json)
    cpmaddpackage(
      NAME
      nlohmann_json
      VERSION
      3.11.2
      # the git repo is incredibly large, so we download the archived include directory
      URL
      https://github.com/nlohmann/json/releases/download/v3.11.2/include.zip
      URL_HASH
      SHA256=e5c7a9f49a16814be27e4ed0ee900ecd0092bfb7dbfca65b5a421b774dccaaed)

    if(nlohmann_json_ADDED)
      add_library(nlohmann_json INTERFACE IMPORTED)
      target_include_directories(nlohmann_json INTERFACE ${nlohmann_json_SOURCE_DIR}/include)
      add_library(nlohmann_json::nlohmann_json ALIAS nlohmann_json)
    endif()
  endif()

  if(NOT TARGET Eigen3::Eigen)
    cpmaddpackage(
      NAME
      Eigen
      VERSION
      3.4.0
      GITLAB_REPOSITORY
      "libeigen/eigen"
      GIT_TAG
      "3.4.0"
      DOWNLOAD_ONLY
      YES)
    if(Eigen_ADDED)
      add_library(Eigen3::Eigen INTERFACE IMPORTED)
      target_include_directories(Eigen3::Eigen INTERFACE ${Eigen_SOURCE_DIR})
    else()
      message(FATAL_ERROR "Eigen3 not found and using CPM didn't work either.")
    endif()
  endif()

  if(NOT TARGET OpenMP::OpenMP_CXX)
    find_package(OpenMP)
    set(OpenMP_CXX_FOUND
        ${OpenMP_CXX_FOUND}
        PARENT_SCOPE)
    if(OpenMP_CXX_FOUND)
      target_link_libraries(Eigen3::Eigen INTERFACE OpenMP::OpenMP_CXX)
    endif()
  endif()

  if(NOT TARGET SuperLU::SuperLU)
    find_package(SuperLU)
    set(SuperLU_FOUND
        ${SuperLU_FOUND}
        PARENT_SCOPE)
  endif()

endfunction()
