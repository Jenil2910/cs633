### Running steps
- generate_host: go to CS633-2019-20-I and then ``./scripts/gen_host.sh 14 26 hostfile``
- compile: go to Assignment1/1.1: ``make``
- run: go to Assignment1/1.1: ``./run.sh``
- plot in plot.png

### Observation
- Due to latency low data has less bandwidth, but as data size increases (since latency remains more or less constant) effective bandwidth increases.
- After some point(at max. bandwidth) we reach saturation and any more data just increases latency causing effective bandwidth to go down.
