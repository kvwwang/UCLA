library("igraph")

set.seed(111)
g = aging.barabasi.game(n=1000,pa.exp=2,aging.exp=-2,directed=FALSE)
d = degree(g)
h = hist(d, breaks=seq(-0.5,by=1,length.out=max(d)+2),main='Degree distribution for Evolving Graph',xlab='Degree')
plot(h$mids,h$density,type='o',main="Degree Density for Evolving Graph",xlab='Degree',ylab='Density')

plot(degree.distribution(g))

c = cluster_fast_greedy(g)
modularity(c)




