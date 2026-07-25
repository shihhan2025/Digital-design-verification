`ifndef FIFO_DRIVER_SV
`define FIFO_DRIVER_SV

class fifo_driver extends uvm_driver #(fifo_seq_item);
  `uvm_component_utils(fifo_driver)

  virtual fifo_if vif;

  function new(string name = "fifo_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif) ) begin
      `uvm_fatal("DRV", "Could not get virtual interface fifo_if from config_db")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    vif.rst_n <= 1'b0;
    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b0;
    vif.data_in <= '0;

    repeat (2) @(posedge vif.clk);
    vif.rst_n <= 1'b1;

    forever begin
      seq_item_port.get_next_item(req);
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_transfer(fifo_seq_item tr);
    @(posedge vif.clk);

    if (tr.wr_en && !vif.full) begin
      vif.wr_en <= 1'b1;
      vif.data_in <= tr.data_in;
    end else begin
      vif.wr_en <= 1'b0;
    end

    if (tr.rd_en && !vif.empty) begin
      vif.rd_en <= 1'b1;
    end else begin
      vif.rd_en <= 1'b0;
    end
    
    @(posedge vif.clk);
    vif.wr_en <= 1'b0;
    vif.rd_en <= 1'b0;
  endtask
endclass

`endif
    
      
