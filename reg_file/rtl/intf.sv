////////////////////////////////////////////////////////////////////////////////
// DUT Interface definition
////////////////////////////////////////////////////////////////////////////////
//
interface intf;

  logic             clk        ; // i
  logic             rst_n      ; // i
  logic             i_req      ; // i
  logic             i_wr       ; // i 
  logic [ADDR_W-1:0]i_addr     ; // i
  logic [DATA_W-1:0]i_wr_data  ; // i 
  logic [DATA_W-1:0]o_rd_data  ; // o
  logic             o_ack      ; // o
  logic             o_credit   ; // o
  logic [ERR_W-1:0] o_err      ; // o

endinterface
