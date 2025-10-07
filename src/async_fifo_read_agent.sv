class async_fifo_read_agent extends uvm_agent;
  `uvm_component_utils(async_fifo_read_agent)

  async_fifo_read_driver read_driver;
  async_fifo_read_monitor read_monitor;
  async_fifo_read_sequencer read_sequencer;

  function new(string name = "async_fifo_read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    read_driver = async_fifo_read_driver::type_id::create("read_driver", this);
    read_monitor = async_fifo_read_monitor::type_id::create("read_monitor", this);
    read_sequencer = async_fifo_read_sequencer::type_id::create("read_sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    read_driver.seq_item_port.connect(read_sequencer.seq_item_export);
  endfunction
endclass
