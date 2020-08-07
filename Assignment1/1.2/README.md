#### Running steps
- generate_host: go to CS633-2019-20-I and then ``./scripts/gen_host.sh 14 26 hostfile``
- compile: go to Assignment1/1.2: ``make``
- run: go to Assignment1/1.2: ``./run.sh``
- plot in plot.pdf

#### Plot
- D is on X axis.
- more width means more process.
- Bandwidth is on Y axis.

#### Observations and Explanations
- Obs: For same data size, bandwidth decreases as no. of process increases.
	- Exp: For small no. of processes, most data is shared via shared memory(as 4 process per node).
	- For large no. of processes, data going through network increases a lot(which is slow) decreasing effective bandwidth.

- Explanation for fluctuation of bandwidth vs data size: There are two opposing factors affecting bandwidth here.
	- Incoming data may get clogged in reciever's socket port, which effectively increases time. This decreases effective bandwith for large datasize and increases bandwidth for small datasize.
	- Latency is high w.r.t small datasize and low w.r.t large data which causes effective bandwidth low for small datasize and high for large data.
- In non-blocking, multiple recieves overlap so generally non-blocking has more bandwidth than blocking 
