// Testbench that makes Icarus Verilog emit mid-file $dumpall checkpoints.
//
// Build & run:
//   iverilog -o tb.vvp tb.v
//   vvp tb.vvp
// Produces icarus_dumpall.vcd
`timescale 1ns/1ns
module tb;
  reg clk = 0;
  reg [7:0] cnt = 0;

  always #5 clk = ~clk;            // posedges at 5, 15, 25, 35, ...

  always @(posedge clk) begin
    cnt <= cnt + 8'd1;             // NBA: lands after the checkpoint below
    if (cnt == 8'd3)               // old value read => fires at t=35
      $dumpall;                    // mid-timestep checkpoint
  end

  initial begin
    $dumpfile("icarus_dumpall.vcd");
    $dumpvars(0, tb);
    #52 $dumpall;                  // second checkpoint at a quiet time
    #28 $finish;                   // stop at t=80
  end
endmodule
