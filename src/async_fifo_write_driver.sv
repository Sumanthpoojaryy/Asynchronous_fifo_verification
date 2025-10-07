class async_fifo_write_driver extends uvm_driver#(async_fifo_write_sequence_item);
  `uvm_component_utils(async_fifo_write_driver)

  virtual write_interface win;

  function new(string name = "async_fifo_write_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual write_interface)::get(this, "", "write_inf", win)) begin
      `uvm_info("WDRV", "THE SET IS FAILED IN TOP", UVM_NONE)
    end
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    repeat(3)@(win.write_drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      w_drive();
      seq_item_port.item_done();
    end
  endtask: run_phase

  task w_drive();
    $display("-----------------------------write driver driving @%0t-------------------------",$time);
      win.winc <= req.winc;
      win.wdata <= req.wdata;
     req.print();
    repeat(2)@(win.write_drv_cb);
  endtask: w_drive

endclass



