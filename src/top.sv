`include "async_fifo_defines.sv"
`include "uvm_macros.svh"
`include "async_fifo_write_interface.sv"
`include "async_fifo_read_interface.sv"
`include "FIFO.v"
`include "rptr_empty.v"
`include "async_fifo_pkg.sv"
`include "two_ff_sync.v"
`include "FIFO_memory.v"
`include "wptr_full.v"
module top;
  import uvm_pkg::*;
  import async_fifo_pkg::*;

  bit wclk;
  bit rclk;
  bit rrst_n;
  bit wrst_n;

  write_interface wr_intf(wclk,wrst_n);
  read_interface rd_intf(rclk,rrst_n);

  FIFO dut(.rdata(rd_intf.rdata), .wfull(wr_intf.wfull), .rempty(rd_intf.rempty), .wdata(wr_intf.wdata), .winc(wr_intf.winc), .wclk(wclk), .wrst_n(wrst_n), .rinc(rd_intf.rinc), .rclk(rclk), .rrst_n(rrst_n));



  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;

  initial begin
    #20;
    rrst_n = 1;
    #20;
    wrst_n = 1;

  end
  initial begin
    uvm_config_db#(virtual write_interface)::set(null, "*", "write_inf",wr_intf);
    uvm_config_db#(virtual read_interface)::set(null, "*", "read_inf",rd_intf);
    run_test("async_fifo_test");
  end

endmodule
