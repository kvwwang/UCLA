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
#data = open('tweets_#gopatriots.txt',encoding='utf8')
data = open('tweets_#nfl.txt',encoding='utf8')

#%% Set min/maxtime

start_date = datetime.datetime(2014,1,1,12,0,0)
end_per1 = datetime.datetime(2015,2,1,8,0,0)
end_per2 = datetime.datetime(2015,2,1,20,0,0)
end_date = datetime.datetime(2015,3,1,8,0,0)

period = 1

if period==1: # period 1
    mintime = int(time.mktime(start_date.timetuple()))
    maxtime = int(time.mktime(end_per1.timetuple()))

if period==2: # period 2
    mintime = int(time.mktime(end_per1.timetuple()))
    maxtime = int(time.mktime(end_per2.timetuple()))

if period==3: # period 3
    mintime = int(time.mktime(end_per2.timetuple()))
    maxtime = int(time.mktime(end_date.timetuple()))

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
    if tweet['firstpost_date'] >= mintime:
        if tweet['firstpost_date'] >= maxtime:
            break;
        n_tweets+=1
        followers.append(tweet['author']['followers'])
        ret_cit.append(tweet['metrics']['citations']['total'])
        firstpost_date.append(tweet['firstpost_date'])
        fav_count.append(tweet['tweet']['favorite_count'])
        ret_count.append(tweet['tweet']['retweet_count'])
        rep_count.append(tweet['metrics']['citations']['replies'])
        print(n_tweets)
    line = data.readline()    
    
    
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
        
tweets_cur.append(n_twt_hour)
tot_ret.append(n_ret_hour)
tot_fol.append(n_fol_hour)
max_fol.append(max_fol_hour)
time_hour.append(prev_hour)
tot_fav.append(n_fav_hour)
tot_ret_c.append(n_ret_c_hour)
tot_rep.append(n_rep_hour)
    
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


#%% #superbowl models
LR_superbowl_1 = LinearRegression()
LR_superbowl_1.fit(features,target)
#%% #superbowl models
LR_superbowl_2 = LinearRegression()
LR_superbowl_2.fit(features,target)
#%% #superbowl models
LR_superbowl_3 = LinearRegression()
LR_superbowl_3.fit(features,target)

#%% #sb49 models
LR_sb49_1 = LinearRegression()
LR_sb49_1.fit(features,target)
#%% #sb49 models
LR_sb49_2 = LinearRegression()
LR_sb49_2.fit(features,target)
#%% #sb49 models
LR_sb49_3 = LinearRegression()
LR_sb49_3.fit(features,target)

#%% #patriots models
LR_patriots_1 = LinearRegression()
LR_patriots_1.fit(features,target)
#%% #patriots models
LR_patriots_2 = LinearRegression()
LR_patriots_2.fit(features,target)
#%% #patriots models
LR_patriots_3 = LinearRegression()
LR_patriots_3.fit(features,target)

#%% #gohawks models
LR_gohawks_1 = LinearRegression()
LR_gohawks_1.fit(features,target)
#%% #gohawks models
LR_gohawks_2 = LinearRegression()
LR_gohawks_2.fit(features,target)
#%% #gohawks models
LR_gohawks_3 = LinearRegression()
LR_gohawks_3.fit(features,target)

#%% #gopatriots models
LR_gopatriots_1 = LinearRegression()
LR_gopatriots_1.fit(features,target)
#%% #gopatriots models
LR_gopatriots_2 = LinearRegression()
LR_gopatriots_2.fit(features,target)
#%% #gopatriots models
LR_gopatriots_3 = LinearRegression()
LR_gopatriots_3.fit(features,target)

#%% #nfl models
LR_nfl_1 = LinearRegression()
LR_nfl_1.fit(features,target)
#%% #nfl models
LR_nfl_2 = LinearRegression()
LR_nfl_2.fit(features,target)
#%% #nfl models
LR_nfl_3 = LinearRegression()
LR_nfl_3.fit(features,target)


#%% Select sample

#data_sample = open('sample1_period1.txt',encoding='utf8')
#data_sample = open('sample2_period2.txt',encoding='utf8')
#data_sample = open('sample3_period3.txt',encoding='utf8')
#data_sample = open('sample4_period1.txt',encoding='utf8')
#data_sample = open('sample5_period1.txt',encoding='utf8')
#data_sample = open('sample6_period2.txt',encoding='utf8')
#data_sample = open('sample7_period3.txt',encoding='utf8')
#data_sample = open('sample8_period1.txt',encoding='utf8')
#data_sample = open('sample9_period2.txt',encoding='utf8')
data_sample = open('sample10_period3.txt',encoding='utf8')


#%%
n_tweets = 0

line = data_sample.readline()
firstpost_date = []
followers = []
ret_cit = []
fav_count = []
ret_count = []
rep_count = []

n_superbowl = 0
n_sb49 = 0
n_patriots = 0
n_nfl = 0
n_gohawks = 0
n_gopatriots = 0

while len(line)!=0:
    tweet = json.loads(line)
    n_tweets+=1
    followers.append(tweet['author']['followers'])
    ret_cit.append(tweet['metrics']['citations']['total'])
    firstpost_date.append(tweet['firstpost_date'])
    fav_count.append(tweet['tweet']['favorite_count'])
    ret_count.append(tweet['tweet']['retweet_count'])
    rep_count.append(tweet['metrics']['citations']['replies'])
    tweet_text = str.lower(tweet['highlight'])
    if "#superbowl" in tweet_text:
        n_superbowl+=1
    if "#sb49" in tweet_text:
        n_sb49+=1    
    if "#patriots" in tweet_text:
        n_patriots+=1  
    if "#nfl" in tweet_text:
        n_nfl+=1
    if "#gohawks" in tweet_text:
        n_gohawks+=1    
    if "#gopatriots" in tweet_text:
        n_gopatriots+=1         
        
        
    print(n_tweets)
    line = data_sample.readline()    
    
#%%
hashtag_count = np.array([n_superbowl,n_sb49,n_patriots,n_nfl,n_gohawks,n_gopatriots])    
    
    
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
        
tweets_cur.append(n_twt_hour)
tot_ret.append(n_ret_hour)
tot_fol.append(n_fol_hour)
max_fol.append(max_fol_hour)
time_hour.append(prev_hour)
tot_fav.append(n_fav_hour)
tot_ret_c.append(n_ret_c_hour)
tot_rep.append(n_rep_hour)
    
#%%
features = np.array([tweets_cur,tot_ret,tot_fol,tot_fav,tot_ret_c]).T

#%% sample 1
samp1_pred = LR_superbowl_1.predict(features)
samp1_pred[-1]

#%% sample 2
samp2_pred = LR_superbowl_2.predict(features)
samp2_pred[-1]

#%% sample 3
samp3_pred = LR_superbowl_3.predict(features)
samp3_pred[-1]

#%% sample 4
samp4_pred = LR_superbowl_1.predict(features)
samp4_pred[-1]

#%% sample 5
samp5_pred = LR_superbowl_1.predict(features)
samp5_pred[-1]

#%% sample 6
samp6_pred = LR_sb49_2.predict(features)
samp6_pred[-1]

#%% sample 7
samp7_pred = LR_nfl_3.predict(features)
samp7_pred[-1]

#%% sample 8
samp8_pred = LR_nfl_1.predict(features)
samp8_pred[-1]

#%% sample 9
samp9_pred = LR_superbowl_2.predict(features)
samp9_pred[-1]

#%% sample 10
samp10_pred = LR_nfl_3.predict(features)
samp10_pred[-1]













