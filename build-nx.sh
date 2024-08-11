#!/bin/bash
set -e
echo "[*] SuperTux Build Script for Nintendo Switch"
cd "$(dirname "$0")"

if [ -z "$DEVKITPRO" ]; then
    echo "[!!] Please set DEVKITPRO in your environment. Example: export DEVKITPRO=/opt/devkitpro"
    exit 1
fi

if [[ $* == "--clean" ]]; then
    echo "[*] Cleaning"
    rm -rf build
fi

echo "[*] Patching TinyGetText"
if ! grep -q "include(GNUInstallDirs)" external/tinygettext/CMakeLists.txt; then
    sed -i '1s/^/include(GNUInstallDirs)\n/' external/tinygettext/CMakeLists.txt
fi

mkdir -p build
cd build
rm -rf supertux2.nro supertux2.elf control.nacp
echo "[*] Configuring" 
cmake -DSWITCH=ON -DENABLE_OPENGL=OFF -DCMAKE_TOOLCHAIN_FILE="${DEVKITPRO}/cmake/Switch.cmake" ..
echo "[*] Building"
make -j$(nproc) # I paid for the whole CPU, I'm gonna use the whole CPU.

echo "[*] Creating NACP"
COMMIT=$(git rev-parse --short HEAD)
nacptool --create "SuperTux2" "SuperTux Team" "dev-${COMMIT}" control.nacp
echo "[*] Creating NRO"
elf2nro supertux2.elf supertux2.nro --nacp=control.nacp --icon=../data/images/engine/icons/supertux-256x256.png
