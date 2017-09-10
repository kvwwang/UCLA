library(igraph)


#  ------------------------------------------------------------------------


g = graph.data.frame(facebook_combined.txt,directed = F)
g_nbrs = neighborhood(g,1)
g_nbrs200 = c()
for (k in 1:length(g_nbrs)) {
  if (length(g_nbrs[[k]])>200){
    g_nbrs200=append(g_nbrs200,k)
  }
}
core_nodes=g_nbrs200

#  ------------------------------------------------------------------------
pnet <- function(g,node)
{
  net = graph.neighborhood(g,1,nodes=node)
  net[[1]]
}

embdns <- function(core,node,g)
{
  n1 = neighborhood(g,1,core)[[1]]
  n2 = neighborhood(g,1,node)[[1]]
  
  length(intersect(n1,n2))
}

disp <- function(core,node,g,pn)
{
  n1 = neighborhood(g,1,core)[[1]]
  n2 = neighborhood(g,1,node)[[1]]
  com_nb = intersect(n1,n2)
  
  core_id = which(V(pn)$name==V(g)[core]$name)
  node_id = which(V(pn)$name==V(g)[node]$name)
  
  pn_mod = delete.vertices(pn,v=c(core_id,node_id))
  d=0
  for (s in com_nb) {
    for (t in com_nb) {
      if (s!=t) {
        if (!is.na(match(s,V(pn_mod))) && !is.na(match(t,V(pn_mod)))) {
          if (!are.connected(pn_mod,s,t) && (embdns(s,t,pn_mod)==0)) {
            d=d+1
          }
        }
      }
    }
  }
  d/2
}

#  ------------------------------------------------------------------------

pnets = graph.neighborhood(g,1,nodes=core_nodes)
n_values=0
for (k in 1:length(pnets)){
  n_values = n_values+length(V(pnets[[k]]))  
}

embeddedness = matrix(0,1,n_values-41)
dispersion = matrix(0,1,n_values-41)
l = 1
for (k in 1:length(pnets)) {
  per_net = pnets[[k]]
  for (j in 1:length(V(per_net))) {
    core_nbrs = neighborhood(g,1,core_nodes[k])[[1]]
    if (core_nodes[k] != core_nbrs[j]) {
      embeddedness[l]=embdns(core_nodes[k],node=core_nbrs[j],g)
      # dispersion[l]=disp(core_nodes[k],core_nbrs[j],g,per_net)
      l = l+1
    }
  }
  print(k)
}

h=hist(embeddedness,freq=F)
hist(embeddedness,freq=F,breaks=seq(-0.5, by=1 , length.out=max(embeddedness)+2),main="Embeddedness over PNets of all Core Nodes")

# dispersion = matrix(0,1,n_values-41)
# l = 1
max_k=length(pnets)
for (k in 41:41) {  #38
  per_net = pnets[[k]]
  for (j in 1:length(V(per_net))) {
    core_nbrs = neighborhood(g,1,core_nodes[k])[[1]]
    if (core_nodes[k] != core_nbrs[j]) {
      dispersion[l]=disp(core_nodes[k],core_nbrs[j],g,per_net)
      l = l+1
    }
  }
  print(k)
}
dispersion_backup = dispersion
l2=l

# embdns(V(g)[core_nodes[1]],V(g)[1],g)
pnet_sizes=matrix(0,1,max_k)
for (o in 1:max_k){pnet_sizes[o]=length(V(pnets[[o]]))}
  
hist(dispersion,freq=F,xlim=c(0,100),breaks=seq(-0.5, by=1 , length.out=max(dispersion)+2),main="Dispersion over PNets of all Core Nodes")
plot(1:length(dispersion),dispersion,xlab="Index",ylab="Dispersion",main="Dispersion plot")

#  ------------------------------------------------------------------------
cn_id = 20
core=core_nodes[cn_id]

per_net=pnets[[cn_id]]
core_nbrs = neighborhood(g,1,core)[[1]]
dispersion_1 = {}
for (p in 1:length(V(per_net))) {
  if (core != core_nbrs[p]) {
    dispersion_1= c(dispersion_1,disp(core,core_nbrs[p],g,per_net))
  }
}

emb_1 = {}
for (p in 1:length(V(per_net))) {
  if (core != core_nbrs[p]) {
    emb_1= c(emb_1,embdns(core,core_nbrs[p],g))
  }
}


for (q in 1:length(V(per_net))) {
  V(per_net)[q]$shape = "circle"
  V(per_net)[q]$size = 5
}

for (q in 1:length(E(per_net))) {
  E(per_net)[q]$color = "NA"
  E(per_net)[q]$width = 1
}

com_5 = fastgreedy.community(per_net)
V(per_net)$color = com_5$membership+1

max_disp = core_nbrs[which.max(dispersion_1)+1]
max_disp_id = which(V(per_net)$name==V(g)[max_disp]$name)
V(per_net)[max_disp_id]$shape = "rectangle"
V(per_net)[max_disp_id]$color = "black"

max_disp_eids=incident(per_net,max_disp_id)
for (q in 1:length(max_disp_eids)) {
  id = max_disp_eids[q]
  E(per_net)[id]$color = "red"
  E(per_net)[id]$width = 5
}


max_emb = core_nbrs[which.max(emb_1)+1]
max_emb_id = which(V(per_net)$name==V(g)[max_emb]$name)
V(per_net)[max_emb_id]$shape = "square"
V(per_net)[max_emb_id]$size = 10
V(per_net)[max_emb_id]$color = "black"

max_emb_eids=incident(per_net,max_emb_id)
for (q in 1:length(max_emb_eids)) {
  id = max_emb_eids[q]
  E(per_net)[id]$color = "green"
  E(per_net)[id]$width = 5
}

d_e = dispersion_1/emb_1

max_de = core_nbrs[which.max(d_e)+1]
max_de_id = which(V(per_net)$name==V(g)[max_de]$name)
V(per_net)[max_de_id]$size = 10
max_de_eids=incident(per_net,max_de_id)
for (q in 1:length(max_de_eids)) {
  id = max_de_eids[q]
  E(per_net)[id]$color = "blue"
  E(per_net)[id]$width = 5
}


plot(per_net,vertex.label=NA)



