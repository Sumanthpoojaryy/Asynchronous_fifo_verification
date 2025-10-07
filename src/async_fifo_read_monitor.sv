class async_fifo_read_monitor extends uvm_monitor;
  `uvm_component_utils(async_fifo_read_monitor)

  uvm_analysis_port #(async_fifo_read_sequence_item) read_monitor_port;
  async_fifo_read_sequence_item req;
  virtual read_interface rin;

  function new(string name = "asyc_read_monitor", uvm_component parent);
    super.new(name, parent);
    read_monitor_port = new("read_monitor_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual read_interface)::get(this, "", "read_inf", rin)) begin
      `uvm_info("RMON", "THE SET FAILED IN TOP", UVM_NONE)
    end
  endfunction

  task run_phase(uvm_phase phase);
    req = async_fifo_read_sequence_item::type_id::create("req");
    repeat(4)@(rin.read_mon_cb);
    forever begin
      repeat(1)@(rin.read_mon_cb);
      req.rinc = rin.rinc;
      req.rdata = rin.rdata;
      req.rempty = rin.rempty;
      req.print();
      read_monitor_port.write(req);
      repeat(1)@(rin.read_mon_cb);
    end
  endtask
endclass

