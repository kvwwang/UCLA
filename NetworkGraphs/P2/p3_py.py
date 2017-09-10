#%%
id_dict = dict()
for key in act_dict.keys():
    actid = act_dict[key]['id']    
    id_dict[actid] = key             
#%%
top10pr = [180962,66948,  57601,  94323,  137181, 124106, 117934, 13715  ,70569,  42765]
#%%
for v in range(0,9):
    print(top10pr[v],": ",id_dict[top10pr[v]])
    
    
 #%%

t10_acts = ["Downey Jr., Robert","Clooney, George","Depp, Johnny","Cruise, Tom","DiCaprio, Leonardo","Pitt, Brad","Lawrence, Jennifer (III)","Johnson, Dwayne (I)", "Hanks, Tom", "Bullock, Sandra"]

#%%
for v in range(0,10):
    print(t10_acts[v],": ",act_dict[t10_acts[v]]['id'])

#%%
act_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/act_net_edgelist.txt",'r')
#%%
n_pairs = 0
used_acts = list()
common_fracs = [0.6, 0.8, round(5/6,3), round(4/6,3), round(5/7,3), round(6/7,3), 6/8, 5/8, 7/8, 0.778, 0.889]
for line in act_net_file.readlines():
    linesplit = line.split("\t\t")
    weight = float(linesplit[2].split("\n")[0])
    if (weight > 0.9 and weight < 1 and weight not in common_fracs and linesplit[0] not in used_acts):
        n_pairs += 1
        used_acts.append(linesplit[0])
        print(linesplit[0]," + ",linesplit[1]," = ",weight)
    if (n_pairs > 15):
        break
