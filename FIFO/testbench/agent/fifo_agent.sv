`ifndef FIFO_AGENT_SV
`define FIFO_AGENT_SV

class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)
  fifo_driver driver;
  fifo_sequencer sequencer;
  fifo_monitor   monitor;

  function new(string name = "fifo_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = fifo_monitor::type_id::create ("monitor", this);

    if (get_is_active() == UVM_ACTIVE) begin
      driver = fifo_driver::type_id::create("driver", this);
      sequencer = fifo_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  virtual function connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass
`endif
