class async_fifo_read_sequence extends 
uvm_sequence#(async_fifo_read_sequence_item);
  `uvm_object_utils(async_fifo_read_sequence)

  async_fifo_read_sequence_item req;

  function new( string name = "async_fifo_read_sequence");
      super.new(name);
  endfunction: new

  task body();
      repeat(`no_of_transaction)begin
    req = async_fifo_read_sequence_item::type_id::create("req");
    wait_for_grant();
    req.randomize()with{req.rinc == 1;};
    send_request(req);
    wait_for_item_done();
end
  endtask: body

endclass 

class fifo_rsequence2 extends uvm_sequence#(async_fifo_read_sequence_item);
  `uvm_object_utils(fifo_rsequence2)

  async_fifo_read_sequence_item req;

  function new( string name = "fifo_rsequence2");
      super.new(name);
  endfunction: new

  task body();
     repeat(`no_of_transaction) begin
      req = async_fifo_read_sequence_item::type_id::create("req");
      `uvm_rand_send_with(req,{req.rinc == 1;})
     end
 endtask: body

endclass : fifo_rsequence2


class fifo_rsequence3 extends uvm_sequence#(async_fifo_read_sequence_item);
  `uvm_object_utils(fifo_rsequence3)

  async_fifo_read_sequence_item req;

  function new( string name = "fifo_rsequence3");
      super.new(name);
  endfunction: new

  task body();
     repeat(`no_of_transaction) begin
      req = async_fifo_read_sequence_item::type_id::create("req");
      `uvm_rand_send_with(req,{req.rinc == 0;})
     end
 endtask: body

endclass : fifo_rsequence3
