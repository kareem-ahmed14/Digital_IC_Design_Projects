module RAM_SPI(clk,rst_n,din,rx_valid,dout,tx_valid);
  // Parameters
  parameter MEM_DEPTH = 256;
  parameter ADDR_SIZE = 8;
  // Ports Declaration
  input clk,rst_n,rx_valid;
  input [9:0] din;
  output reg tx_valid;
  output reg [7:0] dout;
  // Internal Signals
  reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
  reg [ADDR_SIZE-1:0] addr;
  // Design Of RAM
  always@(posedge clk)begin
     if(~rst_n)begin
        dout <= 0;
        tx_valid <= 0;
        addr <= 0;
     end
     else begin
        if(rx_valid)begin
           tx_valid <= 0;
           case(din[9:8])
             2'b00 : addr <= din[7:0];
             2'b01 : mem[addr] <= din[7:0];
             2'b10 : addr <= din[7:0];
             2'b11 :begin
                dout <= mem[addr];
                tx_valid <= 1;
             end 
           endcase 
        end
     end
  end
endmodule