class async_fifo_write_sequence_item extends uvm_sequence_item;

  rand logic winc;
  rand logic [`DSIZE-1:0] wdata;
  logic wfull;

  `uvm_object_utils_begin(async_fifo_write_sequence_item)
  `uvm_field_int(wdata, UVM_ALL_ON ||UVM_DEC)
  `uvm_field_int(winc, UVM_ALL_ON || UVM_DEC)
  `uvm_field_int(wfull, UVM_ALL_ON || UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "async_fifo_write_sequence_item");
    super.new(name);
  endfunction

endclass

