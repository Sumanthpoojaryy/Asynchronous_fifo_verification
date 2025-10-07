class async_fifo_write_monitor extends uvm_monitor;
  `uvm_component_utils(async_fifo_write_monitor)

  uvm_analysis_port #(async_fifo_write_sequence_item) write_monitor_port;
  async_fifo_write_sequence_item req;
  virtual write_interface win;

  function new(string name = "async_fifo_write_monitor", uvm_component parent);
    super.new(name, parent);
    write_monitor_port = new("write_monitor_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual write_interface)::get(this, "", "write_inf", win)) begin
      `uvm_info("WMON", "THE SET FAILED IN TOP", UVM_NONE)
    end
  endfunction

  task run_phase(uvm_phase phase);
    req = async_fifo_write_sequence_item::type_id::create("req");
    repeat(4)@(win.write_mon_cb);
    forever begin
      repeat(1)@(win.write_mon_cb);
      req.winc = win.winc;
      req.wdata = win.wdata;
      req.wfull = win.wfull;
      write_monitor_port.write(req);
      req.print();
      repeat(1)@(win.write_mon_cb);
    end
  endtask
endclass


