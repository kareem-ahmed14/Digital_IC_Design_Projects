module SPI_Wrapper(clk,rst_n,MOSI,MISO,SS_n);
  // Ports
  input clk,rst_n,MOSI,SS_n;
  output MISO;
  // Internal Signals
  wire rx_valid,tx_valid;
  wire [9:0] rx_data;
  wire [7:0] tx_data;
  // Instantiation
  RAM_SPI DUT_1(.clk(clk),.rst_n(rst_n),.din(rx_data),.rx_valid(rx_valid),.dout(tx_data),.tx_valid(tx_valid));
  SPI_Slave DUT_2(.clk(clk),.rst_n(rst_n),.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.rx_data(rx_data),.rx_valid(rx_valid),
                  .tx_data(tx_data),.tx_valid(tx_valid));
endmodule