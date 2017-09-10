library(igraph)

# act_net_edgelist$V2 = NULL
# act_net_edgelist$V4 = NULL

colnames(actid_net_edgelist) = c("from","to","weight")

datapath = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data"
setwd(datapath)

g<-read.graph("actid_net_edgelist.txt",format="ncol")

length(V(g))
length(E(g))
E(g)[1]$weight

prank = page.rank(g,directed=T,damping=0.85)
highranks = sort(prank$vector,decreasing = T)
top10pr = names(highranks[1:10])

prank1 = page.rank(g,directed=T,damping=0.85)
highranks1 = sort(prank$vector,decreasing = T)
top10pr1 = names(highranks[1:10])

ids_10 <- c("37716","26671","35091","30248","35919","110496","200111","67505","56802","165848")
w_10 = matrix(0,10,1)
w_10_ind = matrix(0,10,1)
for (k in 1:10) {
  w_10[k] = prank$vector[ids_10[k]]
  w_10_ind[k] = which(names(highranks) == ids_10[k],arr.ind = T)
}










