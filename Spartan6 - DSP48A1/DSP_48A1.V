module DSP(A,B,C,D,clk,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,
           CEOPMODE,PCIN,OPMODE,BCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF );
  // Parameters
  parameter A0REG = 0;
  parameter A1REG = 1;
  parameter B0REG = 0;
  parameter B1REG = 1;

  parameter CREG = 1;
  parameter DREG = 1;
  parameter MREG = 1;
  parameter PREG = 1;
  parameter CARRYINREG = 1;
  parameter CARRYOUTREG = 1;
  parameter OPMODEREG = 1;

  parameter CARRYINSEL = "OPMODE5";

  parameter B_INPUT = "DIRECT";

  parameter RSTTYPE = "SYNC";

  // Ports
   input [17:0] A,B,D;
   input [47:0] C;
   input clk,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
   CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
   input [7:0] OPMODE;
   input [47:0] PCIN;
   input [17:0] BCIN;

   output [17:0] BCOUT;
   output [47:0] PCOUT,P;
   output [35:0] M;
   output CARRYOUT,CARRYOUTF;
   // Internal Signals
   wire [17:0] B_mux;
   wire [17:0] A0_mux,B0_mux,D_mux;
   wire [47:0] C_mux;
   wire [7:0] Opmode_mux;
   wire [17:0] Pre_Adder,Pre_Adder_mux;

   wire [17:0] A1_mux;
   wire [17:0] B1_mux;
   wire [35:0] mult;

   wire [35:0] M_mux;
   wire Carry_Cascade,CIN;
   reg [47:0] Mux_x,Mux_z;
   wire [47:0] post_Adder;
   wire carry_post;
   // Design Of DSP
   assign B_mux = (B_INPUT == "DIRECT")?B:(B_INPUT == "CASCADE")?BCIN:0;
   // Stage 1
   reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE),.Situation(A0REG))
   DUT_1(.clk(clk),.rst(RSTA),.en(CEA),.IN(A),.OUT(A0_mux));

   reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE),.Situation(B0REG))
   DUT_2(.clk(clk),.rst(RSTB),.en(CEB),.IN(B),.OUT(B0_mux));

   reg_mux #(.WIDTH(48),.RSTTYPE(RSTTYPE),.Situation(CREG))
   DUT_3(.clk(clk),.rst(RSTC),.en(CEC),.IN(C),.OUT(C_mux));   

   reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE),.Situation(DREG))
   DUT_4(.clk(clk),.rst(RSTD),.en(CED),.IN(D),.OUT(D_mux));

   reg_mux #(.WIDTH(8),.RSTTYPE(RSTTYPE),.Situation(OPMODEREG))
   DUT_5(.clk(clk),.rst(RSTOPMODE),.en(CEOPMODE),.IN(OPMODE),.OUT(Opmode_mux));        

   // Pre Adder
   assign Pre_Adder = (Opmode_mux[6])?(D_mux-B0_mux):(D_mux+B0_mux);

   assign Pre_Adder_mux = (Opmode_mux[4])?Pre_Adder:B0_mux;

   // Stage 2
   reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE),.Situation(A1REG))
   DUT_6(.clk(clk),.rst(RSTA),.en(CEA),.IN(A0_mux),.OUT(A1_mux));

   reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE),.Situation(A1REG))
   DUT_7(.clk(clk),.rst(RSTA),.en(CEA),.IN(Pre_Adder_mux),.OUT(B1_mux));

   assign BCOUT = B1_mux;

   // Multiplier
   assign mult = A1_mux * B1_mux;
   
   // Stage 3
   reg_mux #(.WIDTH(36),.RSTTYPE(RSTTYPE),.Situation(MREG))
   DUT_8(.clk(clk),.rst(RSTM),.en(CEM),.IN(mult),.OUT(M_mux));

   assign M = M_mux;

   assign Carry_Cascade = (CARRYINSEL == "OPMODE5")?Opmode_mux[5]:(CARRYINSEL == "CARRYIN")?CARRYIN:0;
   
   reg_mux #(.WIDTH(1),.RSTTYPE(RSTTYPE),.Situation(CARRYINREG))
   DUT_9(.clk(clk),.rst(RSTCARRYIN),.en(CECARRYIN),.IN(Carry_Cascade),.OUT(CIN));

   // Mux X
   always @(*)begin
     case(Opmode_mux[1:0])
       0 : Mux_x = 0;
       1 : Mux_x = {12'b0,M_mux};
       2 : Mux_x = P;
       3 : Mux_x = {D_mux[11:0],A1_mux,B1_mux};
       default : Mux_x = 0;
     endcase
   end
   // Mux Z
   always @(*)begin
     case(Opmode_mux[3:2])
       0 : Mux_z = 0;
       1 : Mux_z = PCIN;
       2 : Mux_z = P;
       3 : Mux_z = C_mux;
       default : Mux_z = 0;
     endcase
   end   
   // Post Adder
   assign {carry_post,post_Adder} = (Opmode_mux[7])?(Mux_z - (Mux_x + CIN)):(Mux_z + Mux_x + CIN);
   
   // Stage 4
   reg_mux #(.WIDTH(48),.RSTTYPE(RSTTYPE),.Situation(PREG))
   DUT_10(.clk(clk),.rst(RSTP),.en(CEP),.IN(post_Adder),.OUT(P));

   assign PCOUT = P;

   reg_mux #(.WIDTH(1),.RSTTYPE(RSTTYPE),.Situation(CARRYOUTREG))
   DUT_11(.clk(clk),.rst(RSTCARRYIN),.en(CECARRYIN),.IN(carry_post),.OUT(CARRYOUT));

   assign CARRYOUTF = CARRYOUT;
endmodule