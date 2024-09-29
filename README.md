# RV32I-made-by-iverilog
這是基於HDL語言所進行的實做練習,內容為Single Cycle RV32I 實現


(如果是剛入門,可以參考我寫的 ： https://hackmd.io/v3cWqbAFQM6SJdFaUXeNJA 有很詳細的內容)
***************************************************************************************************************
RV32I CPU 的實做介紹
本次實作的 RV32I 是基於精簡指令集（RISC-V）指令集架構的一個簡單版本，屬於單週期處理器設計。RV32I 代表的是 32 位元的基本整數指令集（I-Type），並支援加法、減法、位移、邏輯運算、比較以及記憶體存取指令。該實作透過一系列模組來完成，包括程式計數器（PC）、指令記憶體、暫存器檔案、運算邏輯單元（ALU）、數據記憶體以及控制單元。而這個專案在原本的single cycle上,增加了decoder的模組,所以『理論上』是可以進行解碼並操作這類動作的
********************************************************************************
包含但不限於的模組 ： 

1. 程式計數器（PC）：負責追蹤當前指令的地址。每次指令執行後，PC 通常會更新至下一個指令地址。

2. 指令記憶體（Instr Mem）：存放指令的記憶體。在每個週期中，CPU 根據 PC 從記憶體中取出對應的指令。

3. 暫存器檔案（RegFile）：包含 32 個 32 位元的暫存器，支援兩個讀取和一個寫入操作。x0 寄存器永遠為零，這是 RISC-V 中的特殊要求。

4. 運算邏輯單元（ALU）：實現了各種運算，包括加減法、位移運算、邏輯操作、比較操作等。根據控制信號和指令中的 funct3 和 funct7 來細化操作。

5. 數據記憶體（Data Mem）：用於存取記憶體中的數據，支援載入和存儲操作。該模組根據控制信號進行讀寫。

6. 控制單元（Control Unit）：根據指令的操作碼生成控制信號，協調數據通路中各模組的運作。控制單元決定指令的類型並生成對應的 ALUOp 和其他控制信號。

此實作的每個模組均被測試以確保其功能正確，最終 CPU 能夠處理基本的運算指令、條件跳轉以及記憶體存取等操作。RV32I 的設計重點在於實現簡單且高效的指令執行流程，使其能在單個時鐘週期內完成指令的取指、解碼、執行和寫回。
**************************************************************************************************************************************
Implementation of RV32I CPU
This project implements a simplified version of the RV32I single-cycle CPU based on the RISC-V instruction set architecture (ISA). RV32I stands for a 32-bit base integer instruction set, supporting operations such as addition, subtraction, shifting, logical operations, comparisons, and memory access. The implementation includes several key modules such as the Program Counter (PC), Instruction Memory, Register File, Arithmetic Logic Unit (ALU), Data Memory, and Control Unit.

1. Program Counter (PC): Keeps track of the current instruction address. After each instruction is executed, the PC is updated to the address of the next instruction.
2. Instruction Memory (Instr Mem): Stores the instructions. In each cycle, the CPU fetches the corresponding instruction from memory based on the PC.
3. Register File (RegFile): Contains 32 general-purpose 32-bit registers, supporting two read and one write operation. The x0 register is always zero, as required by RISC-V.
4. Arithmetic Logic Unit (ALU): Performs various operations including addition, subtraction, shifting, logical operations, and comparisons. The operations are selected based on control signals and the funct3 and funct7 fields from the instruction.
5. Data Memory (Data Mem): Handles memory access for loading and storing data. This module reads or writes data based on control signals.
6. Control Unit: Generates control signals based on the opcode of the instruction, coordinating the operation of each module in the data path. The Control Unit determines the type of instruction and generates the appropriate ALUOp and other control signals.

Each module in this implementation was tested to ensure its correctness, and the final CPU can handle basic arithmetic instructions, conditional jumps, and memory access operations. The design of the RV32I CPU emphasizes a simple yet efficient instruction execution flow, where each instruction is fetched, decoded, executed, and written back within a single clock cycle.
***********************************************************************************************

![image](https://github.com/b10505050/RV32I-made-by-iverilog/blob/main/%E8%9E%A2%E5%B9%95%E6%93%B7%E5%8F%96%E7%95%AB%E9%9D%A2%202024-09-29%20225300.png)
![image](https://github.com/b10505050/RV32I-made-by-iverilog/blob/main/%E8%9E%A2%E5%B9%95%E6%93%B7%E5%8F%96%E7%95%AB%E9%9D%A2%202024-09-29%20225421.png)



If there has any problem, please tell me and don't resent me 


cause this is my first time to do this project by myself 


And it's just for fun and learning haha


so if those code can help u, it will be my honest


Hope u enjoy


Chun Min ,Chang  from NTU ESOE





