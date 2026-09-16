# FPGA digital clock & alarm

**Verilog · Digilent Basys 3 (Artix-7) · Digital Design course project**  
[![RTL focused smoke tests](https://github.com/omarsaqr12/FPGA-digital-clock-alarm/actions/workflows/rtl-smoke.yml/badge.svg?branch=main)](https://github.com/omarsaqr12/FPGA-digital-clock-alarm/actions/workflows/rtl-smoke.yml)

A 24-hour clock and configurable alarm **RTL design** targeting the Basys 3 FPGA. It combines cascaded time counters, a button-driven mode controller, alarm-time storage, and a multiplexed four-digit seven-segment display. Developed collaboratively by **Adham Ali, Omar Saqr, and Ebram Thabet** at the American University in Cairo.

**What is verified:** the maintained RTL elaborates with Icarus Verilog, and focused display and modulo-counter regressions pass in [GitHub Actions](https://github.com/omarsaqr12/FPGA-digital-clock-alarm/actions/workflows/rtl-smoke.yml). **What is not verified here:** complete alarm behavior, FPGA board operation, synthesis utilization, and timing closure. The original course artifacts are preserved separately.

## Design at a glance

```text
100 MHz board clock ──> clock dividers ──> time base / button & display sampling
                                                    │
Buttons ──> input filtering & pulse detection ──> mode controller
                                                    │
                               time counter <───────┤──────> alarm counter
                                      │             │              │
                                      └──────> display selection <─┘
                                                     │
                                             four-digit 7-segment

                      time = alarm ──> alarm mode ──> LED / buzz_en
```

| Engineering area | Start with | Implementation |
| --- | --- | --- |
| Controller & alarm match | [`digital_clock_top.v`](hardware/verilog_sources/digital_clock_top.v) | Mode transitions, button actions, display selection and alarm outputs |
| Timekeeping | [`clock_counter.v`](hardware/verilog_sources/clock_counter.v) · [`counter_x_bit.v`](hardware/verilog_sources/counter_x_bit.v) | Cascaded modulo-60 seconds/minutes and modulo-24 hours |
| Alarm storage | [`alarm_counter.v`](hardware/verilog_sources/alarm_counter.v) | Independently adjustable hours and minutes |
| User interface | [`push_button_detector.v`](hardware/verilog_sources/push_button_detector.v) · [`seven_segment_display.v`](hardware/verilog_sources/seven_segment_display.v) | Button conditioning/one-pulse detection and active-low digit multiplexing |

See the [hardware file map](hardware/README.md) for the remaining modules and the [Basys 3 pin constraints](hardware/constraints/basys3_constraints.xdc). The [original course report](DD1_Project2_Report.pdf), [state-machine diagram](ASM.pdf), [datapath/control diagram](%28DP%20CU%29%20Diagram.png), and [Logisim circuit](final_logisim.circ) are retained as historical design material, **not newly validated test evidence**.

## Run the focused RTL checks

Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog` and `vvp`), then run from the repository root:

```bash
# Compile/elaborate the maintained top-level RTL.
iverilog -g2012 -s digital_clock_top -o /tmp/clock_top.vvp hardware/verilog_sources/*.v

# Display decoding and response to changes on the selected digit.
iverilog -g2012 -s tb_seven_segment_display -o /tmp/display.vvp \
  simulation/tb_seven_segment_display.v hardware/verilog_sources/seven_segment_display.v
vvp /tmp/display.vvp

# Counter wraparound, direction, and enable behavior.
iverilog -g2012 -s tb_counter_x_bit -o /tmp/counter.vvp \
  simulation/tb_counter_x_bit.v hardware/verilog_sources/counter_x_bit.v
vvp /tmp/counter.vvp
```

The same checks run in [CI](.github/workflows/rtl-smoke.yml). They do **not** exercise a full 24-hour run, button-driven alarm sequence, or a programmed board.

### Vivado project setup

Create an RTL project for `xc7a35tcpg236-1`; add **only** `hardware/verilog_sources/*.v`, set `digital_clock_top` as top, and add [`hardware/constraints/basys3_constraints.xdc`](hardware/constraints/basys3_constraints.xdc). The separate [`DigitalDesign_Project 2/`](DigitalDesign_Project%202/) folder is an original Vivado-era source snapshot with overlapping module definitions: do **not** compile both source trees together. The constraints map reset to SW0 and an `enable` input to SW1, but the current top-level RTL does not use `enable`.

## Known engineering limits

- The design divides and selects internally generated clocks; safe clock switching, generated-clock constraints, and clock-domain timing require a dedicated review before claiming timing closure.
- `buzz_en` follows the alarm LED's approximately 1 Hz blink, **not** a verified audio-frequency tone generator. Do not assume a passive buzzer produces an audible alarm.
- Full alarm-state regressions, synthesis/timing reports, and physical Basys 3 bring-up have not been independently reproduced in this review. Historical utilization estimates and testing claims are archived in the [original README](docs/README_original_2025.md), not presented as new measurements.

**Provenance:** This is a three-person course project; the repository does not establish individual module ownership. The [original RTL snapshot](DigitalDesign_Project%202/) and [original documentation](docs/) remain available. No explicit reuse license is provided in this repository.
