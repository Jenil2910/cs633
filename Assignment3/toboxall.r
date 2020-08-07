pdf("/tmp/plot1/plot.pdf");
df <- read.table(paste('/tmp/plot1/data.dat', sep=""), FALSE, sep=" ");
t <- boxplot(V2~V1,
    data=df,
    main="Total time v/s P",
    xlab="P",
    ylab="Total time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)

median_first <- t$stats[3,1]

par(new=FALSE);
t <- boxplot(V3~V1,
    data=df,
    main="Avg pre-processing time v/s P",
    xlab="P",
    ylab="Avg. preprocess time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(V4~V1,
    data=df,
    main="Processing Time v/s P",
    xlab="P",
    ylab="Processing Time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(median_first/V2~V1,
    data=df,
    main="Speedup v/s P",
    xlab="P",
    ylab="Speedup",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);

##################################################################################
pdf("/tmp/plot2/plot.pdf");
df <- read.table(paste('/tmp/plot2/data.dat', sep=""), FALSE, sep=" ");
t <- boxplot(V2~V1,
    data=df,
    main="Total time v/s P",
    xlab="P",
    ylab="Total time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)

median_first <- t$stats[3,1]

par(new=FALSE);
t <- boxplot(V3~V1,
    data=df,
    main="Avg pre-processing time v/s P",
    xlab="P",
    ylab="Avg. preprocess time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(V4~V1,
    data=df,
    main="Processing Time v/s P",
    xlab="P",
    ylab="Processing Time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(median_first/V2~V1,
    data=df,
    main="Speedup v/s P",
    xlab="P",
    ylab="Speedup",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);

##################################################################################
pdf("./hpc/plot1/plot.pdf");
df <- read.table(paste('./hpc/plot1/data.dat', sep=""), FALSE, sep=" ");
t <- boxplot(V2~V1,
    data=df,
    main="Total time v/s P",
    xlab="P",
    ylab="Total time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)

median_first <- t$stats[3,1]

par(new=FALSE);
t <- boxplot(V3~V1,
    data=df,
    main="Avg pre-processing time v/s P",
    xlab="P",
    ylab="Avg. preprocess time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(V4~V1,
    data=df,
    main="Processing Time v/s P",
    xlab="P",
    ylab="Processing Time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(median_first/V2~V1,
    data=df,
    main="Speedup v/s P",
    xlab="P",
    ylab="Speedup",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);

##################################################################################
pdf("./hpc/plot2/plot.pdf");
df <- read.table(paste('./hpc/plot2/data.dat', sep=""), FALSE, sep=" ");
t <- boxplot(V2~V1,
    data=df,
    main="Total time v/s P",
    xlab="P",
    ylab="Total time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)

median_first <- t$stats[3,1]

par(new=FALSE);
t <- boxplot(V3~V1,
    data=df,
    main="Avg pre-processing time v/s P",
    xlab="P",
    ylab="Avg. preprocess time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(V4~V1,
    data=df,
    main="Processing Time v/s P",
    xlab="P",
    ylab="Processing Time",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
t <- boxplot(median_first/V2~V1,
    data=df,
    main="Speedup v/s P",
    xlab="P",
    ylab="Speedup",
    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
    border="brown",
    range=0.5
);
lines(1:length(t$stats[1,]), t$stats[3,], col="blue", lwd=1)
par(new=FALSE);
