set key top right box
set logscale xy 10
set format x "10^{%L}"
set format y "10^{%L}"

set yrange [1:1e8]
set xrange [1:1e7]
set xlabel "In Degree"
set ylabel "Count" offset 0,1
set terminal postscript enhanced eps 30 color
set output 'plot.eps'
plot "output_indist.txt" using 1:2 title "soc-LiveJournal1" pt 1 ps 1.5 lc 3 lw 2.5
