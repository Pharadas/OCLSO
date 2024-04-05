cmake_minimum_required(VERSION 2.8)

project(gaming)
set(CMAKE_BUILD_TYPE Debug)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
add_library(OpenCL)
add_library(gaming SHARED src/gaming.cpp)
