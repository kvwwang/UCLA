library(igraph)

datapath = "D:/Assignments/Graduate/EE232E/P1/gplus"
setwd(datapath)

edgedata = list.files(path=datapath,pattern="edges")
circdata = list.files(path=datapath,pattern="circles")
n_nets = length(edgedata)

user_ids = matrix(0,1,n_nets)
for (k in 1:n_nets) {
  user_ids[k] = (gsub("\\.edges","",edgedata[k]))
}

n_qual = 0
qual_inds = {}
jaccard_info = list()
jaccard_walk = list()
all_jac_i = {}
all_jac_w = {}
xlines = {}
for (k in 1:n_nets) {
  f=file(circdata[k])  
  flines = readLines(f)
  nl = length(flines)
  if (nl>2) {
    circ = list()
    for (j in 1:nl) {
      circ[[j]]=strsplit(flines[j],split="\t")[[1]][-1]  
    }
    n_qual=n_qual+1
    qual_inds = c(qual_inds,k) 
    
    ge = read.graph(edgedata[k],format="ncol",directed=T)
    gego = add.vertices(ge,1,name=user_ids[k])
    
    ego_ind = which(V(gego)$name==user_ids[k])
    new_edges = {}
    for (p in 1:length(V(gego))) {
      new_edges = c(new_edges,ego_ind,p)
    }
    g_ego = add.edges(gego,edges=new_edges)
    
    com_info = infomap.community(g_ego)
    com_walk = walktrap.community(g_ego)
    
    g_info = g_ego
    g_walk = g_ego
    V(g_info)$color = com_info$membership+1
    V(g_walk)$color = com_walk$membership+1  
    
    n_infocoms = length(sizes(com_info))
    n_walkcoms = length(sizes(com_walk))
    # n_circ = nl
    
    jack_info = matrix(0,nl,n_infocoms)
    for (u in 1:nl) {
      circ1 = circ[[u]]
      for (w in 1:n_infocoms) {
        infomemb = which(com_info$membership==w)
        info_nodes = {}
        for (r in 1:length(infomemb)) {
          info_nodes = c(info_nodes,V(g_info)[infomemb[r]]$name)  
        }
        
        inter = intersect(circ1,info_nodes)
        un = union(circ1,info_nodes)
        jack = length(inter)/length(un)
        jack_info[u,w]=jack
        all_jac_i = c(all_jac_i,jack)
      }
    }
    jaccard_info[[n_qual]] = jack_info
    
    jack_walk = matrix(0,nl,n_walkcoms)
    for (u in 1:nl) {
      circ1 = circ[[u]]
      for (w in 1:n_walkcoms) {
        walkmemb = which(com_walk$membership==w)
        walk_nodes = {}
        for (r in 1:length(walkmemb)) {
          walk_nodes = c(walk_nodes,V(g_walk)[walkmemb[r]]$name)  
        }
        
        inter = intersect(circ1,walk_nodes)
        un = union(circ1,walk_nodes)
        jack = length(inter)/length(un)
        jack_walk[u,w]=jack
        all_jac_w = c(all_jac_w,jack)
      }
    }
    jaccard_walk[[n_qual]] = jack_walk
    
    xlines = c(xlines,length(all_jac_i))
    
    # plot(g_info,vertex.size=5,vertex.label=NA,edge.arrow.size=0.1)
      
  }
  close(f)
  print(k)
}

plot(g_info,vertex.size=5,vertex.label=NA,edge.arrow.size=0.1)
plot(g_walk,vertex.size=5,vertex.label=NA,edge.arrow.size=0.1)

g_circ=g_ego

xlines_w = {}
for (o in 1:57) {
  len = prod(dim(jaccard_walk[[o]]))
  if (length(xlines_w)>0) {
    new_len = len+tail(xlines_w,n=1)
  } else {
    new_len = len
  }
  xlines_w = c(xlines_w,new_len)  
}

plot(all_jac_w,ylab="Jaccard Index",main="Walktrap")
abline(v=xlines_w[1:56])

plot(all_jac_i,ylab="Jaccard Index",main="Infomap")
abline(v=xlines[1:56])

max_walk = {}
max_info = {}
mw_lines = {}
mi_lines = {}
for (k in 1:57) {
  jw = jaccard_walk[[k]]
  for (j in 1:nrow(jw)) {
    max_walk = c(max_walk,max(jw[j,]))
  }
  mw_lines=c(mw_lines,length(max_walk))
  
    
  ji = jaccard_info[[k]] 
  for (j in 1:nrow(ji)) {
    max_info = c(max_info,max(ji[j,]))
  }  
  mi_lines=c(mi_lines,length(max_info))
}

plot(max_info,ylab="Jaccard Distance",main="Infomap Max Jaccard per Circle")
abline(v=mi_lines[1:56])

plot(max_walk,ylab="Jaccard Distance",main="Walktrap Max Jaccard per Circle")
abline(v=mw_lines[1:56])

