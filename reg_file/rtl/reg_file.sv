////////////////////////////////////////////////////////////////////////////////
// Register file
// interface:
// clk             // i
// rst_n           // i
// req             // i
// wr              // i 
// addr   [31:0]   // i
// wr_data[31:0]   // i 
// rd_data[31:0]   // o
// ack             // o
// err     [7:0]   // o
////////////////////////////////////////////////////////////////////////////////
module reg_file(
                 clk       ,   // i
                 rst_n     ,   // i
                 i_req     ,   // i
                 i_wr      ,   // i
                 i_addr    ,   // i
                 i_wr_data ,   // i
                 o_rd_data ,   // o
                 o_ack     ,   // o
                 o_credit  ,   // o
                 o_err     );  // o

////////////////////////////////////////////////////////////////////////////////
//Parameters
////////////////////////////////////////////////////////////////////////////////
parameter ADDR_W = 32;
parameter DATA_W = 32;
parameter ERR_W  = 8;

`include "defines.svh"
////////////////////////////////////////////////////////////////////////////////
// Input/Output
////////////////////////////////////////////////////////////////////////////////

input              clk        ; // i
input              rst_n      ; // i
input              i_req      ; // i
input              i_wr       ; // i 
input  [ADDR_W-1:0]i_addr     ; // i
input  [DATA_W-1:0]i_wr_data  ; // i 
output [DATA_W-1:0]o_rd_data  ; // o
output             o_ack      ; // o
output             o_credit   ; // o
output [ERR_W-1:0] o_err      ; // o

reg             i_req      ; // i
reg             i_wr       ; // i 
reg [ADDR_W-1:0]i_addr     ; // i
reg [DATA_W-1:0]i_wr_data  ; // i 
reg [DATA_W-1:0]o_rd_data  ; // o
reg             o_ack      ; // o 
reg             o_credit   ; // o
reg [ERR_W-1:0] o_err      ; // o

reg             req      ; // i
reg             wr       ; // i 
reg [ADDR_W-1:0]addr     ; // i
reg [DATA_W-1:0]wr_data  ; // i 
reg [DATA_W-1:0]rd_data  ; // o
reg             ack      ; // o
reg             credit   ; // o
reg [ERR_W-1:0] err      ; // o
reg [ERR_W-1:0] err_next ; // o

//Local registers
reg [DATA_W-1:0] reg0;
reg [DATA_W-1:0] reg1;
reg [DATA_W-1:0] reg2;
reg [DATA_W-1:0] reg3;
reg [DATA_W-1:0] reg4;
reg [DATA_W-1:0] reg5;
reg [DATA_W-1:0] reg6;
reg [DATA_W-1:0] reg7;
reg              is_vld_wr_req;
reg              is_vld_rd_req;
reg [DATA_W-1:0] reg0_next;
reg [DATA_W-1:0] reg1_next;
reg [DATA_W-1:0] reg2_next;
reg [DATA_W-1:0] reg3_next;
reg [DATA_W-1:0] reg4_next;
reg [DATA_W-1:0] reg5_next;
reg [DATA_W-1:0] reg6_next;
reg [DATA_W-1:0] reg7_next;
//no need to flop the inputs, "other" blocks should do it at their end
always @(*) begin
  req      = i_req    ; 
  wr       = i_wr     ; 
  addr     = i_addr   ; 
  wr_data  = i_wr_data; 
end

//Flop the outputs
always @(posedge clk) begin
  if(!rst_n) begin
    o_rd_data <= '0;
    o_ack     <= '0;
    o_credit  <= '0;
    o_err     <= '0;
  end else begin
    o_rd_data <= rd_data;
    o_ack     <= ack;
    o_credit  <= credit;
    o_err     <= err;
  end
end
////////////////////////////////////////////////////////////////////////////////
// Fun begins here
////////////////////////////////////////////////////////////////////////////////
//
//Write path::
always_comb begin
  if(is_vld_wr_req) begin
    err_next  = `NO_ERR;
    reg0_next = reg0;
    reg1_next = reg1;
    reg2_next = reg2;
    reg3_next = reg3;
    reg4_next = reg4;
    reg5_next = reg5;
    reg6_next = reg6;
    reg7_next = reg7;
    case(addr)
      `ADDR_REG0: reg0_next = wr_data;
      `ADDR_REG1: reg1_next = wr_data;
      `ADDR_REG2: reg2_next = wr_data;
      `ADDR_REG3: reg3_next = wr_data;
      `ADDR_REG4: reg4_next = wr_data;
      `ADDR_REG5: reg5_next = wr_data;
      `ADDR_REG6: reg6_next = wr_data;
      `ADDR_REG7: reg7_next = wr_data;
      default:   begin
        err_next = err;
      end
    endcase
  end
end

always @(posedge clk) begin
  if(!rst_n) begin
    err  <= '0;
    reg0 <= '0;
    reg1 <= '0;
    reg2 <= '0;
    reg3 <= '0;
    reg4 <= '0;
    reg5 <= '0;
    reg6 <= '0;
    reg7 <= '0;
  end else begin
    err  <= err_next;
    reg0 <= reg0_next;
    reg1 <= reg1_next;
    reg2 <= reg2_next;
    reg3 <= reg3_next;
    reg4 <= reg4_next;
    reg5 <= reg5_next;
    reg6 <= reg6_next;
    reg7 <= reg7_next;
  end
end

always_comb begin
  is_vld_wr_req = wr && req;
end

//Read path::
always @(posedge clk) begin
  if(!rst_n) begin
    rd_data = '0;
  end else begin
    rd_data = '0;
    if(is_vld_rd_req) begin
      case(addr)
	`ADDR_REG0: rd_data = reg0;
	`ADDR_REG1: rd_data = reg1;
	`ADDR_REG2: rd_data = reg2;
	`ADDR_REG3: rd_data = reg3;
	`ADDR_REG4: rd_data = reg4;
	`ADDR_REG5: rd_data = reg5;
	`ADDR_REG6: rd_data = reg6;
	`ADDR_REG7: rd_data = reg7;
	default:    rd_data = `DATA_W'h0;
      endcase
    end
  end
end

always_comb begin
  is_vld_rd_req = !wr && req;
end
initial begin
  $display("[%0t] Compiling", $time);
end
endmodule
