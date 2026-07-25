
module fifo #(parameter DATA_WIDTH = 8, parameter DEPTH = 16)(
		clk, 
		rst_n, 
		wr_en, 
		rd_en, 
		data_in, 
		data_out, 
		empty, 
		full
);

localparam ADDR_WIDTH = (DEPTH <= 1) ? 1 : $clog2(DEPTH);

input wire clk;
input logic rst_n;
input logic wr_en;
input logic rd_en;
input logic [DATA_WIDTH-1:0] data_in;
output logic [DATA_WIDTH-1:0] data_out;
output logic empty;
output logic full;

logic  [DATA_WIDTH-1:0] mem [0:DEPTH-1];
logic [ADDR_WIDTH-1:0]  wr_ptr;
logic [ADDR_WIDTH-1:0]  rd_ptr;
logic [ADDR_WIDTH:0]  count;

assign full = (count==DEPTH);
assign empty = (count==0);

always_ff @(posedge clk)
begin
	if (!rst_n) begin
		wr_ptr   <= '0;
		rd_ptr   <= '0;
		count    <= '0;
		data_out <= '0;
	end
	else begin
		if (wr_en && !full) begin
			mem[wr_ptr] <= data_in;
			wr_ptr <= wr_ptr + 1'b1;
		end

		if (rd_en && !empty) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1'b1;
		end

		case ({wr_en && !full,rd_en && !empty})
			2'b10: begin
				count <= count + 1;
			end
			2'b01: begin
				count <= count - 1;
			end
			2'b11: begin
				count <= count;
			end
			default: begin
                count <= count;
            end
		endcase
	end
end	

endmodule
