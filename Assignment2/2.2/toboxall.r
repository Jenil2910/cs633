colors <- matrix(c(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0), nrow=3)
xh <- 5.6
xl <- 0.4

for(proc in c(8,16,32)){
    if(proc==8){
        limit <- 2000
    }else if(proc==16){
        limit <- 1200
    }else{
        limit <- 1800
    }
    png(paste('plot/plot-',proc,'.png', sep=""),
    width = limit,
    height = limit,
    units = "px",
    pointsize = 12,
    bg = "white",
    res = NA
    );
    for(ppn in c(2,4,8)){
        # ppn = 4;
        df <- read.table(paste('data/data',proc,'-',ppn,'.dat', sep=""), FALSE, sep=" ");
        w <- 0.1
        disp <- (log2(ppn)-1)*2
        adj <- disp/6 - 0.5;
        idx <- log2(ppn)
        if(ppn == 2){
            mybox <- boxplot(V2~V1,
                data=df,
                main=paste('p=', proc, sep=""),
                xlab="D",
                ylab="Bandwidth",
                col=rgb(colors[idx,1], colors[idx,2], colors[idx,3], maxColorValue=1.0),
                boxwex=w,
                xaxt="n",
                border="brown",
                ylim=c(0, limit),
                xlim=c(xl, xh),
                at = 1:5 + adj,
                # height=0.1
                range=10
            );
        }else if(ppn == 4){
            mybox <- boxplot(V2~V1,
                data=df,
                main=paste('p=', proc, sep=""),
                xlab="D",
                ylab="Bandwidth",
                col=rgb(colors[idx,1], colors[idx,2], colors[idx,3], maxColorValue=1.0),
                boxwex=w,
                border="brown",
                ylim=c(0, limit),
                xlim=c(xl, xh),
                add=TRUE,
                at = 1:5 + adj,
                # height=0.1
                range=10
            );
        }else{
            mybox <- boxplot(V2~V1,
                data=df,
                main=paste('p=', proc, sep=""),
                xlab="D",
                ylab="Bandwidth",
                col=rgb(colors[idx,1], colors[idx,2], colors[idx,3], maxColorValue=1.0),
                boxwex=w,
                border="brown",
                ylim=c(0, limit),
                xlim=c(xl, xh),
                add=TRUE,
                xaxt="n",
                at = 1:5 + adj,
                # height=0.1
                range=10
            );
        }
        lines(1:5 + adj, mybox$stats[3,], col=rgb(colors[idx,1], colors[idx,2], colors[idx,3], maxColorValue=1.0), lwd=1)

        adj <- (disp+1)/6 - 0.5;
        mpibox <- boxplot(V3~V1,
            data=df,
            main=paste('p=', proc, sep=""),
            xlab="D",
            ylab="Bandwidth",
            col=rgb(1-colors[idx,1], 1-colors[idx,2], 1-colors[idx,3], maxColorValue=1.0),
            boxwex=w,
            border="brown",
            ylim=c(0, limit),
            xlim=c(xl, xh),
            add=TRUE,
            xaxt="n",
            at = 1:5 + adj,
            # height=0.1
            range=10
        );
        lines(1:5 + adj, mpibox$stats[3,], col=rgb(1-colors[idx,1], 1-colors[idx,2], 1-colors[idx,3], maxColorValue=1.0), lwd=1)
    }

    legend("topright", legend=c("MY_Bcast -> PPN = 2", "MPI_Bcast -> PPN = 2", "MY_Bcast -> PPN = 4", "MPI_Bcast -> PPN = 4",
        "MY_Bcast -> PPN = 8", "MPI_Bcast -> PPN = 8"),fill=c(rgb(colors[1,1], colors[1,2], colors[1,3], maxColorValue=1.0), rgb(1-colors[1,1], 1-colors[1,2], 1-colors[1,3], maxColorValue=1.0), 
                                                              rgb(colors[2,1], colors[2,2], colors[2,3], maxColorValue=1.0), rgb(1-colors[2,1], 1-colors[2,2], 1-colors[2,3], maxColorValue=1.0), 
                                                              rgb(colors[3,1], colors[3,2], colors[3,3], maxColorValue=1.0), rgb(1-colors[3,1], 1-colors[3,2], 1-colors[3,3], maxColorValue=1.0) ), cex = 1 )
}
