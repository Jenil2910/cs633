pdf("plot.pdf");
shifts <- c(-500, 0.0, 500);
i=1;
for (proc in c(8,16,32)){
	w <- proc/32;
	df <- read.table(paste('data/data',proc,'_nb.dat', sep=""));
	t <- boxplot(V2~V1,
	    data=df,
	    main="D,p vs bw non blocking",
	    xlab="D",
	    ylab="Bandwidth",
	    col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
	    boxwex=0.08,
	    border="brown",
	    range=20,
	    ylim=c(0, 250),
	    at=1:4 + shifts[i]
	);
	lines(1:4, t$stats[3,], col="green", lwd=1)
	par(new=TRUE);
	i=i+1;
}
par(new=FALSE);
i=1;
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_b.dat', sep=""));
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw blocking",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(1.0, 0.0, 0.0, 0.5, maxColorValue=1.0),
            boxwex=0.08,
            border="black",
            range=20,
	    ylim=c(0, 250),
	    at=1:4 + shifts[i]
        );
        lines(1:4, t$stats[3,], col="red", lwd=1)
	par(new=TRUE);
	i=i+1;
}
par(new=FALSE);
i=1;
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_nb.dat', sep=""));
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw both",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(0.0, 0.0, 1.0, 0.5, maxColorValue=1.0),
            boxwex=0.08,
            border="brown",
            range=20,
	    ylim=c(0, 250),
	    at=1:4 + shifts[i]
        );
        lines(1:4, t$stats[3,], col="green", lwd=1)
        par(new=TRUE);
	i=i+1;
}
i=1;
for (proc in c(8,16,32)){
        w <- proc/32;
        df <- read.table(paste('data/data',proc,'_b.dat', sep=""));
        t <- boxplot(V2~V1,
            data=df,
            main="D,p vs bw both",
            xlab="D",
            ylab="Bandwidth",
            col=rgb(1.0, 0.0, 0.0, 0.5, maxColorValue=1.0),
            boxwex=0.08,
            border="black",
            range=20,
	    ylim=c(0, 250),
	    at=1:4 + shifts[i]
        );
        lines(1:4, t$stats[3,], col="red", lwd=1)
        par(new=TRUE);
	i=i+1;
}
