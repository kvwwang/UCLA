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
    

#%%
q = 0
for mov in movies_dict.keys():
    for movact in movies_dict[mov]['acts']:
        movs = act_dict[movact]
        for m in movs:
            if (m != mov):
                if m not in movies_dict[mov]['neighbors']:
                    movies_dict[mov]['neighbors'].append(m)
                    
    if (q%1000==0):
        print(q)
    q+=1

movfile.close()
#%%
if (use_reduced):
    mov_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/red_mov_net_edgelist.txt",'w')
else:
    mov_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/mov_net_edgelist.txt",'w')

#%%
used_edges = dict()

#%%
z=0
y=0
x = 0
for mov1 in movies_dict.keys():
    z += 1
    a = movies_dict[mov1]['acts']
    id_1 = movies_dict[mov1]['id']
    for mov2 in movies_dict[mov1]['neighbors']:
        y += 1
        id_2 = movies_dict[mov2]['id']
        if (mov1 == mov2 or id_2 in used_edges.keys()):
            continue
        else:
            b = movies_dict[mov2]['acts']
            inter = len(set(a).intersection(b))
            if (inter > 0):
                x += 1
                uni = len(set(a).union(b))
                weight = round(inter/uni,3)
                mov_net_file.write(str(id_1)+"\t"+str(id_2)+"\t"+str(weight)+"\n")
    used_edges[id_1] = []
    
    if (z%1000 == 0):
        print(z)
    
mov_net_file.close()




