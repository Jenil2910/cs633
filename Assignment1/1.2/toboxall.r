pdf("plot.pdf");
for (proc in c(8,16,32)){
	w <- proc/32;
	df <- read.table(paste('data/data',proc,'_nb.dat', sep=""), FALSE, sep=" ");
	t <- boxplot(V2~V1,
	    data=df,
	    main="D,p vs bw non blocking",
	    xlab="D",
	    ylab="Bandwidth",
	    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
	    boxwex=w,
	    border="brown",
	    range=100,
	    ylim=c(0, 250)
	);
	lines(1:4, t$stats[3,], col="green", lwd=1)
	par(new=TRUE);
}
par(new=FALSE);
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_b.dat', sep=""), FALSE, sep=" ");
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw blocking",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(1.0, 0.0, 0.0, 0.5, maxColorValue=1.0),
            boxwex=w,
            border="black",
            range=100,
	    ylim=c(0, 250)
        );
        lines(1:4, t$stats[3,], col="red", lwd=1)
	par(new=TRUE);
}
par(new=FALSE);
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_nb.dat', sep=""), FALSE, sep=" ");
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw both",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
            boxwex=w,
            border="brown",
            range=100,
	    ylim=c(0, 250)
        );
        lines(1:4, t$stats[3,], col="green", lwd=1)
        par(new=TRUE);
}
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_b.dat', sep=""), FALSE, sep=" ");
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw both",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(1.0, 0.0, 0.0, 0.5, maxColorValue=1.0),
            boxwex=w,
            border="black",
            range=100,
	    ylim=c(0, 250)
        );
        lines(1:4, t$stats[3,], col="red", lwd=1)
        par(new=TRUE);
}
