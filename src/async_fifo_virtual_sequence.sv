class async_fifo_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(async_fifo_virtual_sequence)

  async_fifo_write_sequence write_sequence;
  async_fifo_read_sequence read_sequence;
 
  fifo_wsequence2 write_sequence2;
  fifo_rsequence2 read_sequence2;
  
  fifo_wsequence3 write_sequence3;
  fifo_rsequence3 read_sequence3;
  

  async_fifo_write_sequencer write_sequencer;
  async_fifo_read_sequencer read_sequencer;

  `uvm_declare_p_sequencer(async_fifo_virtual_sequencer)

  function new(string name = "async_fifo_virtual_sequence");
    super.new(name);
  endfunction: new

  task body();
    write_sequence = async_fifo_write_sequence::type_id::create("write_sequence");
    read_sequence = async_fifo_read_sequence::type_id::create("read_sequence");
    
    write_sequence2 = fifo_wsequence2::type_id::create("write_sequence2");
    read_sequence2 = fifo_rsequence2::type_id::create("read_sequence2");
    
    write_sequence3 = fifo_wsequence3::type_id::create("write_sequence3");
    read_sequence3 = fifo_rsequence3::type_id::create("read_sequence3");

    fork
        write_sequence.start(p_sequencer.write_sequencer);
     //   read_sequence.start(p_sequencer.read_sequencer);
    join
    
   /* fork
      begin
        write_sequence2.start(p_sequencer.write_sequencer);
        read_sequence2.start(p_sequencer.read_sequencer);
      end
    join
    
    fork
      begin
        write_sequence3.start(p_sequencer.write_sequencer);
        read_sequence3.start(p_sequencer.read_sequencer);
      end
    join*/
    
  endtask: body

endclass

