package async_fifo_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Sequence items
  `include "async_fifo_write_sequence_item.sv"
  `include "async_fifo_read_sequence_item.sv"

  // Sequences
  `include "async_fifo_write_sequence.sv"
  `include "async_fifo_read_sequence.sv"

  // Sequencers
  `include "async_fifo_write_sequencer.sv"
  `include "async_fifo_read_sequencer.sv"
  `include "async_fifo_virtual_sequencer.sv"   // 👈 must come before environment and virtual sequence

  // Drivers
  `include "async_fifo_write_driver.sv"
  `include "async_fifo_read_driver.sv"

  // Monitors
  `include "async_fifo_write_monitor.sv"
  `include "async_fifo_read_monitor.sv"

  // Agents
  `include "async_fifo_write_agent.sv"
  `include "async_fifo_read_agent.sv"

  // Scoreboard & Subscriber
  `include "async_fifo_scoreboard.sv"
  `include "async_fifo_subscriber.sv"

  // Environment
  `include "async_fifo_environment.sv"

  // Virtual sequence (needs environment + virtual sequencer)
  `include "async_fifo_virtual_sequence.sv"

  // Test
  `include "async_fifo_test.sv"
endpackage

