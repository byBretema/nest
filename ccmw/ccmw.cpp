#include <initializer_list>
#include <iostream>
#include <format>
#include <span>
#include <string_view>
#include <vector>

using Str = std::string;
using Strv = std::string_view;

#define Vec std::vector

#define logf(msg, ...) std::cout << std::format(msg, __VA_ARGS__) << "\n"
#define log(msg) std::cout << msg << "\n"

void build(std::span<std::string_view> args) {

    std::string_view target = "all";

    for (size_t i = 1; i < args.size(); ++i) {

        bool const not_last = i + 1 < args.size();
        bool const is_target = (args[i] == "--target" || args[i] == "-t");

          if (is_target && not_last) {
            target = args[++i];
            break;
        }
    }

    logf("Building target: {}", target);
}

int main(int argc, char **argv) {
    Vec<Strv> args(argv + 1, argv + argc);

    if (args.empty() or args[0] == "-h" or args[0] == "--help") {
        log("Usage ccmw <command> [options]");
        return 0;
    }

    Strv const command = args[0];

    if (command == "build")
        build(args);

    return 0;
}
