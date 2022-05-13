cmake_minimum_required(VERSION 3.0)

project(test)

find_package(OpenSSL REQUIRED)
add_executable(test test.cpp)
target_link_libraries(test PRIVATE OpenSSL::SSL OpenSSL::Crypto)