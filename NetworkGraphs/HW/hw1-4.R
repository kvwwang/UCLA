library("igraph")

set.seed(111)
g = forest.fire.game(n=1000,fw.prob=0.2,directed=TRUE)
din = degree(g,mode="in")
hin = hist(din, breaks=seq(-0.5,by=1,length.out=max(din)+2),main='In-Degree distribution for Forest Fire',xlab='Degree')
plot(hin$mids,hin$density,type='o',main="In-Degree Density for Forest Fire",xlab='Degree',ylab='Density')

dout = degree(g,mode="out")
hout = hist(dout, breaks=seq(-0.5,by=1,length.out=max(dout)+2),main='Out-Degree distribution for Forest Fire',xlab='Degree')
plot(hout$mids,hout$density,type='o',main="Out-Degree Density for Forest Fire",xlab='Degree',ylab='Density')

diameter(g)

c = cluster_infomap(g)
modularity(c)

