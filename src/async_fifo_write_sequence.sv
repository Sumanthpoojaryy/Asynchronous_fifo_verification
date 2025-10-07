class async_fifo_write_sequence extends uvm_sequence#(async_fifo_write_sequence_item);
  `uvm_object_utils(async_fifo_write_sequence)

  async_fifo_write_sequence_item req;

  function new( string name = "async_fifo_write_sequence");
      super.new(name);
  endfunction: new

  task body();
    repeat(`no_of_transaction)begin
    req = async_fifo_write_sequence_item::type_id::create("req");
    wait_for_grant();
    req.randomize()with{req.winc == 1;};
    send_request(req);
    wait_for_item_done();
    end
  endtask: body
endclass 


class fifo_wsequence2 extends uvm_sequence#(async_fifo_write_sequence_item);
  `uvm_object_utils(fifo_wsequence2)

  async_fifo_write_sequence_item req;

  function new( string name = "fifo_wsequence2");
    super.new(name);
  endfunction: new

  task body();
   repeat(`no_of_transaction) begin
      req = async_fifo_write_sequence_item::type_id::create("req");
      `uvm_rand_send_with(req, {req.winc == 0;})
     end
  endtask: body

endclass

class fifo_wsequence3 extends uvm_sequence#(async_fifo_write_sequence_item);
  `uvm_object_utils(fifo_wsequence3)

  async_fifo_write_sequence_item req;
  function new( string name = "fifo_wsequence3");
      super.new(name);
  endfunction: new

  task body();
     repeat(`no_of_transaction) begin
      req = async_fifo_write_sequence_item::type_id::create("req");
      `uvm_rand_send_with(req, {req.winc == 1;})
     end
  endtask: body
endclass : fifo_wsequence3




