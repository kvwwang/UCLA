library(igraph)

set.seed(111)
g01 = random.graph.game(1000, 0.01, directed=F);
d01 = degree(g01)
h01 = hist(d01, breaks=seq(-0.5,by=1,length.out=max(d01)+2),main='Degree distribution for p=0.01',xlab='Degree')
plot(h01$mids,h01$density,type='o',main="Degree Density for p=0.01",xlab='Degree',ylab='Density')


set.seed(111)
g05 = random.graph.game(1000, 0.05, directed=F);
d05 = degree(g05)
h05 = hist(d05, breaks=seq(-0.5,by=1,length.out=max(d05)+2),main='Degree distribution for p=0.05',xlab='Degree')
plot(h05$mids,h05$density,type='o',main="Degree Density for p=0.05",xlab='Degree',ylab='Density')

set.seed(111)
g1 = random.graph.game(1000, 0.1, directed=F);
d1 = degree(g1)
h1 = hist(d1, breaks=seq(min(d1)-2.5,max(d1)+2.5,by=1),main='Degree distribution for p=0.1',xlab='Degree')
plot(h1$mids,h1$density,type='o',main="Degree Density for p=0.1",xlab='Degree',ylab='Density')

is.connected(g01)
is.connected(g05)
is.connected(g1)

diameter(g01)
diameter(g05)
diameter(g1)

set.seed(1)
p=0
g =random.graph.game(1000, p, directed=F)
while (!is.connected(g))
{
  p = p+.00005;
  g =random.graph.game(1000, p, directed=F);
}

