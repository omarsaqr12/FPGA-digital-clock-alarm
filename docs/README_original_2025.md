# FPGA Digital Clock with Alarm

A digital clock implementation with alarm functionality for the Basys 3 FPGA development board. This project demonstrates advanced digital design concepts including finite state machines, counters, seven-segment display multiplexing, and button debouncing.

## 🔧 Features

- **Digital Clock Display**: Real-time hour:minute display on four 7-segment displays
- **Alarm Functionality**: Set and trigger alarms with visual and audio feedback
- **Interactive Controls**: Five-button interface for time and alarm adjustment
- **State Machine Design**: Robust FSM implementation for mode switching
- **Button Debouncing**: Hardware debouncing for reliable button input
- **Visual Feedback**: LED indicators for different operating modes
- **Audio Alert**: Buzzer output when alarm triggers

## 🎯 System Overview

The system operates in multiple modes controlled by button inputs:

### Operating Modes

1. **Display Mode** - Shows current time (default)
2. **Clock Hour Adjustment** - Adjust current hour
3. **Clock Minute Adjustment** - Adjust current minute
4. **Alarm Hour Setting** - Set alarm hour
5. **Alarm Minute Setting** - Set alarm minute
6. **Alarm Mode** - Active when alarm triggers

### Controls

- **BTNC (Center)**: Mode selection and confirmation
- **BTNL (Left)**: Navigate between modes (left direction)
- **BTNR (Right)**: Navigate between modes (right direction)
- **BTNU (Up)**: Increment time/alarm values
- **BTND (Down)**: Decrement time/alarm values

### Visual Indicators

- **LED 0**: Blinks when alarm is active
- **LED 1-4**: Show current operating mode
- **7-Segment Display**: Shows time in HH:MM format with decimal point separator

## 🏗️ Architecture

### Top-Level Module: `digital_clock_top.v`

Main system controller implementing the finite state machine and coordinating all subsystems.

### Core Modules

#### Clock Management

- **`clock_counter.v`**: Manages hours, minutes, and seconds counting
- **`alarm_counter.v`**: Handles alarm time setting and storage
- **`clock_divider.v`**: Generates 1Hz and 200Hz clocks from 100MHz system clock

#### Display System

- **`seven_segment_display.v`**: Drives 4-digit 7-segment display with multiplexing
- **`counter_x_bit.v`**: Generic parameterizable counter module

#### Input Processing

- **`push_button_detector.v`**: Complete button processing pipeline
- **`debouncer.v`**: Hardware debouncing using shift registers
- **`synchronizer.v`**: Clock domain synchronization
- **`fsm.v`**: Button press detection finite state machine

## 📁 Project Structure

```
fpga-digital-clock/
├── hardware/
│   ├── verilog_sources/          # All Verilog source files
│   │   ├── digital_clock_top.v   # Top-level module
│   │   ├── clock_counter.v       # Time counting logic
│   │   ├── alarm_counter.v       # Alarm time management
│   │   ├── clock_divider.v       # Clock generation
│   │   ├── seven_segment_display.v # Display driver
│   │   ├── counter_x_bit.v       # Generic counter
│   │   ├── push_button_detector.v # Button processing
│   │   ├── debouncer.v           # Input debouncing
│   │   ├── synchronizer.v        # Clock synchronization
│   │   └── fsm.v                 # Button FSM
│   └── constraints/
│       └── basys3_constraints.xdc # Pin assignments
├── docs/                         # Documentation
├── images/                       # System diagrams
├── simulation/                   # Testbenches (if any)
├── final_logisim.circ           # Logisim circuit file
└── README.md                    # This file
```

## 🚀 Getting Started

### Prerequisites

- Xilinx Vivado Design Suite (2018.2 or later)
- Basys 3 FPGA Development Board
- USB cable for programming

### Hardware Setup

1. Connect the Basys 3 board to your computer via USB
2. Ensure the board is powered on
3. Optional: Connect a buzzer to JA1 pin for audio alarm

### Building the Project

1. **Create New Vivado Project**

   ```
   - Launch Vivado
   - Create new RTL project
   - Select Basys 3 board (xc7a35tcpg236-1)
   ```

2. **Add Source Files**

   ```
   - Add all .v files from hardware/verilog_sources/
   - Set digital_clock_top.v as top module
   - Add basys3_constraints.xdc as constraints file
   ```

3. **Synthesis and Implementation**

   ```
   - Run Synthesis
   - Run Implementation
   - Generate Bitstream
   ```

4. **Programming**
   ```
   - Open Hardware Manager
   - Connect to target board
   - Program device with generated bitstream
   ```

## 🎮 Usage Instructions

### Initial Setup

1. After programming, the clock starts at 00:00
2. The display shows the current time in HH:MM format
3. Use the controls to set the correct time

### Setting Current Time

1. Press **BTNC** to enter clock adjustment mode (LED indicators will show mode)
2. Press **BTNR** to move to minute adjustment or **BTNL** to move to hour adjustment
3. Use **BTNU/BTND** to increment/decrement values
4. Press **BTNC** to return to display mode

### Setting Alarm

1. From display mode, press **BTNC** then navigate with **BTNL/BTNR** to alarm modes
2. LEDs 1-4 will indicate alarm adjustment mode
3. Use **BTNU/BTND** to set desired alarm time
4. Press **BTNC** to return to display mode

### Alarm Operation

- When current time matches alarm time, LED 0 blinks and buzzer sounds
- Press any button to dismiss the alarm
- Alarm automatically rearms for the next day

## ⚡ Technical Specifications

### Clock Frequencies

- System Clock: 100 MHz (Basys 3 onboard)
- Time Base: 1 Hz (for seconds counting)
- Button Sampling: 200 Hz (for debouncing)
- Display Refresh: ~200 Hz (for multiplexing)

### Resource Utilization

- Logic Cells: ~500 LUTs
- Flip-Flops: ~200 registers
- Block RAM: None
- DSP Slices: None

### Timing Constraints

- All paths meet timing at 100 MHz
- No critical warnings in implementation

## 🔬 Design Methodology

### State Machine Design

The main controller uses a Mealy finite state machine with the following states:

- `DISPLAY_CLOCK`: Normal time display
- `CLK_HOUR`: Hour adjustment mode
- `CLK_MIN`: Minute adjustment mode
- `ALARM_HOUR`: Alarm hour setting
- `ALARM_MIN`: Alarm minute setting
- `ALARM_MODE`: Active alarm state

### Button Processing Pipeline

1. **Mechanical Input**: Raw button signal
2. **Debouncing**: 3-stage shift register filter
3. **Synchronization**: 2-stage synchronizer for clock domain
4. **Edge Detection**: FSM generates single pulse per press

### Counter Hierarchy

- **Seconds Counter**: 0-59, enables minute counter at overflow
- **Minutes Counter**: 0-59, enables hour counter at overflow
- **Hours Counter**: 0-23, wraps to 0 after 23

## 🧪 Testing and Validation

### Functional Testing

- [x] Time counting accuracy verified
- [x] All button functions tested
- [x] Mode transitions confirmed
- [x] Alarm triggering validated
- [x] Display multiplexing verified

### Timing Analysis

- [x] Setup/hold times met
- [x] Clock domain crossings analyzed
- [x] No timing violations reported

## 👥 Authors

- **Adham Ali** - [adhamahmed804@aucegypt.edu](mailto:adhamahmed804@aucegypt.edu)
- **Omar Saqr** - [omar_saqr@aucegypt.edu](mailto:omar_saqr@aucegypt.edu)
- **Ebram Thabet** - [ebram_raafat@aucegypt.edu](mailto:ebram_raafat@aucegypt.edu)

## 📚 Course Information

**Course**: Digital Design  
**Project**: Project 2 - Digital Clock with Alarm  
**Institution**: American University in Cairo (AUC)  
**Academic Year**: 2024

## 📄 License

This project is developed for educational purposes as part of the Digital Design course curriculum.

## 🤝 Contributing

This is an academic project. For questions or suggestions, please contact the authors via email.

## 🔗 Additional Resources

- [Basys 3 Reference Manual](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual)
- [Xilinx Vivado Documentation](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_1/ug973-vivado-release-notes-install-license.pdf)
- [Verilog HDL Reference](https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/reference/glossary/def_verilog.htm)

---

**Note**: This README provides comprehensive information about the FPGA digital clock project. For detailed implementation specifics, refer to the individual Verilog source files and the project documentation in the `docs/` directory.
