module SPI_tb();
  // Ports
  reg clk,rst_n,MOSI,SS_n;
  wire MISO;
  // Instantiation
  SPI_Wrapper DUT (.clk(clk),.rst_n(rst_n),.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n));
  // Clock Generation
  initial begin
    clk = 0;
    forever 
      #1 clk = ~clk;
  end
  // Simulus
  initial begin
    $readmemh("mem.dat",DUT.DUT_1.mem);
    rst_n = 0;//rst
    MOSI = 0;
    SS_n = 1;
    @(negedge clk);
    rst_n = 1;
    SS_n = 1;
    repeat(2)@(negedge clk);

    MOSI = 0;//write_address
    SS_n = 0;
    repeat(2)@(negedge clk);

    MOSI = 0;
    repeat(7)@(negedge clk);

    repeat(3)begin
        MOSI = 1;
        @(negedge clk);
    end

    SS_n=1;
    @(negedge clk);


    MOSI = 0;//write_data
    SS_n = 0;
    repeat(2)@(negedge clk);

    MOSI = 0;
    @(negedge clk);

    repeat(9)begin
        MOSI = ~MOSI;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);

    MOSI = 1;//read_address
    SS_n = 0;
    repeat(2)@(negedge clk);

    MOSI = 1;
    @(negedge clk);

    MOSI = 0;
    repeat(6)@(negedge clk);

    repeat(3)begin
        MOSI = 1;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);

    MOSI = 1;
    SS_n = 0;
    repeat(2)@(negedge clk);

    repeat(19)begin
        MOSI = 1;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);

    MOSI = 0;
    SS_n = 0;
    repeat(2)@(negedge clk);

    MOSI = 0;
    repeat(3)@(negedge clk);

    repeat(7)begin
        MOSI = 1;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);

    MOSI = 1;
    SS_n = 0;
    repeat(2)@(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);

    repeat(8)begin
        MOSI = 1;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);
    
    MOSI = 0;
    SS_n = 0;
    repeat(2)@(negedge clk);

    MOSI = 0;
    @(negedge clk);

    repeat(9)begin
        MOSI = ~MOSI;
        @(negedge clk);
    end

    SS_n = 1;
    @(negedge clk);

    $stop;    
  end

endmodule