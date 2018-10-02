onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rom224 -L xil_defaultlib -L xpm -L dist_mem_gen_v8_0_12 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.rom224 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {rom224.udo}

run -all

endsim

quit -force
