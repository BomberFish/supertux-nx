#!/bin/bash
set -e
echo "[*] SuperTux Build Script for Nintendo Switch"
cd "$(dirname "$0")"
mkdir -p build
cd build
rm -rf supertux2.nro supertux2.elf control.nacp
echo "[*] Configuring" 
cmake -DSWITCH=ON -DCMAKE_TOOLCHAIN_FILE="${DEVKITPRO}/cmake/Switch.cmake" ..
echo "[*] Building"
make -j$(nproc) # I paid for the whole CPU, I'm gonna use the whole CPU.

echo "[*] Creating NACP"
COMMIT=$(git rev-parse --short HEAD)
nacptool --create "SuperTux2" "SuperTux Team" "dev-${COMMIT}" control.nacp
echo "[*] Creating NRO"
elf2nro supertux2.elf supertux2.nro --nacp=control.nacp --icon=../data/images/engine/icons/supertux-256x256.png
