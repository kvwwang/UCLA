# -*- coding: utf-8 -*-

#%%

from sklearn.datasets import fetch_20newsgroups
#%%

comp_cat = ['comp.graphics','comp.os.ms-windows.misc','comp.sys.ibm.pc.hardware','comp.sys.mac.hardware']
rec_cat = ['rec.autos','rec.motorcycles','rec.sport.baseball','rec.sport.hockey']

comp_train = fetch_20newsgroups(subset='train', categories=comp_cat, shuffle=True, random_state=42)
rec_train = fetch_20newsgroups(subset='train', categories=rec_cat, shuffle=True, random_state=42)


#%%

print(comp_train.target_names)
len(comp_train.data)
len(rec_train.data)

#%%
comp_train1 = fetch_20newsgroups(subset='train', categories=['comp.graphics'], shuffle=True, random_state=42)
comp_train2 = fetch_20newsgroups(subset='train', categories=['comp.os.ms-windows.misc'], shuffle=True, random_state=42)
comp_train3 = fetch_20newsgroups(subset='train', categories=['comp.sys.ibm.pc.hardware'], shuffle=True, random_state=42)
comp_train4 = fetch_20newsgroups(subset='train', categories=['comp.sys.mac.hardware'], shuffle=True, random_state=42)
len(comp_train1.data)
len(comp_train2.data)
len(comp_train3.data)
len(comp_train4.data)
len(comp_train.data)
#%%
rec_train1 = fetch_20newsgroups(subset='train', categories=['rec.autos'], shuffle=True, random_state=42)
rec_train2 = fetch_20newsgroups(subset='train', categories=['rec.motorcycles'], shuffle=True, random_state=42)
rec_train3 = fetch_20newsgroups(subset='train', categories=['rec.sport.baseball'], shuffle=True, random_state=42)
rec_train4 = fetch_20newsgroups(subset='train', categories=['rec.sport.hockey'], shuffle=True, random_state=42)
len(rec_train1.data)
len(rec_train2.data)
len(rec_train3.data)
len(rec_train4.data)
len(rec_train.data)
#%%
help(comp_train)