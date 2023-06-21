#include <spdlog/spdlog.h>

#include <CLI/CLI.hpp>
#include <internal_use_only/config.hpp>  // project_name, project_version
#include <myproject/Utils/Random.hpp>

int main(int argc, const char** argv) {
    try {
        CLI::App app{fmt::format("{} version {}",
                                 myproject::cmake::project_name,
                                 myproject::cmake::project_version)};

        bool show_version = false;
        app.add_flag("--version", show_version, "Show version information");

        // bool is_turn_based = false;
        // auto* turn_based = app.add_flag("--turn_based", is_turn_based);

        // bool is_loop_based = false;
        // auto* loop_based = app.add_flag("--loop_based", is_loop_based);

        // turn_based->excludes(loop_based);
        // loop_based->excludes(turn_based);

        CLI11_PARSE(app, argc, argv);

        if (show_version) {
            fmt::print("{}\n", myproject::cmake::project_version);
            return EXIT_SUCCESS;
        }

        // if (message) {
        //     fmt::print("{}\n", *message);
        // }

        Random::seed();
        std::cout << Random::nextDouble() << '\n';

    } catch (const std::exception& e) {
        spdlog::error("Unhandled exception in main: {}", e.what());
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
