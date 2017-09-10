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

#%%
n_tweets = 0

line = data.readline()
timezone = []
fav_count = []
n_followings = []
n_followers = []
n_statuses = []
len_tweet = []
n_hashtags = []

while len(line)!=0:
    tweet = json.loads(line)
    n_tweets+=1
    if (tweet['tweet']['user']['utc_offset'] != None):
        timezone.append(tweet['tweet']['user']['utc_offset'])
    fav_count.append(tweet['tweet']['user']['favourites_count'])
    n_followings.append(tweet['tweet']['user']['friends_count'])
    n_followers.append(tweet['tweet']['user']['followers_count'])
    n_statuses.append(tweet['tweet']['user']['statuses_count'])
    len_tweet.append(len(tweet['highlight']))
    n_hashtags.append(len(tweet['tweet']['entities']['hashtags']))
    print(n_tweets)
    line = data.readline()    
    
    
#%%

timezone_hours = np.array(timezone)/3600
timezone_hours_count = plt.hist(timezone_hours,bins=np.array(range(-12,13))-0.5)
plt.xticks(range(-12,12,2))
plt.xlim([-13,13])
plt.xlabel('Timezone (UTC +/- hours)')
plt.ylabel('Users')
plt.title('#gohawks')
#plt.title('#gopatriots')

#%%

plt.hist(timezone_hours,bins=np.array(range(-12,13))-0.5,normed=True)
plt.xticks(range(-12,12,2))
plt.xlim([-13,13])
plt.xlabel('Timezone (UTC +/- hours)')
plt.ylabel('Users')
plt.title('#gohawks')
#plt.title('#gopatriots')

#%%
var = np.array([fav_count,n_followings,n_followers,n_statuses,len_tweet,n_hashtags]).T

#%%
np.savetxt('data6.csv',var,delimiter=",")

#%%
plt.scatter(len_tweet,n_hashtags)
#%%
plt.scatter(n_followings,n_followers)
plt.xlabel('Number of Followings')
plt.ylabel('Number of Followers')
plt.title('#gopatriots')
#%%
plt.scatter(fav_count,n_followers)
plt.xlabel('Number of Favorites')
plt.ylabel('Number of Followers')
plt.title('#gopatriots')
#%%
plt.scatter(n_statuses,n_followers)
plt.xlabel('Total Number of Tweets Made')
plt.ylabel('Number of Followers')
plt.title('#gopatriots')
#%%
plt.scatter(n_followers,len_tweet)
plt.ylabel('Length of Tweet')
plt.xlabel('Number of Followers')
plt.title('For all Data')
#%%
plt.scatter(n_followers,n_hashtags)
plt.ylabel('Number of Hashtags')
plt.xlabel('Number of Followers')
plt.title('For all Data')




