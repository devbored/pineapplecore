# flintRV

A cycle-accurate C++ simulator of the Verilated flintRV RTL.

The C++ code here serves as the wrapper around the Verilated module.

```
$ ./flintRV ./my_loop.hex -d 2
[flintRV - Info ]:[         main.cc:73] - Memory size set to: [ 0.031250 MB ].
[flintRV - Info ]:[         main.cc:74] - Simulation timeout value:  [ 1000 ].
[flintRV - Info ]:[         main.cc:78] - Starting simulation...

===[ OUTPUT ]===================================================================================================
       0:   0x0badc0de   CPU Reset!            STALL:[----]  FLUSH:[----]  STATUS:[--R----]  CYCLE:[0]
       0:   0x00000993   addi s3, zero, 0      STALL:[x---]  FLUSH:[xxxx]  STATUS:[IM-----]  CYCLE:[1]
       4:   0x00000913   addi s2, zero, 0      STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[2]
       8:   0x00400a13   addi s4, zero, 4      STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[3]
       c:   0x01298933   add s2, s3, s2        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[4]
      10:   0x00198993   addi s3, s3, 1        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[5]
      14:   0xff499ce3   bne s3, s4, -8        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[6]
      18:   0x00100073   ebreak                STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[7]
      1c:   0x0000006f   jal zero, 0           STALL:[----]  FLUSH:[xx--]  STATUS:[IM-B---]  CYCLE:[8]
       c:   0x01298933   add s2, s3, s2        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[9]
      10:   0x00198993   addi s3, s3, 1        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[10]
      14:   0xff499ce3   bne s3, s4, -8        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[11]
      18:   0x00100073   ebreak                STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[12]
      1c:   0x0000006f   jal zero, 0           STALL:[----]  FLUSH:[xx--]  STATUS:[IM-B---]  CYCLE:[13]
       c:   0x01298933   add s2, s3, s2        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[14]
      10:   0x00198993   addi s3, s3, 1        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[15]
      14:   0xff499ce3   bne s3, s4, -8        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[16]
      18:   0x00100073   ebreak                STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[17]
      1c:   0x0000006f   jal zero, 0           STALL:[----]  FLUSH:[xx--]  STATUS:[IM-B---]  CYCLE:[18]
       c:   0x01298933   add s2, s3, s2        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[19]
      10:   0x00198993   addi s3, s3, 1        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[20]
      14:   0xff499ce3   bne s3, s4, -8        STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[21]
      18:   0x00100073   ebreak                STALL:[----]  FLUSH:[----]  STATUS:[IM-----]  CYCLE:[22]
================================================================================================================

[flintRV - Info ]:[         main.cc:96] - Simulation done.
```

## Simulator guide ❓

### Program Input 💾
`flintRV` requires a HEX binary/file of the RISC-V program that you want to run.

One can use `objcopy` to obtain raw HEX of program, for example:
```
$ riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 main.c -o myTest
$ riscv64-unknown-elf-objcopy -O binary myTest myTest.hex
```

Standard usage of `flintRV`:
```
[Usage]: flintRV [OPTIONS] <program_binary>.hex
```

`flintRV` also can take options - these options can be viewed by passing the `-h`/`--help` flag.

### Simulation finish cases 🔚
Besides error cases, the simulator ends if any of the following is true:

- Simulator cycle value reaches timeout value
- Simulator encounters an ebreak instruction