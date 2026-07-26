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

  virtual task sample_interface();
    fifo_seq_item tr;

    forever begin
      @(posedge vif.clk)
      if (!vif.rst_n) continue;

      if (vif.wr_en && !vif.full) begin
        tr = fifo_seq_item::type_id::create("tr");
        tr.wr_en = vif.wr_en;
        tr.rd_en = vif.rd_en;
        tr.data_in = vif.data_in;
        
        `uvm_info("MON_WR", $sformatf("Sampled Write: data_in = 0x%0h", tr.data_in), UVM_HIGH)
        ap.write(tr);
      end

      if (vif.rd_en && !vif.empty) begin
        tr = fifo_seq_item::type_id::create("tr");
        tr.wr_en = vif.wr_en;
        tr.rd_en = vif.rd_en;

        fork 
          automatic fifo_seq_item rd_tr = tr;
          begin
            @(posedge vif.clk);
            rd_tr.data_out = vif.data_out;
            `uvm_info("MON_RD", $sformatf("Sampled Read: data_out = 0x%0h", rd_tr.data_out), UVM_HIGH)
            ap.write(rd_tr);
          end
        join_none
        
      end
    end
    
  endtask
  
endclass

`endif
