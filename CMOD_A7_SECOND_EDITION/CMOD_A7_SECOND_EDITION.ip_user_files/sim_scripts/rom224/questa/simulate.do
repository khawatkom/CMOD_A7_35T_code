onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib rom224_opt

do {wave.do}

view wave
view structure
view signals

do {rom224.udo}

run -all

quit -force
