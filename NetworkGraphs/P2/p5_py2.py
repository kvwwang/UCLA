mov_net_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/mov_net_edgelist.txt",'r')
mov_edge_file = open("D:/Assignments/Graduate/EE232E/P2/project_2_data/project_2_data/mov_edgelist.txt",'w')

fin = 141280336
#%%
used_edges = dict()

#%%
q = 0
for line in mov_net_file.readlines():
    q+=1    
    linesplit = line.split("\t")
    linelen = len(linesplit)
    linesplit[linelen-1] = linesplit[linelen-1].split("\n")[0]
    id_1 = linesplit[0]
    id_2 = linesplit[1]
    weight = linesplit[2]

    if (id_1 not in used_edges.keys() and id_2 not in used_edges.keys()):    
        mov_edge_file.write(str(id_1)+"\t"+str(id_2)+"\t"+str(weight)+"\n")
        used_edges[id_1] = list()
        used_edges[id_1].append(id_2)
    
    if (q%10000 == 0):
        print(q)        
        
#%%
mov_net_file.close()
mov_edge_file.close()
