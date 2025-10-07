class async_fifo_write_agent extends uvm_agent;
  `uvm_component_utils(async_fifo_write_agent)

  async_fifo_write_driver write_driver;
  async_fifo_write_monitor write_monitor;
  async_fifo_write_sequencer write_sequencer;

  function new(string name = "async_fifo_write_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_driver = async_fifo_write_driver::type_id::create("write_driver", this);
    write_monitor = async_fifo_write_monitor::type_id::create("write_monitor", this);
    write_sequencer = async_fifo_write_sequencer::type_id::create("write_sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    write_driver.seq_item_port.connect(write_sequencer.seq_item_export);
  endfunction
endclass


