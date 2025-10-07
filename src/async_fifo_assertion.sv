interface async_fifo_assertion(
    input logic wclk,
    input logic rclk,
    input logic wrst_n,
    input logic rrst_n,
    input logic [`DSIZE -1:0]wdata,
    input logic [`DSIZE -1:0]rdata,
    input logic wfull,
    input logic rempty,
    input logic winc,
    input logic rinc
);

//===================ASSERTION=======================
property wrst_check;
         @(posedge wclk) (!wrst_n) |-> !wfull;
    endproperty


    property rrst_check;
         @(posedge rclk) (!rrst_n) |-> (rempty && !rdata);
    endproperty


    property full_and_empty;
      @(posedge wclk) disable iff(!wrst_n)
      !(wfull && rempty);
    endproperty

    property read_unknown;
      @(posedge rclk) disable iff(!rrst_n)
      (rinc && !rempty) |-> !$isunknown(rdata);
    endproperty

    property write_unknown;
      @(posedge wclk) disable iff(!wrst_n)
      (rinc) |->!$isunknown(wdata);
    endproperty



        
    assert property (wrst_check)
       else $info("wrst_check FAILED: wfull is not 0 when wrst = 0");

    assert property (rrst_check)
       else $info("rrst_check FAILED: rempty != 1 or rdata != 0 when rrst = 0");
      
    assert property(full_and_empty)
       else $info(" full and empty FAILED: FIFO signaled FULL and EMPTY simultaneously!");

    assert property(read_unknown)
       else $info("read_unknown FAILED: rdata is X/Z on valid read!");

    assert property(write_unknown)
       else $info("write_unknown FAILED: wdata is X/Z on valid write!");

endinterface
