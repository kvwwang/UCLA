library(igraph)
library(netrw)

n_nodes = 10000

set.seed(111)
g = barabasi.game(n_nodes,directed=FALSE)
a = netrw(g,damping=1,output.walk.path=T,output.visit.prob=T)

iniNodes = a$walk.path[1,]
dist = matrix(0,100,100)

for (k in 1:100) {
  pa = get.shortest.paths(g,from=iniNodes[k],to=a$walk.path[,k])
  for (l in 1:100){
    dist[l,k] = length(pa$vpath[[l]])-1
  }
}

s = matrix(0,1,100)
v = matrix(0,1,100)
sdev = matrix(0,1,100)

for (k in 1:100){
  s[k] = mean(dist[k,])
  v[k] = var(dist[k,])
  sdev[k] = sd(dist[k,])
}

plot(1:100,s,main="Average distance at time T",xlab="Time t",ylab="Distance")
plot(1:100,v,main="Variance of distance across time T",xlab="Time t",ylab="Variance")
plot(1:100,sdev,main="Standard Deviation of distance across time T",xlab="Time t",ylab="Standard Deviation")

diameter(g)

plot(degree.distribution(g),main="Degree Distribution of Graph",xlab='Degree',ylab='Density')
plot(degree.distribution(g,v=a$walk.path[,100]),main="Degree Distribution of Random Walk End Nodes",xlab='Degree',ylab='Density')


