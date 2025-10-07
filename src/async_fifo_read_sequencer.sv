class async_fifo_read_sequencer extends uvm_sequencer#(async_fifo_read_sequence_item);
  `uvm_component_utils(async_fifo_read_sequencer)

  function new(string name = "async_fifo_read_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass
  
