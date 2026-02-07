cmake_minimum_required(VERSION 3.22)
project(lutecio LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenSSL REQUIRED)
find_package(dpp CONFIG REQUIRED)

add_executable(${PROJECT_NAME}
    src/main.cpp
)

add_definitions(-DDPP_STATIC)

target_compile_definitions(${PROJECT_NAME} PRIVATE DPP_USE_EXTERNAL_OPENSSL)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)

target_link_libraries(${PROJECT_NAME} PRIVATE
    dpp::dpp
    OpenSSL::SSL
    OpenSSL::Crypto)
