`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) item_imp;

  bit [7:0] expected_queue[$];

  int total_write;
  int total_read;
  int match_count;
  int mismatch_count;

  function new(string name="fifo_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_imp = new("item_imp", this);
  endfunction

  function void write(fifo_seq_item tr);
    bit [7:0] expected_data;
    if (tr.rd_en && !tr.empty) begin
      total_read++;
      if (expected_queue.size() == 0) begin
        mismatch_count++;
        `uvm_error("SCB", $sformatf("Reference Queue Empty! DUT Output = %0h", tr.data_out));
      end
      else begin
        expected_data = expected_queue.pop_front();
        if (expected_data == tr.data_out) begin
          match_count++;
          `uvm_info("SCB_PASS", $sformatf("MATCH  Expected=%0h Actual=%0h",expected_data, tr.data_out),UVM_LOW);
        end
        else begin
          mismatch_count++;
          `uvm_error("SCB_FAIL", $sformatf("MISMATCH Expected=%0h Actual=%0h", expected_data,tr.data_out));
        end
      end
    end

    if (tr.wr_en && !tr.full) begin
      total_write++;
      expected_queue.push_back(tr.data_in);
      `uvm_info("SCB_WRITE", $sformatf("Push %0h Queue Size=%0d",tr.data_in, expected_queue.size()),UVM_HIGH)
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB", "====================================", UVM_NONE)
    `uvm_info("SCB", $sformatf("Total Write     : %0d", total_write),UVM_NONE)
    `uvm_info("SCB", $sformatf("Total Read      : %0d", total_read), UVM_NONE)
    `uvm_info("SCB", $sformatf("Match Count     : %0d", match_count),UVM_NONE)
    `uvm_info("SCB", $sformatf("Mismatch Count  : %0d", mismatch_count),UVM_NONE)
    `uvm_info("SCB", $sformatf("Queue Left      : %0d",expected_queue.size()),UVM_NONE)
    
    if ((mismatch_count == 0) && (expected_queue.size() == 0))
      `uvm_info("SCB","******** TEST PASSED ********",UVM_NONE)
    else
      `uvm_error("SCB","******** TEST FAILED ********")

  endfunction

endclass

`endif
