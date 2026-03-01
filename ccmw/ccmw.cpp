#include <iostream>
#include <span>
#include <string_view>
#include <vector>

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
    std::cout << "Building target: " << target << "\n";
}

int main(int argc, char **argv) {
    std::vector<std::string_view> args(argv + 1, argv + argc);

    if (args.empty() || args[0] == "--help") {
        std::cout << "Usage: cmw <command> [options]\n";
        return 0;
    }

    std::string_view const command = args[0];

    if (command == "build")
        build(args);

    return 0;
}
