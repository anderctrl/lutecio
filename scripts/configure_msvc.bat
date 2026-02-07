@echo off
:: 1. Initialize MSVC Environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

:: 2. Run CMake
cmake -G Ninja -S . -B build ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
  -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake

:: 3. Copy compile_commands for LSP support
if exist build\compile_commands.json (
    copy /Y build\compile_commands.json .
)