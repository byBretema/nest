
build_dir="build/build"

rm -rf build/* && \
mkdir -p "${build_dir}" && \
cmake -G "Ninja" -B "${build_dir}" -S . --fresh && \
cmake --build "${build_dir}" -j 16
