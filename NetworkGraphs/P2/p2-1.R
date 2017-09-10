library(igraph)

datapath = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data"
setwd(datapath)

p2files = list.files(path=datapath)
actorfile = p2files[1]; actressfile = p2files[2]; directorfile = p2files[3];
genrefile = p2files[4]; ratingfile = p2files[5];

actfiles = c(actorfile,actressfile)
# tot_actors = 2167653; tot_actresses = 1182813;
n_act = 0;

for (j in 1:2) {
  f = file(actfiles[j])
  flines = readLines(f)
  
  for (k in 1:length(flines)) {
    line = flines[k]
    linesplit = strsplit(line,"\t\t")[[1]]
    name = linesplit[1]  
    mov = linesplit[-1]
    if (length(mov)>=5) {
      n_act = n_act+1;
    }
    if (k %% 1000 == 0) {
      print(k);
    }
  }
  close(f)
}

# n_act = 244293;

act_names = list()
movies = list()
dat_ind = 1;
for (j in 1:2) {
  f = file(actfiles[j])
  flines = readLines(f)
  
  for (k in 1:length(flines)) {
    line = flines[k]
    linesplit = strsplit(line,"\t\t")[[1]]
    name = linesplit[1]  
    mov = linesplit[-1]
    if (length(mov)>=5) {
      act_names[dat_ind] = name
      movies[[dat_ind]] = mov
      dat_ind = dat_ind+1
    }
    if (k %% 1000 == 0) {
      print(k);
    }    
  }
  close(f)
}


g_act = graph.empty(n=n_act,directed=T)
V(g_act)$name = act_names

for (i in 1:n_act) {
  eadd = list()
  w = list()
  k = 1
  for (j in 1:n_act){
    if (i != j) {
      inter = length(intersect(movies[[i]],movies[[j]]))
      if (inter>0) {
        Si = length(movies[[i]])
        w[k] = inter/Si
        eadd[[k]] = c(i,j)
        k = k+1
      }
    }
    # if (j %% 1000 == 0) {
    #   print(j)
    # }
  }
  eds = unlist(eadd)
  wts = unlist(w)
  g_act = add.edges(g_act,eds,weight=wts)
  print(i)
}

# g_act = add.edges(g_act,c(i,j),weight=w)

newlines = vector(mode="character",length=n_act)
nf = "R_parse.txt"
for (n in 1:n_act) {
  l = c(act_names[n],movies[[n]])
  newlines[n] = paste(l,collapse="\t\t")
  
  if (n %% 1000 == 0) {
    print(n)
  }
}

write(newlines,nf)


f = file(nf)
ltest = readLines(nf)
close(f)

# writeLines(unlist(lapply(l, paste, collapse=" ")))
