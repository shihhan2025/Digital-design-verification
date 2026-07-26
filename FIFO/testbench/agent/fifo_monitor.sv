`ifndef FIFO_MONITOR_SV
`define FIFO_MONITOR_SV

class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if vif;
  uvm_analysis_port #(fifo_seq_item) ap;

  function new(string name = "fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "COuld not get virtual interface fifo_if from config_db");
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    wait (vif.rst_n == 1'b1)
    `uvm_info("MON", "Reset de-asserted, monitor starting...", UVM_LOW)
    fork 
      sample_interface();
    join
  endtask

  task sample_interface();
    fifo_seq_item tr;
    forever begin
      @(posedge vif.clk);
      if(!vif.rst_n)
        continue;
      tr = fifo_seq_item::type_id::create("tr");
      tr.wr_en   = vif.wr_en;
      tr.rd_en   = vif.rd_en;
      tr.data_in = vif.data_in;
      tr.full    = vif.full;
      tr.empty   = vif.empty;
      if(tr.rd_en && !tr.empty) begin
        @(posedge vif.clk);
        tr.data_out = vif.data_out;
      end
      ap.write(tr);
      
    end
  endtask
  
endclass

`endif
