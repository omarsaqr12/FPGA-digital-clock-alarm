# FPGA digital clock and alarm (Basys 3)

A **three-person Digital Design course project** implementing a 24-hour clock and configurable alarm in Verilog for the Digilent Basys 3 (Artix-7). The design contains time and alarm counters, button input processing, a mode controller, and a multiplexed four-digit seven-segment display. This repository preserves both the original Vivado-era sources and a separately organized RTL copy. **Physical-board operation and timing closure have not been independently reverified for this review.**

## What to inspect first

| Area | Source | What it does |
| --- | --- | --- |
| Top-level control | [`digital_clock_top.v`](hardware/verilog_sources/digital_clock_top.v) | Mode selection, display routing, alarm comparison, LED and buzzer output |
| Timekeeping | [`clock_counter.v`](hardware/verilog_sources/clock_counter.v), [`counter_x_bit.v`](hardware/verilog_sources/counter_x_bit.v) | Cascaded seconds/minutes/hours and wraparound |
| Alarm setting | [`alarm_counter.v`](hardware/verilog_sources/alarm_counter.v) | Separate 24-hour alarm registers |
| Inputs | [`push_button_detector.v`](hardware/verilog_sources/push_button_detector.v), [`debouncer.v`](hardware/verilog_sources/debouncer.v), [`synchronizer.v`](hardware/verilog_sources/synchronizer.v), [`fsm.v`](hardware/verilog_sources/fsm.v) | Sampling, filtering, synchronization and one-pulse detection |
| Display and board | [`seven_segment_display.v`](hardware/verilog_sources/seven_segment_display.v), [`basys3_constraints.xdc`](hardware/constraints/basys3_constraints.xdc) | Digit multiplexing, segment patterns and pin assignments |
| Design artifacts | [`DD1_Project2_Report.pdf`](DD1_Project2_Report.pdf), [`ASM.pdf`](ASM.pdf), [`final_logisim.circ`](final_logisim.circ) | Original course report, state diagram and Logisim circuit (not independently audited here) |

The **working-copy source set** is `hardware/verilog_sources/`. The nested [`DigitalDesign_Project 2/`](DigitalDesign_Project%202/) directory is a preserved, differently named original source snapshot; do **not** add both trees to one Vivado or Icarus project because they define overlapping modules. The original documentation is retained under [`docs/`](docs/), explicitly as historical material rather than verified test evidence.

## Explore or simulate

You need a Verilog simulator such as Icarus Verilog (`iverilog` and `vvp`), or Vivado for synthesis and board programming. From the repository root:

```bash
# Check the canonical RTL elaborates; this does not establish board timing.
iverilog -g2012 -s digital_clock_top -o /tmp/digital_clock_top.vvp hardware/verilog_sources/*.v

# Run focused regression tests for a changing display input and counter wraparound.
iverilog -g2012 -s tb_seven_segment_display -o /tmp/tb_display.vvp \
  simulation/tb_seven_segment_display.v hardware/verilog_sources/seven_segment_display.v
vvp /tmp/tb_display.vvp
iverilog -g2012 -s tb_counter_x_bit -o /tmp/tb_counter.vvp \
  simulation/tb_counter_x_bit.v hardware/verilog_sources/counter_x_bit.v
vvp /tmp/tb_counter.vvp
```

These **focused tests are not a system-level alarm or FPGA test**. The repository still needs a top-level testbench covering mode transitions, midnight rollover, setting time and alarm, dismissal, and generated-clock transitions.

For the board, create a Vivado RTL project targeting **xc7a35tcpg236-1**; add only `hardware/verilog_sources/*.v`, choose `digital_clock_top` as top, and add [`hardware/constraints/basys3_constraints.xdc`](hardware/constraints/basys3_constraints.xdc). Inspect generated-clock constraints and timing reports before programming. Reset is mapped to SW0 and `enable` to SW1; **`enable` is declared but not used in the current top-level RTL**, so SW1 does not pause the clock. See the original report for the intended controls and compare them with the actual RTL.

## Engineering limitations and evidence

- The counter implements 0–59 seconds and minutes and 0–23 hours, with separate alarm registers. This is an implementation observation, **not** an independently executed 24-hour accuracy test.
- The output called `buzz_en` follows the approximately **1 Hz** alarm LED signal (`LD[0]`); there is no audio-frequency tone generator in the reviewed top-level implementation. An attached passive buzzer should **not** be advertised as a validated audible alarm.
- The 100 MHz input is divided using flip-flop logic into approximately 200 Hz and 1 Hz clocks, and a combinational selector switches the clock-counter input between them. This requires generated-clock/timing and glitch/CDC investigation before asserting safe hardware timing. The board constraint file does not itself prove setup/hold closure.
- No synthesis utilization, routed timing reports, bitstream, or board validation logs are included in the reviewed RTL tree. Prior README estimates and unchecked testing checkboxes are preserved only in historical documentation.
- The regression tests added in this review target two small components. They have not been run locally where a Verilog simulator is unavailable; see the PR checks for any CI results.

## Contributors and provenance

This was a collaborative course project by **Adham Ali, Omar Saqr, and Ebram Thabet**. All three are credited in the RTL headers. The repository history identifies the collaborators as [AdhamALI68](https://github.com/AdhamALI68) and [BeTechBo](https://github.com/BeTechBo); consult the original history for versions and attribution. Individual module ownership has not been established from the available records, so none is claimed here. The original report and sources remain unmodified.

This repository does not contain an explicit software license. Course-project provenance does not by itself grant redistribution or commercial-use rights.
