cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)
project(task1 C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

include_directories(${CMAKE_SOURCE_DIR})

add_executable(task1
  task2.c
)

pico_enable_stdio_uart(task1 1)
pico_enable_stdio_usb(task1 1)

pico_add_extra_outputs(task1)

target_link_libraries(task1 pico_stdlib)
