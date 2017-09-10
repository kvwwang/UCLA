library("igraph")

n = 1000 #change to 10,000 as needed

set.seed(111)
g = barabasi.game(n,directed=FALSE)
d = degree(g)
h = hist(d, breaks=seq(-0.5,by=1,length.out=max(d)+2),main='Degree distribution for PA Graph',xlab='Degree')
plot(h$mids,h$density,type='o',main="Degree Density for PA Graph",xlab='Degree',ylab='Density')

degree.distribution(g)

diameter(g)
is.connected(g)

c = clusters(g)
# c = cluster_fast_greedy(g)

gccIndex = which.max(c$csize)
nonGccNodes = (1:vcount(g))[c$membership != gccIndex]
gcc = delete.vertices(g, nonGccNodes)

c_gcc = cluster_fast_greedy(gcc)
modularity(c_gcc)

set.seed(55)
ed = E(g)
eds = get.edges(g,ed)
edf = as.data.frame(eds)
deg = matrix(0,1,1000)

for (a in 1:1000)
{
  v = ceiling(runif(1,0,gsize(g)));
  v_eds1 = edf[edf$V1 == v,];
  v_eds2 = edf[edf$V2 == v,];
  v_eds = rbind(v_eds1,v_eds2);

    
  j = ceiling(runif(1,0,nrow(v_eds)));
  x = v_eds[j,];
  if (x[1] == v)
    degr = x[1]
  else
    degr = x[2];
  
  deg[a] = degree(g,degr);
}

d = as.numeric(deg)
hd = hist(d, breaks=seq(-0.5,by=1,length.out=max(d)+2),main='Degree distribution for Random Neighbor of Randomly chosen Nodes',xlab='Degree')
plot(hd$mids,hd$density,type='o',main="Degree Density for Random Neighbor of Randomly chosen Nodes",xlab='Degree',ylab='Density')
