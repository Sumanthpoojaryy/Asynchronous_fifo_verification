class async_fifo_environment extends uvm_env;
  `uvm_component_utils(async_fifo_environment)

  async_fifo_write_agent write_agent;
  async_fifo_read_agent read_agent;
  async_fifo_virtual_sequencer virtual_sequencer;
  async_fifo_scoreboard scoreboard;
  async_fifo_subscriber subscriber;

  function new(string name = "async_fifo_environment", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_agent = async_fifo_write_agent::type_id::create("write_agent",this);
    read_agent = async_fifo_read_agent::type_id::create("read_agent",this);
    scoreboard = async_fifo_scoreboard::type_id::create("scoreboard",this);
    subscriber = async_fifo_subscriber::type_id::create("subscriber",this);
    virtual_sequencer = async_fifo_virtual_sequencer::type_id::create("virtual_sequencer", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    write_agent.write_monitor.write_monitor_port.connect(scoreboard.write_scb_imp.analysis_export);
    read_agent.read_monitor.read_monitor_port.connect(scoreboard.read_scb_imp.analysis_export);
    write_agent.write_monitor.write_monitor_port.connect(subscriber.analysis_export);
    read_agent.read_monitor.read_monitor_port.connect(subscriber.read_cov_imp);
    
    virtual_sequencer.write_sequencer = write_agent.write_sequencer;
    virtual_sequencer.read_sequencer = read_agent.read_sequencer;
  endfunction: connect_phase

endclass


