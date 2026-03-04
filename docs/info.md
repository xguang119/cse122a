<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

My project is a simple 4 operation ALU that operates on two 3-bit wide values, A and B.

input[5:3] is A
input[2:0] is B
input[7:6] contains the 2-bit opcode and selects the operation as follows:
2'b00: Addition (A+B)
2'b01: Subtraction (A-B)
2'b10: AND (A&B)
2'b11: OR (A|B)

## How to test

My testbench circulates through all possible combinations (2^8) and then compares output to expected results.
This simple design is sufficient as we only have an 8-bit input, thus it is trivial to test all possibilities.
It uses $fatal to immediately flag mistaches, and dumps the waveform to tb.fst for visualization.

To run the testbench, simply clone the repository, then run 'make -B' in cse122a/test .
If everything is good, it should print to the terminal "TESTS PASSED", and would also provide a .fst file to view.

## GenAI

While I wrote the ALU by hand, I described to ChatGPT my testbench and had some help writing it, as it's been awhile since I wrote one in CSE 125.

