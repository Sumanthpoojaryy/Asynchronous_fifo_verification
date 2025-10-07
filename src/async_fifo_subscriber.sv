`uvm_analysis_imp_decl(_mon_read_cg)

class async_fifo_subscriber extends uvm_subscriber#(async_fifo_write_sequence_item);
  `uvm_component_utils(async_fifo_subscriber)

  async_fifo_write_sequence_item write_seq;
  async_fifo_read_sequence_item read_seq;

  real mon_read_val, mon_write_val;

  uvm_analysis_imp_mon_read_cg #(async_fifo_read_sequence_item, async_fifo_subscriber) read_cov_imp;


  covergroup mon_write_cov;
   // option.per_instance = 1;
    WDATA : coverpoint write_seq.wdata { bins wdata_vals[] = {[0:(1<<`DSIZE)-1]}; }
    WINC  : coverpoint write_seq.winc  { bins winc[] = {0,1}; }
    WFULL  : coverpoint write_seq.wfull { bins wfull[] = {0,1}; }

    WINC_X_WDATA:cross WINC, WDATA;
    endgroup

  covergroup mon_read_cov;
   // option.per_instance = 1;
    RDATA  : coverpoint read_seq.rdata { bins rdata_vals[] = {[0:(1<<`DSIZE)-1]}; }
    REMPTY : coverpoint read_seq.rempty { bins rempty[] = {0,1}; }
    RINC  : coverpoint read_seq.rinc  { bins rinc[] = {0,1}; }
    //cross RDATA, REMPTY;
  endgroup

  function new(string name="async_fifo_subscriber", uvm_component parent);
    super.new(name, parent);
    read_cov_imp = new("read_cov_imp", this);
    mon_write_cov= new();
    mon_read_cov = new();
  endfunction
  
  function void write(async_fifo_write_sequence_item t);
    write_seq = t;
    mon_write_cov.sample();
    `uvm_info(get_type_name(), $sformatf("COV[WRITE] WDATA=%0h, WINC=%0b WFULL=%0b", write_seq.wdata, write_seq.winc,write_seq.wfull), UVM_LOW);
  endfunction


  function void write_mon_read_cg(async_fifo_read_sequence_item t);
    read_seq = t;
    mon_read_cov.sample();
    `uvm_info(get_type_name(), $sformatf("COV[READ]RDATA=%0h , RINC=%0b,REMPTY=%0d", read_seq.rdata, read_seq.rinc, read_seq.rempty), UVM_LOW);
  endfunction

 
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    mon_read_val = mon_read_cov.get_coverage();
    mon_write_val = mon_write_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[COVERAGE] monitor read coverage = %0.2f%%", mon_read_val), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("[COVERAGE] Monitor write coverage = %0.2f%%", mon_write_val), UVM_MEDIUM);
  endfunction

endclass

