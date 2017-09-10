actdata = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/R_parse.txt",'r')
#line = actdata.readline()


#%%

act_dict = dict()
movies_dict = dict()
n_movies = 0
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
            
    act_dict[actname] = dict()
    act_dict[actname]['movies'] = actmovies_clean
    act_dict[actname]['n_movs'] = len(actmovies_clean) 
    act_dict[actname]['id'] = act_id
    act_dict[actname]['neighbors'] = list()
    act_id += 1      
    
    for m in actmovies_clean:
        if m in movies_dict:
            if actname not in movies_dict[m]:
                movies_dict[m].append(actname)
        else: #make new entry
            movies_dict[m] = list()
            movies_dict[m].append(actname)
            n_movies += 1

#%%
q = 0
for act in act_dict.keys():
    for actmov in act_dict[act]['movies']:
        acts = movies_dict[actmov]
        for a in acts:
            if (a != act):
                if a not in act_dict[act]['neighbors']:
                    act_dict[act]['neighbors'].append(a)
  
    if (q%1000==0):
        print(q)
    q+=1

#%%
act_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/act_net_edgelist.txt",'w')

#%%
z=0
y=0
x = 0
for act1 in act_dict.keys():
    z += 1
    a = act_dict[act1]['movies']
    Si = act_dict[act1]['n_movs']
    for act2 in act_dict[act1]['neighbors']:
        y += 1
        if (act1 == act2):
            continue
        else:
            b = act_dict[act2]['movies']
            inter = len(set(a).intersection(b))
            if (inter > 0):
                x += 1
                weight = round(inter/Si,3)
                act_net_file.write(str(act1)+"\t\t"+str(act2)+"\t\t"+str(weight)+"\n")
    
#    if (z%1000 == 0):
    print(z)
    
act_net_file.close()

#%%
act_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/actid_net_edgelist.txt",'w')

#%%
z=0
y=0
x = 0
for act1 in act_dict.keys():
    z += 1
    a = act_dict[act1]['movies']
    Si = act_dict[act1]['n_movs']
    id_1 = act_dict[act1]['id']
    for act2 in act_dict[act1]['neighbors']:
        y += 1
        if (act1 == act2):
            continue
        else:
            b = act_dict[act2]['movies']
            inter = len(set(a).intersection(b))
            if (inter > 0):
                x += 1
                id_2 = act_dict[act2]['id']
                weight = round(inter/Si,3)
                act_net_file.write(str(id_1)+"\t"+str(id_2)+"\t"+str(weight)+"\n")
    
    if (z%1000 == 0):
        print(z)
    
act_net_file.close()

#%%
mov_act_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_act.txt",'w')

while (len(movies_dict)>0):
    (key,value) = movies_dict.popitem()
    mov_act_file.write(key)
    for m in value:
        mov_act_file.write("\t\t"+str(m))
    mov_act_file.write("\n")

mov_act_file.close()

#%%
mov_5act_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_5acts.txt",'w')

while (len(movies_dict)>0):
    (key,value) = movies_dict.popitem()
    if (len(value)>=5):
        mov_5act_file.write(key)
        for m in value:
            mov_5act_file.write("\t\t"+str(m))
        mov_5act_file.write("\n")

mov_5act_file.close()
#%%
moviedata = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_act.txt",'r')
#moviedata = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/movie_5acts.txt",'r')

movies_dict = dict()
import numpy as np
#%%
union_dict = dict()
z = 0
y = 0
for line in moviedata.readlines():
    linesplit = line.split("\t\t")
    movname = linesplit[0]
    acts = linesplit[1:]
    n_acts = len(acts)
    acts[n_acts-1] = acts[n_acts-1].split("\n")[0]
    
    if (n_acts > 1):
        for i in range(0,n_acts):
#            i_id = act_dict[acts[i]]['id']
            for j in range(i+1,n_acts):
#                j_id = act_dict[acts[j]]['id']
#                key_ij = (i_id,j_id)
#                key_ji = (j_id,i_id)   
                key_ij = (acts[i],acts[j])
                key_ji = (acts[j],acts[i])          
              
                if (key_ij in union_dict):
                    union_dict[key_ij] += 1
                elif (key_ji in union_dict):
                    union_dict[key_ji] += 1
                else:
                    union_dict[key_ij] = np.uint8(1)
                    y += 1
#                    union_dict[key_ji] = np.uint16(1) 
    z +=1
    if (z%1000 == 0):
        print(z)

#%%

union_dict = dict()
z=0
for mov, acts in movies_dict.items():
    n_acts = len(acts)
    if (n_acts > 1):
        for i in range(0,n_acts):
            for j in range(i+1,n_acts):
                key_ij = (acts[i],acts[j])
                key_ji = (acts[j],acts[i])
                if (key_ij in union_dict):
                    union_dict[key_ij] += 1
                elif (key_ji in union_dict):
                    union_dict[key_ji] += 1
                else:
                    union_dict[key_ij] = 1
#                    union_dict[key_ji] = np.uint16(1) 
    z +=1
    if (z%1000 == 0):
        print(z)
    if (z==530945):
        break
    

     
     
#%%
#union_dict = dict()
#z=0
#for mov, acts in movies_dict.items():
#    n_acts = len(acts)
#    if (n_acts > 1):
#        for i in range(0,n_acts):
#            for j in range(i+1,n_acts):
#                key_ij = (acts[i],acts[j])
#                key_ji = (acts[j],acts[i])
#                if (key_ij in union_dict):
#                    union_dict[key_ij] += 1
#                elif (key_ji in union_dict):
#                    union_dict[key_ji] += 1
#                else:
#                    union_dict[key_ij] = 1
##                    union_dict[key_ji] = np.uint16(1) 
#    z +=1
#    if (z%1000 == 0):
#        print(z)
#    if (z==530945):
#        break
#    
#            

#%%
















