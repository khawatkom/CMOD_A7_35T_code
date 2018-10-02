onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk_100MHz_opt

do {wave.do}

view wave
view structure
view signals

do {clk_100MHz.udo}

run -all

quit -force
