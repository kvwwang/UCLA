library(igraph)

g = graph.data.frame(facebook_combined.txt,directed = F)
is.connected(g)
diameter(g)

dd = degree.distribution(g)
plot(dd,main="Degree Distribution",xlab="Degree",ylab="Relative Frequency")
mean(degree(g))

x = 0:(length(dd)-1)
xx = 1/x
xx[1] = 100000000
cv = lm(dd~poly(x,7))

plot(dd,main="Degree Distribution",xlab="Degree",ylab="Relative Frequency")
lines(x, predict(cv, data.frame(x=x)), col="red")
tmse = sum(predict(cv, data.frame(x=x)-dd)^2)
tmse/length(dd)
aov(cv)

#  P2----------------------------------------------------------------------
nbh1 = graph.neighborhood(g,1,1)
pnet1 = nbh1[[1]]
length(V(pnet1))
length(E(pnet1))
V(pnet1)$color="skyblue2"
V(pnet1)[1]$color="black"
plot(pnet1,vertex.size=5,vertex.label=NA)


# P3 ----------------------------------------------------------------------
g_nbrs = neighborhood(g,1)
g_nbrs200 = c()
for (k in 1:length(g_nbrs)) {
  if (length(g_nbrs[[k]])>200){
    g_nbrs200=append(g_nbrs200,k)
  }
}
core_nodes=g_nbrs200

mean(degree(g,v=core_nodes))

node = core_nodes[3]

g_noi = graph.neighborhood(g,1,nodes=node)
g_noi = g_noi[[1]]
degree(g,node)
length(E(g_noi))

# plot(g_noi,vertex.size=5,vertex.label=NA)
g_noi_copy = g_noi
# noi_com = fastgreedy.community(g_noi_copy)
# noi_com = edge.betweenness.community(g_noi_copy)
noi_com = infomap.community(g_noi_copy)
V(g_noi_copy)$color = noi_com$membership+1
plot(g_noi_copy,vertex.size=5,vertex.label=NA)

modularity(noi_com)
length(noi_com)
max(sizes(noi_com))
mean(sizes(noi_com))

# P4 ----------------------------------------------------------------------
g_noi_p4 = g_noi
core_id = which(V(g_noi_p4)$name==V(g)$name[node])
g_noi_p4 = delete.vertices(g_noi,v=core_id)

# plot(g_noi_p4,vertex.size=5,vertex.label=NA)
g_noi_p4_copy = g_noi_p4
# noi_com_p4 = fastgreedy.community(g_noi_p4_copy)
# noi_com_p4 = edge.betweenness.community(g_noi_p4_copy)
noi_com_p4 = infomap.community(g_noi_p4_copy)
V(g_noi_p4_copy)$color = noi_com_p4$membership+1
plot(g_noi_p4_copy,vertex.size=5,vertex.label=NA)

modularity(noi_com_p4)
length(noi_com_p4)
max(sizes(noi_com_p4))
mean(sizes(noi_com_p4))

# P5 ----------------------------------------------------------------------

















