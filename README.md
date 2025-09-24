# Traffic Light Controller — ARMv7 (DE1-SoC cpulator)

A minimal ARMv7 assembly program that controls a 4-way traffic junction on the DE1-SoC simulator.  
It drives six LEDs (NS/EW: Red, Yellow, Green) and displays the *remaining time (MM:SS)* on the HEX 7-segment.

---

## Features

- Looping cycle:
  1. *NS RED / EW GREEN* — *2:30*
  2. *All YELLOW* — *0:30*
  3. *EW RED / NS GREEN* — *2:30*
  4. *All YELLOW* — *0:30*
- HEX countdown: MM:SS (minutes on HEX5-4, seconds on HEX1-0).

---

## I/O Mapping

| Device  | Address       | Usage                                                                 |
|---------|---------------|-----------------------------------------------------------------------|
| LEDR    | 0xFF200000  | Bits [0..5] = NS_R, NS_Y, NS_G, EW_R, EW_Y, EW_G                   |
| HEX3_0  | 0xFF200020  | HEX3..HEX0 (HEX1 = Sec10, HEX0 = Sec1, HEX2/HEX3 blank)          |
| HEX5_4  | 0xFF200030  | HEX5..HEX4 (HEX5 = Min10, HEX4 = Min1)                           |
