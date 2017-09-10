# -*- coding: utf-8 -*-
#%%
import numpy as np
data = np.loadtxt('u.data')

#%%
R = np.zeros([943,1682])

for k in range(0,100000):
    R[data[k,0]-1,data[k,1]-1] = data[k,2]

#%%
R_vect = np.reshape(R,943*1682)
W_vect = []
for k in range(0,len(R_vect)):
    if R_vect[k] == 0:
        W_vect.append(-1)
    else:
        W_vect.append(1)

W = np.reshape(W_vect,(943,1682))

#%%
from sklearn.decomposition import NMF

model10 = NMF(n_components=10,random_state=42,alpha=0)
U10 = model10.fit_transform(R)
V10 = model10.components_

model50 = NMF(n_components=50,random_state=42,alpha=0)
U50 = model50.fit_transform(R)
V50 = model50.components_

model100 = NMF(n_components=100,random_state=42,alpha=0)
U100 = model100.fit_transform(R)
V100 = model100.components_

#er1 = [model10.reconstruction_err_,model50.reconstruction_err_,model100.reconstruction_err_]
#%%

WR = np.multiply(R,W)

UV10 = np.dot(U10,V10)
WUV10 = np.multiply(UV10,W)
E_10 = np.linalg.norm(WR-WUV10,ord='fro')

UV50 = np.dot(U50,V50)
WUV50 = np.multiply(UV50,W)
E_50 = np.linalg.norm(WR-WUV50,ord='fro')

UV100 = np.dot(U100,V100)
WUV100 = np.multiply(UV100,W)
E_100 = np.linalg.norm(WR-WUV100,ord='fro')

#%%

X1 = np.dot(W10,H10)
E101 = np.linalg.norm(R-X1,ord='fro')

