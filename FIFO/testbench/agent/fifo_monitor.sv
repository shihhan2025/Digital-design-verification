`ifndef FIFO_MONITOR_SV
`define FIFO_MONITOR_SV

class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if vif;
  uvm_analysis_port #(fifo_seq_item) ap;
  fifo_seq_item pending_read;

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
    wait(vif.rst_n == 1'b1);
    `uvm_info("MON", "Reset released, monitor start", UVM_LOW)

    forever begin
      @(posedge vif.clk);
      if(!vif.rst_n) continue;
      if(pending_read != null) begin
        pending_read.data_out = vif.data_out;
        `uvm_info("MON_RD", $sformatf("READ data_out = 0x%0h", pending_read.data_out), UVM_HIGH)
        ap.write(pending_read);
        pending_read = null;
      end

      if((vif.wr_en && !vif.full) || (vif.rd_en && !vif.empty)) begin
        fifo_seq_item tr;
        tr = fifo_seq_item::type_id::create("tr");
        tr.wr_en = vif.wr_en;
        tr.rd_en = vif.rd_en;
        tr.data_in = vif.data_in;

        if(vif.wr_en && !vif.full) begin
          `uvm_info("MON_WR",$sformatf("WRITE data_in = 0x%0h", vif.data_in), UVM_HIGH)
        end

        if(vif.rd_en && !vif.empty) begin
          pending_read = tr;
        end
        else begin
          ap.write(tr);
        end
      end
    end

  endtask
  
endclass

`endif
