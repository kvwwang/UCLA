import igraph

#%%
test_file = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/test_file.txt"
g = igraph.Graph.Read(test_file,format="ncol",directed=False)

#%%
tw = igraph.EdgeSeq(g)["weight"]

#%%
mov_edge_file = "D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/red_mov_net_edgelist.txt"

gm = igraph.Graph.Read(mov_edge_file,format="ncol",directed=False)

#%%

com = gm.community_fastgreedy(weights=igraph.EdgeSeq(gm)["weight"])

#%%
genrefile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_genre.txt",'r')
ratefile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_rating.txt",'r')
movfile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_5acts.txt",'r')

#%%
movies_dict = dict()
n_acts = 0
mov_id = 0

#%%
for line in movfile.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    mov_acts = linesplit[1:]   
    n_acts = len(mov_acts)
#    if n_acts<20:
#        mov_id+=1
#        continue
    mov_acts[n_acts-1] = mov_acts[n_acts-1].split("\n")[0]

    movies_dict[movname] = dict()    
    movies_dict[movname]['acts'] = mov_acts
    movies_dict[movname]['n_acts'] = n_acts
    movies_dict[movname]['id'] = mov_id
    movies_dict[movname]['neighbors'] = list()
    movies_dict[movname]['rating'] = -1
    movies_dict[movname]['genre'] = 'No Data'
    mov_id += 1
 
    

#%%

for line in genrefile.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    genres = linesplit[1:]   
    n_g = len(genres)
    genres[n_g-1] = genres[n_g-1].split("\n")[0]
    if movname in movies_dict.keys():
        movies_dict[movname]['genre'] = genres
        
#%%

for line in ratefile.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    ratings = linesplit[1:]   
    n_g = len(ratings)
    ratings[n_g-1] = ratings[n_g-1].split("\n")[0]
    if movname in movies_dict.keys():
        movies_dict[movname]['rating'] = float(ratings[0])
        
#%%
id_dict = dict()
for key in movies_dict.keys():
    movid = movies_dict[key]['id']    
    id_dict[movid] = key          
#%%
movfile.close()
genrefile.close()
ratefile.close()

    
#%%
memb_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/memb_file.txt",'r')
    
#%%

line = memb_file.readline()
ids = line.split("\t")
n_g = len(ids)
ids[n_g-1] = ids[n_g-1].split("\n")[0]
#%%
line = memb_file.readline()
membership = line.split("\t")
n_g = len(membership)
membership[n_g-1] = membership[n_g-1].split("\n")[0]
#%%
memb_dict = dict()
for k in range(0,n_g):
    com_id = membership[k]
    if membership[k] in memb_dict.keys():
        memb_dict[com_id]["movies"].append(int(ids[k]))
    else:
        memb_dict[com_id] = dict()
        memb_dict[com_id]["movies"] = list()
        memb_dict[com_id]["genres"] = dict()
        memb_dict[com_id]["tags"] = list()
        
    
 #%%
q = 0
for comm in memb_dict.keys():
    memb_dict[comm]["n_movs"] = len(memb_dict[comm]["movies"])
    for mov_id in memb_dict[comm]["movies"]:
        q +=1
        mov = id_dict[mov_id]
        mov_gen = movies_dict[mov]["genre"][0]
        if mov_gen in memb_dict[comm]["genres"].keys():
            memb_dict[comm]["genres"][mov_gen] +=1
        else:
            memb_dict[comm]["genres"][mov_gen] = 0
            
    for gen in memb_dict[comm]["genres"].keys():
        perc = memb_dict[comm]["genres"][gen]/memb_dict[comm]["n_movs"]
        if perc > 0.10:
            memb_dict[comm]["tags"].append(gen)

#%%
for comm in memb_dict.keys():
    print("Community",comm,"tags:")
    print(memb_dict[comm]["tags"],"\n")




        
    
