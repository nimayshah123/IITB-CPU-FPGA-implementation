# IITB-CPU: Multicycle Processor FPGA Implementation

This repository contains the code for the FPGA implementation of the IITB-CPU, a 16-bit simple multicycle processor designed for educational purposes. The processor is based on the Little Computer Architecture (LCA) and supports a set of 14 instructions. It is designed to demonstrate the fundamental concepts of CPU architecture, including instruction cycles, registers, program counter (PC), and condition flags.

## Overview

The IITB-CPU is an 8-register, 16-bit computer system with the following key features:
- **8 General-purpose Registers (R0 to R7)**: R7 is dedicated to storing the Program Counter (PC).
- **Program Counter (PC)**: Points to the next instruction in memory, with addresses corresponding to two-byte memory words.
- **Condition Code Register**: Contains two flags - Carry (c) and Zero (z).
- **Instruction Formats**: Supports three machine-code instruction formats (R, I, and J type).
- **Total Instructions**: 14 different instructions are supported.

## Major Changes in this Version

This version introduces several important changes and improvements over the previous version (available in the [EE224_Project GitHub repo](https://github.com/nimayshah123/EE224_Project)):

1. **Extra FPGA Delay States**: Added an extra FPGA delay state (s25) after each instruction, allowing the Instruction Register (IR) to be updated during the previous instruction cycle.
2. **PC Storage in Register R7**: The Program Counter (PC) has been integrated into Register R7, eliminating the need for an external PC block. PC values are now directly read from and written to R7.
3. **FSM Update**: Modified the finite state machine (FSM) to ensure that the original PC value is used for fetching instructions, not PC+1.
4. **PC Update**: The PC now gets updated to PC+1 after its value is transferred to the temporary registers, ensuring proper instruction sequencing.
5. **RESET Pin Addition**: A RESET pin is added, which is mapped to the push button on the Xen-10 FPGA board. The input to the CPU now includes `reset`, `clk`, and `switches (vector)`. The output includes the 8 registers, which are indexed using 8 switches in the programmer's section.

## Features

- **Registers**: 8 general-purpose registers (R0 to R7), with R7 holding the Program Counter.
- **Condition Flags**: Carry and Zero flags for conditional operations.
- **Instruction Set**: 14 instructions with 3 types (R, I, J).
- **User Interface**: The FPGA interface allows for manual input via switches, with 8 switches used to select the registers for viewing.

## Hardware Requirements

- **FPGA Board**: Xen-10 (or compatible FPGA development board).
- **Inputs**: 
  - `reset` (Push button on Xen-10).
  - `clk` (Clock signal).
  - `switches (vector)` (Used to select registers for display).
- **Outputs**: 
  - The 8 general-purpose registers (R0 to R7).

## Instructions

1. **Download the Code**: Clone this repository to your local machine.
   ```bash
   git clone https://github.com/nimayshah123/IITB-CPU.git
