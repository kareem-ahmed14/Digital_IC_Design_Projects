vlib work
vlog DSP_48A1.v tb_DSP.v
vsim -voptargs=+acc work.tb_DSP
add wave *
run -all
#quit -sim