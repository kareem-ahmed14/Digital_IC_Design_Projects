module reg_mux(clk,rst,en,IN,OUT);
  // Parameters 
  parameter WIDTH = 18;
  parameter RSTTYPE = "SYNC";
  parameter Situation = 1;
  // Ports 
  input clk,rst,en;
  input [WIDTH-1:0] IN;
  output [WIDTH-1:0] OUT;
  // Internal Signals
  reg [WIDTH-1:0] IN_reg;
  // Design Of Reg
  generate 
    if(RSTTYPE == "SYNC")begin
        always@(posedge clk)begin
            if(rst)
              IN_reg <= 0;
            else if(en)
              IN_reg <= IN;         
        end
    end
    else if(RSTTYPE == "ASYNC") begin
        always@(posedge clk,posedge rst)begin
            if(rst)
              IN_reg <= 0;
            else if(en)
              IN_reg <= IN;         
        end        
    end
  endgenerate
  // Design Of MUX
  assign OUT = (Situation)?IN_reg:IN;
endmodule