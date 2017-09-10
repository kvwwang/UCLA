import sys,tarfile, json, os
import numpy as np
import datetime, time
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
os.chdir('D:\Assignments\Graduate\EE239AS\P4\Data')

#%% Select dataset

#data = open('tweets_#superbowl.txt',encoding='utf8')
#data = open('tweets_#sb49.txt',encoding='utf8')
#data = open('tweets_#patriots.txt',encoding='utf8')
#data = open('tweets_#gohawks.txt',encoding='utf8')
#data = open('tweets_#gopatriots.txt',encoding='utf8')
data = open('tweets_#nfl.txt',encoding='utf8')

#%%

n_tweets = 0

line = data.readline()
firstpost_date = []
followers = []
ret_cit = []

while len(line)!=0:
    tweet = json.loads(line)
    n_tweets+=1
    followers.append(tweet['author']['followers'])
    ret_cit.append(tweet['metrics']['citations']['total'])
    firstpost_date.append(tweet['firstpost_date'])
    line = data.readline()    
    print(n_tweets)
    
#%%

tweets_cur = []
tot_ret = []
tot_fol = []
max_fol = []
time_hour = []

prev_hour = time.localtime(firstpost_date[0]).tm_hour
n_twt_hour = 0
n_ret_hour = 0
n_fol_hour = 0
max_fol_hour = 0

for k in range(0,n_tweets):
    hour = time.localtime(firstpost_date[k]).tm_hour
    if (hour!=prev_hour):
        tweets_cur.append(n_twt_hour)
        tot_ret.append(n_ret_hour)
        tot_fol.append(n_fol_hour)
        max_fol.append(max_fol_hour)
        time_hour.append(prev_hour)
        
        prev_hour = (prev_hour+1)%24
        n_twt_hour = 0
        n_ret_hour = 0
        n_fol_hour = 0
        max_fol_hour = 0          
        while (prev_hour != hour):
            tweets_cur.append(n_twt_hour)
            tot_ret.append(n_ret_hour)
            tot_fol.append(n_fol_hour)
            max_fol.append(max_fol_hour)
            time_hour.append(prev_hour)  
            prev_hour = (prev_hour+1)%24
                  
    n_twt_hour+=1
    n_ret_hour+=ret_cit[k]
    n_fol_hour+=followers[k]
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

#%%
features = np.array([tweets_cur,tot_ret,tot_fol,max_fol,time_hour]).T
target = np.array(tweets_next)

#%%
lr = LinearRegression()
lr.fit(features,target)

#%% export data, change name of text file as needed
np.savetxt('nfl_f1.csv',features,delimiter=",")
np.savetxt('nfl_t1.csv',target,delimiter=",")


#%%
time.localtime(firstpost_date[100]).tm_hour







