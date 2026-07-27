`ifndef FIFO_PKG_SV
`define FIFO_PKG_SV

package fifo_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "fifo_if.sv"
  `include "fifo_seq_item.sv"
  `include "fifo_seq_pkg.sv" 
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_agent.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_env.sv"
  `include "fifo_base_test.sv"
endpackage : fifo_pkg

`endif // FIFO_PKG_SV
