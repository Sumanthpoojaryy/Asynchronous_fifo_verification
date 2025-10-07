class async_fifo_read_sequence_item extends uvm_sequence_item;

  rand logic rinc;
  logic [`DSIZE-1:0] rdata;
  logic rempty;

  `uvm_object_utils_begin(async_fifo_read_sequence_item)
  `uvm_field_int(rinc, UVM_ALL_ON || UVM_DEC)
  `uvm_field_int(rdata, UVM_ALL_ON || UVM_DEC)
  `uvm_field_int(rempty, UVM_ALL_ON || UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "async_fifo_read_sequence_item");
    super.new(name);
  endfunction

endclass

