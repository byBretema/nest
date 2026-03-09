
#! Vars

repo_root    := `git rev-parse --show-toplevel 2>/dev/null || pwd`
compiler_cpp := `which clang++`
compiler_c   := `which clang`

subprojects := `for d in */; do if [ -f "$d/CMakeLists.txt" ]; then echo "${d%/}"; fi; done`

build_dir    := "build"
subbuild_dir := build_dir / "subbuild"

build_type := "Release"

#! Interface

[private]
default: #_validate_subprojects
    @echo
    @echo "Available subprojects:"
    @printf '%s\n' "{{subprojects}}" | while IFS= read -r p; do \
        if echo "$p" | grep -q " "; then \
            echo -e "    $p    \e[93m⚠️ Rename to '${p// /_}'\e[0m"; \
        else \
            echo "    $p"; \
        fi \
    done
    @echo
    @just --list

#! Privates

_config flags="":
    @mkdir -p {{subbuild_dir}}
    cmake -S . -G "Ninja" -B {{subbuild_dir}} {{flags}} \
      -DCMAKE_CXX_COMPILER="{{compiler_cpp}}" \
      -DCMAKE_C_COMPILER="{{compiler_c}}" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_COMPILE_WARNING_AS_ERROR=ON
    @echo
    ln -sf {{repo_root}}/{{subbuild_dir}}/compile_commands.json {{repo_root}}/compile_commands.json

# _validate_subprojects:
#     @printf '%s\n' "{{subprojects}}" | while IFS= read -r p; do \
#         if echo "$p" | grep -q " "; then \
#             echo "⚠️ Rename '$p' to '${p// /_}' to avoid path issues on CMake generators."; \
#         fi \
#     done

_validate_subproject target:
    @if echo "${{target}}" | grep -q " "; then \
        echo -e "🔴 Target contains spaces, cannot be built.\nRename it from '$p' to '${p// /_}' to avoid path issues on CMake generators."; \
    fi

#! Build

build target="all": (_validate_subproject target) _config
    cmake --build {{subbuild_dir}} -j 24 --target "{{ replace(target, ' ', '_') }}"

run target *args: (build target)
    ./{{build_dir}}/bin/{{ replace(target, ' ', '_') }}/{{ replace(target, ' ', '_') }} {{args}}

#! Cleanup

# fresh:
#     rm -rf {{subbuild_dir}}/*
#     just config "--fresh"
#     just build

clean target="all":
    rm -rf {{build_dir}}
    rm -f {{repo_root}}/compile_commands.json
    just config
    just build
