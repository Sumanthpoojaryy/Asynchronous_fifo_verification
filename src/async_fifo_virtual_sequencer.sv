class async_fifo_virtual_sequencer extends uvm_sequencer;

  async_fifo_write_sequencer write_sequencer;
  async_fifo_read_sequencer read_sequencer;

  `uvm_component_utils(async_fifo_virtual_sequencer)

  function new(string name = "async_fifo_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass

