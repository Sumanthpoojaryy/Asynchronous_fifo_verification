class async_fifo_read_driver extends uvm_driver#(async_fifo_read_sequence_item);
  `uvm_component_utils(async_fifo_read_driver)

  virtual read_interface rin;

  function new(string name = "async_fifo_read_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual read_interface)::get(this, "", "read_inf", rin)) begin
      `uvm_info("RDRV", "THE SET IS FAILED IN TOP", UVM_NONE)
    end
  endfunction: build_phase

  task run_phase(uvm_phase phase);
   // repeat(3)@(rin.read_drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      r_drive();
      seq_item_port.item_done();
    end
  endtask: run_phase

  task r_drive();
    repeat(1)@(rin.read_drv_cb);  
    $display("-----------------------------read driver driving @%0t-------------------------",$time);
      rin.rinc <= req.rinc;
      req.print();
   // repeat(2)@(rin.read_drv_cb);
   endtask: r_drive

endclass

