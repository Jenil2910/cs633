set terminal pngcairo font "arial,10" size 500,500
set output 'plot.png'
set xrange [*:*]
set yrange [0:150]
set datafile separator ","

set style fill solid 0.25 border -1
set style boxplot nooutliers
set style data boxplot

plot "data.dat" using (1):2:(0.5):1
