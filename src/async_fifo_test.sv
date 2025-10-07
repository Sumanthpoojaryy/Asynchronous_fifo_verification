class async_fifo_test extends uvm_test;
  `uvm_component_utils(async_fifo_test)

  async_fifo_virtual_sequence virtual_sequence;
  async_fifo_environment environment;

  function new(string name = "async_fifo_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    environment = async_fifo_environment::type_id::create("environment", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    virtual_sequence = async_fifo_virtual_sequence::type_id::create("virtual_sequence");
    //repeat(100)begin
    virtual_sequence.start(environment.virtual_sequencer);
    //end
    phase.drop_objection(this);
  endtask
endclass

