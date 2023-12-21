# drop32

**D**rop32 **R**ISC-V **O**pen-sourced **P**rocessor

- RV32I ISA
- 4-stage in-order pipelined processor
- Aimed to be implemented as a soft-cpu for use in FPGAs

## Prerequisites ✅
- GNU Make
- Python >= 3.6
- C++14 compiler (or greater)
- Verilator >= 4.028 (**optional**)
- GoogleTest (**optional**)
- GCC RISC-V compiler/cross-compiler toolchain (**optional**)

## Pre-build ⚒️
This repo uses git submodules - make sure to pull those first:

    $ git submodule update --init --recursive

## Build Simulator 🖥
To build Verilator-based simulator:

    $ make sim

Output dir: `build/Vdrop32`

See this [README.md](./sim/README.md) for guide.

## Build Tests 🧪
Building tests require the above `optional` prerequisites.

To build tests:

    $ make tests

Test runner: `build/Vdrop32_tests`

## Build drop32 core
There is a convenience script to generate a singular core/CPU RTL file to stdout:

    $ python3 ./scripts/core_gen.py [opts]

Use `-h` to list available options.

## Build drop32soc
`drop32soc/` directory provides a very basic example SoC using the drop32 soft-cpu.

The CPU is generated using the `scripts/drop32soc_gen.py` utility.

To build Firmware and Generate CPU core for SoC:

    $ make soc

- CPU specs
    - RV32I ISA
    - No interface protocol applied (i.e. using custom interfacing)
    - Pipelined (4-stages)
    - Static branch prediction (assume not taken)
- SoC specs
    - 1KB Instruction memory (pre-programmed in BRAM, readonly)
    - 1KB Data RAM
    - 1 Output pin (e.g. hello-world LED blink)

## Docker 🐳
RISC-V GCC cross-compiler is needed for building tests and building example firmware. There is a Dockerfile
here to take care of this (easy-mode).

To build and start the container (need to run at least once to ensure container is running):

    $ docker build -t riscv-gnu-toolchain .
    $ docker create -it -v $PWD:/src --name drop32 riscv-gnu-toolchain
    $ docker start drop32

Then to build the tests:

    $ make DOCKER=ON

Then to shut down the container when finished:

    $ docker stop drop32

## Make configs ⚙
Below are a table of Make config variables:
| Variable     | Behavior                   | Usage                                   | Default             |
|:-------------|:---------------------------|:----------------------------------------|:--------------------|
|TC_TRIPLE     |RISCV-GCC toolchain triple  |$ make TC_TRIPLE=riscv64-unknown-elf ... | riscv64-unknown-elf |
|DOCKER        |Use Docker GCC toolchain    |$ make DOCKER=1 ...                      | 0 (OFF)             |
