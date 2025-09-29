module tb_DSP();
  // Ports 
   reg [17:0] A,B,D;
   reg [47:0] C;
   reg clk,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
   reg [7:0] OPMODE;
   reg [47:0] PCIN;
   reg [17:0] BCIN;

   wire [17:0] BCOUT;
   wire [47:0] PCOUT,P;
   wire [35:0] M;
   wire CARRYOUT,CARRYOUTF; 
   // Instansiation
   DSP DUT(.*);
   // Clock Generation
   initial begin
     clk = 0;
     forever 
       #1 clk = ~clk;
   end
   // Stimulus
   initial begin
     // Activate Reset
     {RSTA,RSTB,RSTC,RSTD,RSTCARRYIN,RSTM,RSTOPMODE,RSTP} = 8'b1111_1111;
     // Activate Clock Enables
     {CEA,CEB,CEC,CED,CECARRYIN,CEM,CEOPMODE,CEP} = 8'b1111_1111;

     CARRYIN = 0;
     PCIN = 5;
     BCIN = 0;

     A = 120;
     B = 110;
     C = 55;
     D = 48;
     OPMODE = 8'b00110101; // Test For ((D+B)*A) + PCIN + CIN
     @(negedge clk);
     // Deactivate Reset
     {RSTA,RSTB,RSTC,RSTD,RSTCARRYIN,RSTM,RSTOPMODE,RSTP} = 8'b0000_0000;
     repeat(100)begin
        A = $urandom_range(1,50);
        B = $urandom_range(1,50);
        C = $urandom_range(1,50);
        D = $urandom_range(1,50);
        repeat(4) @(negedge clk);
        if((BCOUT != (D+B)) || (M != (D+B)*A) || P != (((D+B)*A) + PCIN + OPMODE[5]) || 
            PCOUT != (((D+B)*A) + PCIN + OPMODE[5]) || CARRYOUT != 0 || CARRYOUTF != 0) begin
            $display("Error In Design");
            $stop;
        end
     end

     OPMODE = 8'b00011101; // Test For (C + ((D+B)*A))
     repeat(100)begin
        A = $urandom_range(1,50);
        B = $urandom_range(1,50);
        C = $urandom_range(1,50);
        D = $urandom_range(1,50);
        repeat(4) @(negedge clk);
        if((BCOUT != (D+B)) || (M != (D+B)*A) || P != (C +((D+B)*A)) || 
            PCOUT != (C +((D+B)*A)) || CARRYOUT != 0 || CARRYOUTF != 0) begin
            $display("Error In Design");
            $stop;
        end
     end
     OPMODE = 8'b01010101; // Test For ((D-B)*A) + PCIN + CIN
     repeat(100)begin
        A = $urandom_range(1,50);
        B = $urandom_range(1,50);
        C = $urandom_range(1,50);
        D = $urandom_range(51,60);
        repeat(4) @(negedge clk);
        if((BCOUT != (D-B)) || (M != (D-B)*A) || P != ((D-B)*A) + PCIN + OPMODE[5] || 
            PCOUT != ((D-B)*A) + PCIN + OPMODE[5] || CARRYOUT != 0 || CARRYOUTF != 0) begin
            $display("Error In Design");
            $stop;
        end
     end
     $stop;
   end
   // Monitoring
   initial begin
     $monitor("clk = %b,CARRYIN = %b,PCIN = %d,BCIN = %d,A = %d,B = %d,C = %d,D = %d,
     OPMODE = %b,BCOUT = %d,M = %d,P = %d,PCOUT = %d,CARRYOUT = %b,CARRYOUTF = %b"
     ,clk,CARRYIN,PCIN,BCIN,A,B,C,D,OPMODE,BCOUT,M,P,PCOUT,CARRYOUT,CARRYOUTF);
   end
endmodule