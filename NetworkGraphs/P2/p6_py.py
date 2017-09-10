use_reduced = True

if (use_reduced):
    movfile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/red_movies.txt",'r')
else:
    movfile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_5acts.txt",'r')

#%%
act_dict = dict()
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
    movies_dict[movname]['neighbors'] = list()
    mov_id += 1

    for m in mov_acts:
        if m in act_dict:
            if movname not in act_dict[m]:
                act_dict[m].append(movname)
        else: #make new entry
            act_dict[m] = list()
            act_dict[m].append(movname)
            n_acts += 1    

movfile.close()
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
    new_movies_dict[movname]['id'] = mov_id
    new_movies_dict[movname]['neighbors'] = list()
    mov_id += 1

    for m in mov_acts:
        if m in act_dict:
            if movname not in act_dict[m]:
                act_dict[m].append(movname)
        else: #make new entry
            act_dict[m] = list()
            act_dict[m].append(movname)
            n_acts += 1    

new_movie_file.close()
#%%
q = 0
for mov in new_movies_dict.keys():
    for movact in new_movies_dict[mov]['acts']:
        movs = act_dict[movact]
        for m in movs:
            if (m != mov):
                if m not in new_movies_dict[mov]['neighbors']:
                    new_movies_dict[mov]['neighbors'].append(m)
                    
    if (q%1000==0):
        print(q)
    q+=1

#%%
new_edgefile = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/new_edges.txt",'w')
new_weights = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/new_weights.txt",'w')
#%%
used_edges = dict()

#%%
z=0
y=0
x = 0
for mov1 in new_movies_dict.keys():
    z += 1
    a = new_movies_dict[mov1]['acts']
    id_1 = new_movies_dict[mov1]['id']
    for mov2 in new_movies_dict[mov1]['neighbors']:
        y += 1
        id_2 = movies_dict[mov2]['id']
        b = movies_dict[mov2]['acts']
        inter = len(set(a).intersection(b))
        if (inter > 0):
            x += 1
            uni = len(set(a).union(b))
            weight = round(inter/uni,3)
            new_edgefile.write(str(id_1)+"\n")
            new_edgefile.write(str(id_2)+"\n")
            new_weights.write(str(weight)+"\n")
    used_edges[id_1] = []
    
    if (z%1000 == 0):
        print(z)
    
new_weights.close()
new_edgefile.close()

#%%
BvS_DoJ = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/BvS_DoJ.txt",'w')
MI_RN = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/MI_RN.txt",'w')
minions = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/minions.txt",'w')
#%%
z=1
for mov1 in new_movies_dict.keys():
    if (z==1):
        f = BvS_DoJ
    elif (z==2):
        f = MI_RN
    else:
        f = minions
    
    a = new_movies_dict[mov1]['acts']
    id_1 = new_movies_dict[mov1]['id']
    for mov2 in new_movies_dict[mov1]['neighbors']:
        id_2 = movies_dict[mov2]['id']
        b = movies_dict[mov2]['acts']
        inter = len(set(a).intersection(b))
        if (inter > 0):
            uni = len(set(a).union(b))
            weight = round(inter/uni,3)
            f.write(str(id_2)+"\t"+str(weight)+"\n")
    used_edges[id_1] = []
    
    z += 1
    f.close()

#%%
id_dict = dict()
for key in movies_dict.keys():
    movid = movies_dict[key]['id']    
    id_dict[movid] = key 
    
    #%%
#BvS = [26120, 24680, 29692,16924, 26655]
#BvS= [12437 ,14414, 12327 ,4502, 38512]
BvS = [2359, 8205, 43734, 14004, 40379]

for k in BvS:
    print(id_dict[k])
    
#%%
for mov1 in new_movies_dict.keys():
    print(mov1)

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

#%%
for com_id in memb_dict.keys():
    memb_dict[com_id]["n_ratings"] = 0
    temp_sum = 0
    for mov_id in memb_dict[com_id]["movies"]:
        if mov_id in id_dict:
            mov = id_dict[mov_id]
            if movies_dict[mov]["rating"] >= 0:
                temp_sum += movies_dict[mov]["rating"]
                memb_dict[com_id]["n_ratings"] += 1
    if memb_dict[com_id]["n_ratings"] > 0:
        memb_dict[com_id]["avg_rating"] = temp_sum/memb_dict[com_id]["n_ratings"]
    else:
        memb_dict[com_id]["avg_rating"] = -1    
    
    print(com_id+" rating: "+str(memb_dict[com_id]["avg_rating"]))

#%%
for mov in new_movies_dict.keys():
    temp_sum = 0
    n_nei_rates = 0
    for n in new_movies_dict[mov]["neighbors"]:
        nei_rate = movies_dict[n]["rating"]
        if nei_rate >= 0:
            temp_sum += nei_rate
            n_nei_rates += 1
    
    new_movies_dict[mov]["nei_rate"] = temp_sum/n_nei_rates
    
    print(mov+": "+str(new_movies_dict[mov]["nei_rate"]))
    
#%%
new_movies_dict["Mission: Impossible - Rogue Nation (2015)"]["top 5"] = [26120, 24680, 29692,16924, 26655]
new_movies_dict["Batman v Superman: Dawn of Justice (2016)"]["top 5"] = [12437 ,14414, 12327 ,4502, 38512]
new_movies_dict["Minions (2015)"]["top 5"] = [2359, 8205, 43734, 14004, 40379]

#%%
for mov in new_movies_dict.keys():
    temp_sum = 0
    n_nei_rates = 0
    for n_id in new_movies_dict[mov]["top 5"]:
        n = id_dict[n_id]
        nei_rate = movies_dict[n]["rating"]
        if nei_rate >= 0:
            temp_sum += nei_rate
            n_nei_rates += 1
    
    new_movies_dict[mov]["nei_rate"] = temp_sum/n_nei_rates
    
    print(mov+": "+str(new_movies_dict[mov]["nei_rate"]))

#%%

r1=0.25*6.133755247013227+0.35*6.526760563380281+0.4*6.639999999999999
r2=0.25*6.133755247013227+0.35*6.496065573770496+0.4*6.88
r3=0.25*6.133755247013227+0.35*6.520377358490566+0.4*6.466666666666666


