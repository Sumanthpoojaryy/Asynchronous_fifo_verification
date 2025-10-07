`include "uvm_macros.svh"
`include "async_fifo_defines.sv"

class async_fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(async_fifo_scoreboard)

  // TLM FIFOs for receiving transactions from monitors
  uvm_tlm_analysis_fifo#(async_fifo_write_sequence_item)  write_scb_imp;
  uvm_tlm_analysis_fifo#(async_fifo_read_sequence_item)   read_scb_imp;

  async_fifo_write_sequence_item wr_seq_item;
  async_fifo_read_sequence_item  rd_seq_item;

  // ----------------------------
  // Queue-based FIFO model
  // ----------------------------
  bit [`DSIZE-1:0] fifo_q[$];   // dynamic queue acts as FIFO
  int depth = `DEPTH;
  bit [`DSIZE-1:0] exp_data;

  int pass_count, fail_count;

  function new(string name = "async_fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    write_scb_imp = new("write_scb_imp", this);
    read_scb_imp  = new("read_scb_imp",  this);
    pass_count = 0;
    fail_count = 0;
  endfunction


  // ----------------------------
  // WRITE side processing
  // ----------------------------
  task wr_scb();
    forever begin
      write_scb_imp.get(wr_seq_item);

      `uvm_info("SCOREBOARD",
        $sformatf("WRITE Monitor data received @%0t: winc=%0b wdata=%0h wfull=%0b",
                   $time, wr_seq_item.winc, wr_seq_item.wdata, wr_seq_item.wfull),
        UVM_LOW);

      if (wr_seq_item.winc) begin
        if (fifo_q.size() == depth) begin
          if (!wr_seq_item.wfull) begin
            `uvm_error("SCOREBOARD", "DUT did NOT assert wfull when FIFO was full");
          end 
          else begin
            `uvm_info("SCOREBOARD", "WRITE blocked due to FIFO FULL (as expected)", UVM_LOW);
          end
        end 
        else begin
          if (wr_seq_item.wfull) begin
            `uvm_error("SCOREBOARD", "DUT asserted wfull before FIFO is actually full");
          end 
          if (fifo_q.size() != depth) begin
            fifo_q.push_back(wr_seq_item.wdata);
            `uvm_info("SCOREBOARD",
              $sformatf("WRITE: Stored %0h (count=%0d)", wr_seq_item.wdata, fifo_q.size()),
              UVM_MEDIUM);
          end
        end
      end
    end
  endtask


  // ----------------------------
  // READ side processing
  // ----------------------------
  task rd_scb();
    forever begin
      read_scb_imp.get(rd_seq_item);

      `uvm_info("SCOREBOARD",
        $sformatf("READ Monitor data received @%0t: rinc=%0b rdata=%0h rempty=%0b",
                   $time, rd_seq_item.rinc, rd_seq_item.rdata, rd_seq_item.rempty),
        UVM_LOW);

      if (rd_seq_item.rinc) begin
        if (fifo_q.size() == 0) begin
          if (!rd_seq_item.rempty) begin
            `uvm_error("SCOREBOARD", "DUT did NOT assert rempty when FIFO was empty");
          end 
          else begin
            `uvm_info("SCOREBOARD", "READ blocked due to FIFO EMPTY (as expected)", UVM_LOW);
          end
        end 
        else begin
          if (rd_seq_item.rempty) begin
            `uvm_error("SCOREBOARD", "DUT asserted rempty before FIFO is actually empty");
          end 
          if (fifo_q.size() != 0) begin
            exp_data = fifo_q.pop_front(); // FIFO order
            if (exp_data == rd_seq_item.rdata) begin
              pass_count++;
              `uvm_info("SCOREBOARD",
                $sformatf("PASS: rdata=%0h matched expected=%0h | count=%0d",
                          rd_seq_item.rdata, exp_data, fifo_q.size()),
                UVM_MEDIUM);
            end 
            else begin
              fail_count++;
              `uvm_error("SCOREBOARD",
                $sformatf("FAIL: rdata=%0h != expected=%0h | count=%0d",
                          rd_seq_item.rdata, exp_data, fifo_q.size()));
            end
          end
        end
      end
    end
  endtask


  // ----------------------------
  // RUN PHASE
  // ----------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    fork
      wr_scb();
      rd_scb();
    join_none
  endtask


  // ----------------------------
  // REPORT PHASE
  // ----------------------------
  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD",
      $sformatf("Final Results: PASS=%0d | FAIL=%0d", pass_count, fail_count),
      UVM_NONE)
  endfunction

endclass

