library(igraph)

pnets = graph.neighborhood(g,1,nodes=core_nodes)

pnet_communities = {}

for (q in 1:length(pnets)) {
  com = fastgreedy.community(pnets[[q]])
  pnet_communities = c(pnet_communities,list(com))
}

max_k=length(pnets)
n_10coms = matrix(0,1,max_k)
pnet_stats = list()
for (k in 1:max_k){
  com = pnet_communities[[k]]
  n_coms = length(sizes(com))
  mods = {}
  cc = {}
  per = {}
  for (j in 1:n_coms) {
    pnet_copy = pnets[[k]]
    non_com = (1:vcount(pnet_copy))[membership(com) != j]
    subcom = delete.vertices(pnet_copy, non_com)
    if (vcount(subcom)>10) {
      subcom_coms = fastgreedy.community(subcom)
      mods = c(mods,modularity(subcom_coms))
      cc = c(cc,transitivity(subcom,type="global"))
      per = c(per,vcount(subcom)/vcount(pnet_copy))
    }
  }
  df = data.frame(mods,cc,per)
  colnames(df) <- c("Modularity","CC","% of nodes")
  pnet_stats[[k]]=df
  n_10coms[k] = length(mods)
}

hist(n_10coms,breaks=seq(1.5, by=1 , length.out=8),main="Number of >10 size Communities",xlab="Amount")

size2coms = which(n_10coms == 2)
for (q in 1:length(size2coms)) {
  ind = size2coms[q]
  # print(pnet_stats[[ind]]$Modularity)
  # print(pnet_stats[[ind]]$CC)
  print(pnet_stats[[ind]]$`% of nodes`)
}

size3coms = which(n_10coms == 3)
for (q in 1:length(size3coms)) {
  ind = size3coms[q]
  # print(pnet_stats[[ind]]$Modularity)
  # print(pnet_stats[[ind]]$CC)
  print(pnet_stats[[ind]]$`% of nodes`)
}






