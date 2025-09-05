# Hardware Implementation

This directory contains all the hardware-related files for the FPGA Digital Clock with Alarm project.

## Directory Structure

### `verilog_sources/`

Contains all Verilog HDL source files:

- **`digital_clock_top.v`** - Top-level module and main system controller
- **`clock_counter.v`** - Real-time clock counter with seconds, minutes, and hours
- **`alarm_counter.v`** - Alarm time storage and adjustment logic
- **`clock_divider.v`** - Clock frequency divider for generating 1Hz and 200Hz clocks
- **`seven_segment_display.v`** - 7-segment display driver with multiplexing
- **`counter_x_bit.v`** - Generic parameterizable counter module
- **`push_button_detector.v`** - Button input processing pipeline
- **`debouncer.v`** - Hardware debouncing using shift registers
- **`synchronizer.v`** - Clock domain crossing synchronizer
- **`fsm.v`** - Finite state machine for button edge detection

### `constraints/`

Contains FPGA pin assignment and timing constraint files:

- **`basys3_constraints.xdc`** - Pin assignments for Basys 3 FPGA board

## Module Hierarchy

```
digital_clock_top
├── clockDivider (1Hz clock)
├── clockDivider (200Hz clock)
├── Clock_Counter
│   ├── counter_x_bit (seconds)
│   ├── counter_x_bit (minutes)
│   └── counter_x_bit (hours)
├── Alarm_Counter
│   ├── counter_x_bit (minutes)
│   └── counter_x_bit (hours)
├── Push_buttondetector (x5)
│   ├── debouncer
│   ├── synchronizer
│   └── fsm
├── counter_x_bit (display mux)
└── seven_segment_display
```

## Key Design Features

### Parameterizable Counters

The `counter_x_bit` module is highly reusable with configurable width and maximum count values:

```verilog
counter_x_bit #(6, 60) seconds_counter  // 6-bit counter, max 60
counter_x_bit #(5, 24) hours_counter    // 5-bit counter, max 24
```

### Robust Button Processing

Multi-stage button processing ensures reliable input:

1. Mechanical debouncing (3 flip-flops)
2. Clock domain synchronization (2 flip-flops)
3. Edge detection (3-state FSM)

### Clock Domain Management

- System operates at 100MHz (Basys 3 onboard clock)
- 1Hz clock drives time counting logic
- 200Hz clock drives button sampling and display refresh

### State Machine Architecture

Main FSM coordinates all system operations:

- 6 distinct states for different operating modes
- Mealy machine implementation for responsive control
- LED indicators provide visual feedback for current state

## Resource Utilization

Estimated resource usage on Basys 3 (XC7A35T):

- **LUTs**: ~500 (3% utilization)
- **Registers**: ~200 (1% utilization)
- **Block RAM**: 0
- **DSP Slices**: 0

## Timing Performance

All timing requirements met at 100MHz system clock:

- **Setup Time**: All paths have positive slack
- **Hold Time**: No violations
- **Clock Skew**: Within acceptable limits
- **Jitter**: Minimal impact on system operation
