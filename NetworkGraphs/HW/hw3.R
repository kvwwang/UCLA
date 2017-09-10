library(igraph)
library(netrw)

colnames(sorted_directed_net) <- c("from","to","weight")
g = graph.data.frame(sorted_directed_net)

is.connected(g)
cl = clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

din = degree(g,mode="in")
hin = hist(din, breaks=seq(-0.5,by=1,length.out=max(din)+2),main='In-Degree distribution',xlab='Degree')
plot(hin$mids,hin$density,type='o',main="In-Degree Density distribution",xlab='Degree',ylab='Density')

din=degree.distribution(g,mode="in")
dout=degree.distribution(g,mode="out")
plot(0:(length(din)-1),din,main="In-Degree Density Distribution of Graph",xlab='Degree',ylab='Density',type="h")
plot(0:(length(dout)-1),dout,main="Out-Degree Density Distribution of Graph",xlab='Degree',ylab='Density',type="h")

func = function(x) {
  if (length(x)>1) {
    sqrt(prod(x));
  }  else{
    x;
  }
}

gu = as.undirected(g,mode="collapse",edge.attr.comb=list(weight=func))
gu_gcc = as.undirected(gcc,mode="collapse",edge.attr.comb=list(weight=func))

gu_fgc = fastgreedy.community(gu)
modularity(gu_fgc)
gu_gcc_fgc = fastgreedy.community(gu_gcc)
modularity(gu_gcc_fgc)

gu_lpc = label.propagation.community(gu)
modularity(gu_lpc)
gu_gcc_lpc = label.propagation.community(gu_gcc)
modularity(gu_gcc_lpc)

length(gu_gcc_fgc)
length(gu_gcc_lpc)
max(sizes(gu_gcc_fgc))
max(sizes(gu_gcc_lpc))

max_index = as.integer(which.max(sizes(gu_gcc_fgc)))
bc_ind = which(gu_gcc_fgc$membership==max_index)
big_com = induced.subgraph(gu_gcc,vids=bc_ind)

bc_fgc = fastgreedy.community(big_com)
modularity(bc_fgc)
length(bc_fgc)
max(sizes(bc_fgc))

p5_com = which(sizes(gu_gcc_fgc)>=100)
p5_val = matrix(0,length(p5_com),3)

for (k in 1:length(p5_com))
{
  ind = which(gu_gcc_fgc$membership==as.integer(p5_com[k]));
  sg = induced.subgraph(gu_gcc,vids=ind);
  com = fastgreedy.community(sg);
  p5_val[k,1] = modularity(com);
  p5_val[k,2] = length(com);
  p5_val[k,3] = max(sizes(com));
}

set.seed(111)
n=1
while (n<4)
{
  i=sample(1:length(V(gu_gcc)),1)
  walk=netrw(gcc,start.node=i,damping=0.85,weights=E(gcc)$weight,seed=111,output.walk.path=T,output.visit.prob=T,local.pagerank = T)
  
  M = matrix(0,1,length(sizes(gu_gcc_fgc)))
  vp = walk$ave.visit.prob
  for (k in 1:30)
  {
    j = which.max(vp)
    m = membership(gu_gcc_fgc)[j]
    M[m] = M[m]+vp[j]
    vp[j]=0
  }
  
  n_sig = length(which(M>0.1))
  
  if (n_sig>=2) {
    print(i)
    print(M)
    n = n+1
  }

}




