interface read_interface(input bit rclk,rrst_n);

  logic rinc;
  logic [`DSIZE-1:0] rdata;
  logic rempty;

  clocking read_drv_cb @(posedge rclk);
    default input #0 output #0;
    output  rinc;
  endclocking

  clocking read_mon_cb @(posedge rclk);
    default input #0 output #0;
    input  rinc, rdata, rempty;
  endclocking
  
  modport READ_DRV(clocking read_drv_cb, input rclk,rrst_n);

  modport READ_MON(clocking read_mon_cb, input rclk,rrst_n);


  //ASSERTION


   property rrst_check;
      @(posedge rclk) (!rrst_n) |-> (rempty && !rdata);
   endproperty

   property read_unknown;
      @(posedge rclk) disable iff(!rrst_n)
         (rinc && !rempty) |-> !$isunknown(rdata);
   endproperty

   assert property (rrst_check)
          else $info("rrst_check FAILED: rempty != 1 or rdata != 0 when rrst = 0");

   assert property(read_unknown)
          else $info("read_unknown FAILED: rdata is X/Z on valid read!");

endinterface

