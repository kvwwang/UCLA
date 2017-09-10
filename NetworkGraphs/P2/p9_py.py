actdata = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/R_parse.txt",'r')
#line = actdata.readline()


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
            
    act_dict[actname] = dict()
    act_dict[actname]['movies'] = actmovies_clean
    act_dict[actname]['n_movs'] = len(actmovies_clean) 
    act_dict[actname]['id'] = act_id
    act_dict[actname]['neighbors'] = list()
    act_id += 1      
    
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
import statistics as st
#%%
for mov in new_movies_dict.keys():
    mov_act_rates = list()
    for act in new_movies_dict[mov]["acts"]:
        act_rates = list()
        if act in act_dict.keys():
            for amov in act_dict[act]["movies"]:
                if amov in movies_dict.keys():
                    if movies_dict[amov]["rating"] >= 0:
                        act_rates.append(movies_dict[amov]["rating"])
            if len(act_rates)>0:
                mov_act_rates.append(st.mean(act_rates))
    print(mov+": "+str(st.mean(mov_act_rates)))            
        
        
        
        
