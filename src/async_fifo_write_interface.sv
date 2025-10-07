`include "async_fifo_defines.sv"
interface write_interface(input bit wclk,wrst_n);

  logic winc;
  logic [`DSIZE-1:0] wdata;
  logic wfull;

  clocking write_drv_cb @(posedge wclk);
    default input #0 output #0;
    output  winc, wdata;
  endclocking

  clocking write_mon_cb @(posedge wclk);
    default input #0 output #0;
    input wfull,winc, wdata;
  endclocking
  
  modport WRITE_DRV(clocking write_drv_cb, input wclk,wrst_n);

  modport WRITE_MON(clocking write_mon_cb, input wclk,wrst_n);
  
  property wrst_check;
       @(posedge wclk) (!wrst_n) |-> !wfull;
  endproperty

  property write_unknown;
        @(posedge wclk) disable iff(!wrst_n)
        (winc) |->!$isunknown(wdata);
  endproperty

  assert property (wrst_check)
         else $info("wrst_check FAILED: wfull is not 0 when wrst = 0");

  assert property(write_unknown)
         else $info("write_unknown FAILED: wdata is X/Z on valid write!");
endinterface


