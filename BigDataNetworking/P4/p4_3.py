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
features = np.array([tweets_cur,tot_ret,tot_fol,max_fol,time_hour,tot_fav,tot_ret_c,tot_rep]).T
target = np.array(tweets_next)

#%%
lr = LinearRegression()
lr.fit(features,target)

#%% export data, change name of text file as needed
np.savetxt('nfl_f2.csv',features,delimiter=",")
np.savetxt('nfl_t2.csv',target,delimiter=",")

#%% plots for superbowl

plt.plot(tweets_next,tot_ret_c,'b.')
plt.plot(tweets_next,tot_ret,'r.')
plt.plot(tweets_next,tot_fav,'g.')
plt.ylim([-10000,700000])
plt.xlim([-1000,300000])
plt.title('#superbowl Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Total Retweets','Total Citations','Total Favorites'],ncol=3,bbox_to_anchor=(1.2, -0.15))

#%% plots for sb49

plt.plot(tweets_next,tweets_cur,'b.')
plt.plot(tweets_next,tot_ret,'r.')
#plt.plot(tweets_next,tot_fol,'g.')
#plt.ylim([-20000000,1200000000])
#plt.xlim([-1000,120000])
plt.title('#sb49 Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Tweets in Previous hour','Total Citations','Total Followers'],ncol=3,bbox_to_anchor=(1.2, -0.15))

#%% plots for patriots

plt.plot(tweets_next,tweets_cur,'b.')
plt.plot(tweets_next,tot_ret,'r.')
#plt.plot(tweets_next,tot_fol,'g.')
#plt.ylim([-1000000,100000000])
#plt.xlim([-1000,60000])
plt.title('#patriots Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Tweets in Previous hour','Total Citations','Total Followers'],ncol=3,bbox_to_anchor=(1.2, -0.15))

#%% plots for nfl

plt.plot(tweets_next,tweets_cur,'b.')
plt.plot(tweets_next,tot_fol,'r.')
plt.plot(tweets_next,tot_ret_c,'g.')
#plt.ylim([-1000000,50000000])
#plt.xlim([-200,12000])
plt.title('#nfl Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Tweets in Previous hour','Total Followers','Total Retweets'],ncol=3,bbox_to_anchor=(1.2, -0.15))


#%% plots for gopatriots

plt.plot(tweets_next,tot_ret_c,'b.')
plt.plot(tweets_next,tot_ret,'r.')
plt.plot(tweets_next,tot_fav,'g.')
plt.ylim([-100,5000])
plt.xlim([-100,4000])
plt.title('#gopatriots Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Total Retweets','Total Citations','Total Favorites'],ncol=3,bbox_to_anchor=(1.2, -0.15))

#%% plots for gohawks

plt.plot(tweets_next,tweets_cur,'b.')
#plt.plot(tweets_next,tot_ret,'r.')
#plt.plot(tweets_next,tot_fol,'g.')
#plt.ylim([-500000,45000000])
#plt.xlim([-500,25000])
plt.title('#gohawks Top 3 Features')
plt.xlabel('Tweets in Next Hour (Predictant)')
plt.ylabel('Feature Value')
plt.legend(['Tweets in Previous hour','Total Citations','Total Followers'],ncol=3,bbox_to_anchor=(1.2, -0.15))


