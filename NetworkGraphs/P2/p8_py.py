actdata = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/R_parse.txt",'r')

#%%
act_dict = dict()
act_id = 0

#%%
for line in actdata.readlines():
    linesplit = line.split("\t\t")
    actname = linesplit[0]
    actmovies = linesplit[1:]
    
    actmovies_clean = []
    for k in range(0,len(actmovies)):
        cur_mov = actmovies[k]
        endind = cur_mov.find(')')
        if (endind != -1):
            actmovies_clean.append(cur_mov[0:endind+1])
            
    act_dict[act_id] = dict()
#    act_dict[actname]['movies'] = actmovies_clean
    act_dict[act_id]['n_movs'] = len(actmovies_clean) 
    act_dict[act_id]['id'] = actname
#    act_dict[actname]['neighbors'] = list()
    act_id += 1      

actdata.close()

#%%
pagerank_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/pagerank_file.txt",'r')
#%%
line = pagerank_file.readline()
ids = line.split("\t")
n_g = len(ids)
ids[n_g-1] = ids[n_g-1].split("\n")[0]
#%%
line = pagerank_file.readline()
pagerank = line.split("\t")
line = ''
n_g = len(pagerank)
pagerank[n_g-1] = pagerank[n_g-1].split("\n")[0]
#%%
for k in range(0,n_g):
    int_id = int(ids[k])
    act_dict[int_id]['pagerank'] = pagerank[k]

#%%
pagerank_file.close()
ids = []
pagerank = []

#%%
movfile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/red_movies.txt",'r')
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
    mov_acts[n_acts-1] = mov_acts[n_acts-1].split("\n")[0]

    movies_dict[movname] = dict()    
    movies_dict[movname]['acts'] = mov_acts
    movies_dict[movname]['n_acts'] = n_acts
    movies_dict[movname]['id'] = mov_id
#    movies_dict[movname]['neighbors'] = list()
    movies_dict[movname]['director'] = False
    mov_id += 1

movfile.close()
#%%
top_dir_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/top_directors.txt",'r')

#%%
top_directors = list()

for line in top_dir_file.readlines():
    dire = line.split("\n")[0]
    top_directors.append(dire)    

top_dir_file.close()
#%%
dirfile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/director_movies.txt",'r')
#%%

n_top_movs = 0
for line in dirfile.readlines():
    linesplit = line.split("\t\t")
    dirname = linesplit[0]
    if dirname in top_directors:
        dir_movs = linesplit[1:]   
        n_acts = len(dir_movs)
        dir_movs[n_acts-1] = dir_movs[n_acts-1].split("\n")[0]
        for mov in dir_movs:
            if mov in movies_dict.keys():
                movies_dict[mov]['director'] = True
                n_top_movs += 1

dirfile.close()
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
        memb_dict[com_id]["movies"].append(int(ids[k]))

ids = ''
membership = ''
memb_file.close()

#%%
id_dict = dict()
for key in movies_dict.keys():
    movid = movies_dict[key]['id']    
    id_dict[movid] = key
#%%
act_name_dict = dict()
for key in act_dict.keys():
    actname = act_dict[key]['id']    
    act_name_dict[actname] = key

#%%
ratefile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_rating.txt",'r')
#%%
for mov in movies_dict.keys():
    movies_dict[mov]["rating"] = -1
#%%

for line in ratefile.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    ratings = linesplit[1:]   
    n_g = len(ratings)
    ratings[n_g-1] = ratings[n_g-1].split("\n")[0]
    if movname in movies_dict.keys():
        movies_dict[movname]['rating'] = float(ratings[0])

ratefile.close()
#%%
genrefile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_genre.txt",'r')
#%%
for mov in movies_dict.keys():
    movies_dict[mov]['genre'] = "No Data"
#%%
for line in genrefile.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    genres = linesplit[1:]   
    n_g = len(genres)
    genres[n_g-1] = genres[n_g-1].split("\n")[0]
    if movname in movies_dict.keys():
        movies_dict[movname]['genre'] = genres

genrefile.close()
#%%
com1_dict = dict()

#%%
for mov_id in memb_dict['1']["movies"]:
    mov_name = id_dict[mov_id]
    
    if movies_dict[mov_name]['genre'] == "No Data":
        continue
    
    if movies_dict[mov_name]['rating'] < 0:
        continue
    
    pr_list = list()    
    for act in movies_dict[mov_name]["acts"]:
        if act in act_name_dict.keys():
            key = act_name_dict[act]
            pr_list.append(float(act_dict[key]["pagerank"]))
    
    if (len(pr_list) >= 5):
        top5prs = sorted(pr_list,reverse=True)[:5]
        com1_dict[mov_name] = dict()
        com1_dict[mov_name]["pageranks"] = top5prs
    else:
        continue
    
    if (movies_dict[mov_name]["director"]):
        com1_dict[mov_name]["director"] = 'T'
    else:
        com1_dict[mov_name]["director"] = 'F'
    
    com1_dict[mov_name]["n_acts"] = movies_dict[mov_name]["n_acts"]
    
    com1_dict[mov_name]["genre"] = movies_dict[mov_name]["genre"]
    
    com1_dict[mov_name]["rating"] = movies_dict[mov_name]["rating"]

#%%
data_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/com1_data.txt",'w')
#%%
for mov in com1_dict.keys():    
    data_file.write(str(com1_dict[mov]["rating"])+"\t")
    data_file.write(com1_dict[mov]["genre"][0]+"\t")
    data_file.write(str(com1_dict[mov]["n_acts"])+"\t")
    for pr in com1_dict[mov]["pageranks"]:
        data_file.write(str(pr)+"\t")
    data_file.write(com1_dict[mov]["director"]+"\n")

data_file.close()

#%%
new_movie_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/new_movies.txt",'r')

#%%
new_movies_dict = dict()

#%%

for line in new_movie_file.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    mov_acts = linesplit[1:]   
    n_acts = len(mov_acts)
    mov_acts[n_acts-1] = mov_acts[n_acts-1].split("\n")[0]

    new_movies_dict[movname] = dict()    
    new_movies_dict[movname]['acts'] = mov_acts
    new_movies_dict[movname]['n_acts'] = n_acts 

new_movie_file.close()
#%%
for mov_name in new_movies_dict.keys():
    pr_list = list()    
    for act in new_movies_dict[mov_name]["acts"]:
        if act in act_name_dict.keys():
            key = act_name_dict[act]
            pr_list.append(float(act_dict[key]["pagerank"]))
    
    if (len(pr_list) >= 5):
        top5prs = sorted(pr_list,reverse=True)[:5]
        new_movies_dict[mov_name]["pageranks"] = top5prs

    new_movies_dict[mov_name]["n_acts"] = len(pr_list)

#%%
new_movies_dict["Batman v Superman: Dawn of Justice (2016)"]["genre"] = "Action"
new_movies_dict["Batman v Superman: Dawn of Justice (2016)"]["director"] =  "F"
new_movies_dict["Batman v Superman: Dawn of Justice (2016)"]["rating"] = 7.1

new_movies_dict["Mission: Impossible - Rogue Nation (2015)"]["genre"] = "Action"
new_movies_dict["Mission: Impossible - Rogue Nation (2015)"]["director"] =  "F"
new_movies_dict["Mission: Impossible - Rogue Nation (2015)"]["rating"] = 7.5

new_movies_dict["Minions (2015)"]["genre"] = "Comedy"
new_movies_dict["Minions (2015)"]["director"] =  "F"
new_movies_dict["Minions (2015)"]["rating"] =  6.4

#%%
new_data_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/new_data.txt",'w')
#%%
for mov in new_movies_dict.keys():  
    new_data_file.write(mov+"\t")
    new_data_file.write(str(new_movies_dict[mov]["rating"])+"\t")
    new_data_file.write(new_movies_dict[mov]["genre"]+"\t")
    new_data_file.write(str(new_movies_dict[mov]["n_acts"])+"\t")
    for pr in new_movies_dict[mov]["pageranks"]:
        new_data_file.write(str(pr)+"\t")
    new_data_file.write(new_movies_dict[mov]["director"]+"\n")

new_data_file.close()


        



