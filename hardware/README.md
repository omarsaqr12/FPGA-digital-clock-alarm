# Hardware file map

The maintained-for-review source copy is [`verilog_sources/`](verilog_sources/). Add its ten `.v` files **only**; the nested original `DigitalDesign_Project 2/` tree at the repository root contains alternate definitions of the same modules. The selected top is `digital_clock_top`.

- `digital_clock_top.v`: state/mode control, alarm match, display and buzzer output.
- `clock_counter.v`, `alarm_counter.v`, `counter_x_bit.v`: time and alarm storage.
- `clock_divider.v`: counters generating approximately 1 Hz and 200 Hz clocks from a 100 MHz input.
- `push_button_detector.v`, `debouncer.v`, `synchronizer.v`, `fsm.v`: button processing and pulse detection.
- `seven_segment_display.v`: four-digit active-low display selection and decoding.
- `constraints/basys3_constraints.xdc`: board pin assignments, **not a completed signoff report**.

The top-level RTL has known verification gaps: internally generated/multiplexed clocks, an unused `enable` input, and `buzz_en` driven at the alarm LED blink frequency rather than by a tone generator. Do not treat the original README's resource estimates or timing checkboxes as reproduced results. See the [root README](../README.md) for simulation commands and validation scope; historical prose is archived at [`docs/hardware_README_original_2025.md`](../docs/hardware_README_original_2025.md).
