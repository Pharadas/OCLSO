cmake_minimum_required(VERSION 2.8)

project(OCL)
set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY src/)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

find_package(OpenCL REQUIRED)
add_library(OCL SHARED src/OCLLib.cpp)
