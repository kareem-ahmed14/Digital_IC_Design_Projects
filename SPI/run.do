vlib work
vlog SPI_Slave.v RAM_SPI.v SPI_Wrapper.v SPI_tb.v
vsim -voptargs=+acc work.SPI_tb
add wave *
run -all
#quit -sim
add wave -position insertpoint  \
sim:/SPI_tb/DUT/tx_valid \
sim:/SPI_tb/DUT/tx_data \
sim:/SPI_tb/DUT/rx_valid \
sim:/SPI_tb/DUT/rx_data
add wave -position insertpoint  \
sim:/SPI_tb/DUT/DUT_1/mem
add wave -position insertpoint  \
sim:/SPI_tb/DUT/DUT_2/WRITE \
sim:/SPI_tb/DUT/DUT_2/READ_DATA \
sim:/SPI_tb/DUT/DUT_2/READ_ADD \
sim:/SPI_tb/DUT/DUT_2/ns \
sim:/SPI_tb/DUT/DUT_2/IDLE \
sim:/SPI_tb/DUT/DUT_2/cs \
sim:/SPI_tb/DUT/DUT_2/counter \
sim:/SPI_tb/DUT/DUT_2/CHK_CMD \
sim:/SPI_tb/DUT/DUT_2/C_READ