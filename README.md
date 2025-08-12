# DSP48A1 Slice Implementation – Spartan-6 FPGA

## 📌 Overview
This project implements the **DSP48A1 slice** for the Xilinx Spartan-6 FPGA using **SystemVerilog**.  
The design follows the functional specifications of the DSP48A1 block, supporting configurable pipeline stages, multiple DSP operation modes, and cascade chaining.  
The project includes full RTL design, verification using QuestaSim, synthesis & implementation in Vivado, and linting validation.

---

## 🔧 Features
- **Arithmetic Units**:
  - Pre-adder/subtractor for efficient DSP operations
  - 18×18 multiplier with pipeline registers
  - 48-bit post-adder/subtractor with carry logic
- **Configurable Registers**:
  - A0/A1, B0/B1, C, D, M, and P register stages
- **Flexible Operation**:
  - Dynamic OPMODE control for arithmetic flexibility
  - Cascade connections: BCIN/BCOUT, PCIN/PCOUT
- **Verification**:
  - 4 directed verification paths covering all functional modes
  - Self-checking conditions with expected outputs

---

## 📂 Project Structure
```
DSP48A1-Project/
 ├── src/           # RTL source files
 ├── tb/            # Testbench files
 ├── constraints/   # XDC/UCF timing constraints
 ├── reports/       # Synthesis, timing, utilization reports
 ├── docs/          # QuestaSim waveforms, Vivado schematics, linting screenshots
 └── README.md      # Project documentation
```

---

## 🛠 Tools & Technologies
- **SystemVerilog** – RTL & Testbench
- **Xilinx Vivado** – Elaboration, Synthesis, Implementation
- **QuestaSim** – Simulation & Waveform Analysis
- **QuestLint** – Linting and code quality checks

---

## 📊 Testbench & Verification
Testbench verifies:
1. **Reset operation** – Ensures all outputs are cleared
2. **Path 1** – Pre-subtractor + post-subtractor operation (`OPMODE = 8'b11011101`)
3. **Path 2** – Pre-addition + post-addition operation (`OPMODE = 8'b00010000`)
4. **Path 3** – P feedback through post-addition (`OPMODE = 8'b00001010`)
5. **Path 4** – D:A:B concatenation + post-subtractor (`OPMODE = 8'b10100111`)

Expected outputs are compared automatically in the testbench, and all cases pass successfully.

---

## 📊 Results
- ✅ All verification cases passed with expected outputs
- ✅ Timing closure achieved at **100 MHz** (W5 pin constraint)
- ✅ Optimized resource utilization
- ✅ **Zero** linting errors
- ✅ Clean synthesis and implementation without critical warnings

---

## 📷 Documentation
See `/docs` for:
- QuestaSim waveform captures
- Vivado elaboration, synthesis, and implementation schematics
- Timing and utilization reports
- Linting validation results

---

## 🚀 How to Run
1. Open the project in **Vivado**
2. Load RTL files from `/src` and constraints from `/constraints`
3. Run:
   - Elaboration
   - Synthesis
   - Implementation
4. Open `/tb` in **QuestaSim** and run simulation with the provided `.do` file
5. Verify outputs against expected results

---

## 📜 License
This project is licensed under the [MIT License](LICENSE).

---

**Author:** Omar Ahmed Fouad  
**GitHub:** [Add your GitHub profile link here]
