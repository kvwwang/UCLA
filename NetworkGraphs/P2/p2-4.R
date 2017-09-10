library(igraph)

datapath = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data"
setwd(datapath)

gm<-read.graph("red_mov_net_edgelist.txt",format="ncol",directed=FALSE)

is.directed(gm)
length(V(gm))
length(E(gm))
is.simple(gm)

hist(E(gm)$weight)
max(E(gm)$weight)
minor_edges = which(E(gm)$weight < 0.02)
gm2 = delete.edges(gm,minor_edges)
minor_vertices = which(degree(gm2)==0)
gm2 = delete.vertices(gm2,minor_vertices)

length(V(gm2))
min(degree(gm2))
length(E(gm2))

com <- fastgreedy.community(gm2)
memb = membership(com)
ids = V(gm2)$name

write(ids,"memb_file.txt",sep="\t",ncolumns = length(ids))
write(memb,"memb_file.txt",sep="\t",ncolumns = length(ids),append = TRUE)


# minimemb = memb[1:5]
# minimemb_ids = V(gm2)[1:5]$name
# # write(minimemb_ids,"test_file.txt",sep="\t",ncolumns = length(minimemb_ids))
# write(minimemb,"test_file.txt",sep="\t",ncolumns = length(minimemb_ids),append = TRUE)

# bigcom <- fastgreedy.community(gm,merges=FALSE,modularity=FALSE)

new_verts = c('48304','48305','48306')

gm2 <- add.vertices(gm2,3,name=new_verts)
gm2 <- add.edges(gm2,edges=as.character(new_edges$v1),weight=new_weights$V1)
com2 <- fastgreedy.community(gm2,modularity = F,merges = F)

BvS = sort(BvS_DoJ$V2,decreasing=T,index.return=T)
BvS_top5 = matrix(0,1,5)
BvS_top5_memb = {}
for (k in 1:5) {
  BvS_top5[k] = BvS_DoJ$V1[BvS$ix[k]];
  BvS_top5_memb[k] = memb[as.character(BvS_top5[k])]
}

BvS = sort(MI_RN$V2,decreasing=T,index.return=T)
BvS_top5 = matrix(0,1,5)
BvS_top5_memb = {}
for (k in 1:5) {
  BvS_top5[k] = BvS_DoJ$V1[BvS$ix[k]];
  BvS_top5_memb[k] = memb[as.character(BvS_top5[k])]
}

BvS = sort(minions$V2,decreasing=T,index.return=T)
BvS_top5 = matrix(0,1,5)
BvS_top5_memb = {}
for (k in 1:5) {
  BvS_top5[k] = BvS_DoJ$V1[BvS$ix[k]];
  BvS_top5_memb[k] = memb[as.character(BvS_top5[k])]
}



