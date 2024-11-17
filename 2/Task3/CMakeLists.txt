cmake_minimum_required(VERSION 3.13)

# Set the path to your Pico SDK
include(pico_sdk_import.cmake)

# Set the project name and language
project(task3 C CXX ASM)

# Define the C standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the Pico SDK
pico_sdk_init()

include_directories(${CMAKE_SOURCE_DIR})

add_executable(task3 task3.S sdklink.c)

# Link the necessary libraries (standard libraries and GPIO functions)
target_link_libraries(task3 pico_stdlib hardware_gpio)

# Enable extra outputs (like the UF2 file for flashing)
pico_add_extra_outputs(task3)
