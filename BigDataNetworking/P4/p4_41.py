import sys,tarfile, json, os
import numpy as np
import datetime, time
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import random
os.chdir('D:\Assignments\Graduate\EE239AS\P4\Data')

#%% Select dataset

#data = open('tweets_#superbowl.txt',encoding='utf8')
#data = open('tweets_#sb49.txt',encoding='utf8')
#data = open('tweets_#patriots.txt',encoding='utf8')
#data = open('tweets_#gohawks.txt',encoding='utf8')
data = open('tweets_#gopatriots.txt',encoding='utf8')
#data = open('tweets_#nfl.txt',encoding='utf8')

#%%

n_tweets = 0

line = data.readline()
firstpost_date = []
followers = []
ret_cit = []
fav_count = []
ret_count = []
rep_count = []

while len(line)!=0:
    tweet = json.loads(line)
    n_tweets+=1
    followers.append(tweet['author']['followers'])
    ret_cit.append(tweet['metrics']['citations']['total'])
    firstpost_date.append(tweet['firstpost_date'])
    fav_count.append(tweet['tweet']['favorite_count'])
    ret_count.append(tweet['tweet']['retweet_count'])
    rep_count.append(tweet['metrics']['citations']['replies'])
    line = data.readline()    
    print(n_tweets)
    
#%%

tweets_cur = []
tot_ret = []
tot_fol = []
max_fol = []
time_hour = []
tot_fav = []
tot_ret_c = []
tot_rep = []

prev_hour = time.localtime(firstpost_date[0]).tm_hour
n_twt_hour = 0
n_ret_hour = 0
n_fol_hour = 0
max_fol_hour = 0
n_fav_hour = 0
n_ret_c_hour = 0
n_rep_hour = 0

for k in range(0,n_tweets):
    hour = time.localtime(firstpost_date[k]).tm_hour
    if (hour!=prev_hour):
        tweets_cur.append(n_twt_hour)
        tot_ret.append(n_ret_hour)
        tot_fol.append(n_fol_hour)
        max_fol.append(max_fol_hour)
        time_hour.append(prev_hour)
        tot_fav.append(n_fav_hour)
        tot_ret_c.append(n_ret_c_hour)
        tot_rep.append(n_rep_hour)
        
        prev_hour = (prev_hour+1)%24
        n_twt_hour = 0
        n_ret_hour = 0
        n_fol_hour = 0
        max_fol_hour = 0  
        n_fav_hour = 0
        n_ret_c_hour = 0
        n_rep_hour = 0        
        while (prev_hour != hour):
            tweets_cur.append(n_twt_hour)
            tot_ret.append(n_ret_hour)
            tot_fol.append(n_fol_hour)
            max_fol.append(max_fol_hour)
            time_hour.append(prev_hour)
            tot_fav.append(n_fav_hour)
            tot_ret_c.append(n_ret_c_hour)
            tot_rep.append(n_rep_hour)
            prev_hour = (prev_hour+1)%24
                  
    n_twt_hour+=1
    n_ret_hour+=ret_cit[k]
    n_fol_hour+=followers[k]
    n_fav_hour+=fav_count[k]
    n_ret_c_hour+=ret_count[k]
    n_rep_hour+=rep_count[k]
    if (followers[k]>max_fol_hour):
        max_fol_hour = followers[k]
    
#%%

tweets_next = list(tweets_cur)
tweets_next.pop(0)
tweets_cur.pop()
tot_ret.pop()
tot_fol.pop()
max_fol.pop()
time_hour.pop()
tot_fav.pop()
tot_ret_c.pop()
tot_rep.pop()

#%%
features = np.array([tweets_cur,tot_ret,tot_fol,tot_fav,tot_ret_c]).T
target = np.array(tweets_next)

#%%
n_cv = 10
n_data_pts = len(target)
cv_data_ind = np.array(range(0,n_data_pts))
random.seed(42)
random.shuffle(cv_data_ind)

cv_size = np.int(np.floor(n_data_pts*0.1))
cv_ind = [0]
for l in range(1,10):
    cv_ind.append(cv_size*l)
cv_ind.append(n_data_pts)

#%%
errors = []
for q in range(0,n_cv):
    train_feat = []
    test_feat = []
    train_targ = []
    test_targ = []
    test_pts = np.array(cv_data_ind[cv_ind[q]:cv_ind[q+1]])
    for s in range(0,n_data_pts):
        if s in test_pts:
            test_feat.append(features[s][:])
            test_targ.append(target[s])
        else:
            train_feat.append(features[s][:])
            train_targ.append(target[s])
    
    train_features = np.array(train_feat)
    train_target = np.array(train_targ)
    test_features = np.array(test_feat)
    test_target = np.array(test_targ)        
    
    lr = LinearRegression()
    lr.fit(train_features,train_target)
    test_pred = lr.predict(test_features)  
    error = np.absolute(test_pred-test_target)
    errors.append(np.mean(error))


#%%
lr = LinearRegression()
lr.fit(features,target)



