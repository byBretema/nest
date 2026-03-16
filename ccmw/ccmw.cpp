#define yyEnable_Aliases
#include "../vendor/y.hpp"

void build(Span<StrView> args) {

    y_println("Args: {}", args);
    std::string_view target = "all";

    for (size_t i = 0; i < args.size(); ++i) {

        bool const not_last = i + 1 < args.size();
        bool const is_target = (args[i] == "--target" || args[i] == "-t");

          if (is_target && not_last) {
            target = args[++i];
            break;
        }
    }

    y_info("Building target: {}", target);
}

int usage() {
    y_println("Usage ccmw <command> [options]");
    exit(1);
}

int main(i32 argc, char **argv) {
    Vec<StrView> args(argv + 1, argv + argc);

    if (args.empty() or args[0] == "-h" or args[0] == "--help")
        usage();

    StrView const command = args[0];

    if (command == "build") {
        build(Span{args.begin()+1, args.end()});
        return 0;
    }

    usage();
}
