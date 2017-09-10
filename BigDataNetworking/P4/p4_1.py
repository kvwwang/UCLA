import sys,tarfile, json, os
import numpy as np
import datetime, time
import matplotlib.pyplot as plt
os.chdir('D:\Assignments\Graduate\EE239AS\P4\Data')

#%%

# traindata = tarfile.open('tweet_data.tar.gz')
# traindata.extractall()

testdata = tarfile.open('test_data.tar.gz')
testdata.extractall()

#%% #superbowl

superbowl = open('tweets_#SuperBowl.txt',encoding='utf8')

n_superbowl = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = superbowl.readline()
superbowl_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_superbowl+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count']  
    tot_cit = tot_cit+tweet['metrics']['citations']['total']
    superbowl_tweets.append(tweet['firstpost_date'])
    line = superbowl.readline()    
    print(len(superbowl_tweets))
    
mean_fol_superbowl = tot_fol/n_superbowl
mean_ret_superbowl = tot_ret/n_superbowl    
mean_cit_superbowl = tot_cit/n_superbowl

#%%
superbowl_hours = (superbowl_tweets[-1]-superbowl_tweets[0])/3600
mean_twt_superbowl = n_superbowl/superbowl_hours

#%%
superbowl_tph_reg = (np.array(superbowl_tweets)-superbowl_tweets[0])/3600
(superbowl_tph,_,_)=plt.hist(superbowl_tph_reg,bins=np.floor(superbowl_hours))
plt.title('#Superbowl tweets per hour')
plt.xlabel('Hour')
plt.ylabel('Number of Tweets')

#%% #nfl

nfl = open('tweets_#nfl.txt',encoding='utf8')

n_nfl = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = nfl.readline()
nfl_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_nfl+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count']
    tot_cit = tot_cit+tweet['metrics']['citations']['total']    
    nfl_tweets.append(tweet['firstpost_date'])
    line = nfl.readline()    
    print(len(nfl_tweets))
    
mean_fol_nfl = tot_fol/n_nfl
mean_ret_nfl = tot_ret/n_nfl  
mean_cit_nfl = tot_cit/n_nfl 


#%%
nfl_hours = (nfl_tweets[-1]-nfl_tweets[0])/3600
mean_twt_nfl = n_nfl/nfl_hours

#%%
nfl_tph_reg = (np.array(nfl_tweets)-nfl_tweets[0])/3600
(nfl_tph,_,_)=plt.hist(nfl_tph_reg,bins=np.floor(nfl_hours))
plt.title('#NFL tweets per hour')
plt.xlabel('Hour')
plt.ylabel('Number of Tweets')

#%% #sb49

sb49 = open('tweets_#sb49.txt',encoding='utf8')

n_sb49 = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = sb49.readline()
sb49_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_sb49+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count']   
    tot_cit = tot_cit+tweet['metrics']['citations']['total']
    sb49_tweets.append(tweet['firstpost_date'])
    line = sb49.readline()    
    print(len(sb49_tweets))
    
mean_fol_sb49 = tot_fol/n_sb49
mean_ret_sb49 = tot_ret/n_sb49
mean_cit_sb49 = tot_cit/n_sb49   


#%%
sb49_hours = (sb49_tweets[-1]-sb49_tweets[0])/3600
mean_twt_sb49 = n_sb49/sb49_hours

#%% #patriots

patriots = open('tweets_#patriots.txt',encoding='utf8')

n_patriots = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = patriots.readline()
patriots_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_patriots+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count']  
    tot_cit = tot_cit+tweet['metrics']['citations']['total']
    patriots_tweets.append(tweet['firstpost_date'])
    line = patriots.readline()    
    print(len(patriots_tweets))
    
mean_fol_patriots = tot_fol/n_patriots
mean_ret_patriots = tot_ret/n_patriots   
mean_cit_patriots = tot_cit/n_patriots


#%%
patriots_hours = (patriots_tweets[-1]-patriots_tweets[0])/3600
mean_twt_patriots = n_patriots/patriots_hours

#%% #gopatriots

gopatriots = open('tweets_#gopatriots.txt',encoding='utf8')

n_gopatriots = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = gopatriots.readline()
gopatriots_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_gopatriots+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count'] 
    tot_cit = tot_cit+tweet['metrics']['citations']['total']
    gopatriots_tweets.append(tweet['firstpost_date'])
    line = gopatriots.readline()    
    print(len(gopatriots_tweets))
    
mean_fol_gopatriots = tot_fol/n_gopatriots
mean_ret_gopatriots = tot_ret/n_gopatriots   
mean_cit_gopatriots = tot_cit/n_gopatriots


#%%
gopatriots_hours = (gopatriots_tweets[-1]-gopatriots_tweets[0])/3600
mean_twt_gopatriots = n_gopatriots/gopatriots_hours

#%% #gohawks

gohawks = open('tweets_#gohawks.txt',encoding='utf8')

n_gohawks = 0
tot_fol = 0
tot_ret = 0
tot_cit = 0

line = gohawks.readline()
gohawks_tweets = []
while len(line)!=0:
    tweet = json.loads(line)
    n_gohawks+=1
    tot_fol = tot_fol+tweet['author']['followers']
    tot_ret = tot_ret+tweet['tweet']['retweet_count']   
    tot_cit = tot_cit+tweet['metrics']['citations']['total']
    gohawks_tweets.append(tweet['firstpost_date'])
    line = gohawks.readline()    
    print(len(gohawks_tweets))
    
mean_fol_gohawks = tot_fol/n_gohawks
mean_ret_gohawks = tot_ret/n_gohawks   
mean_cit_gohawks = tot_cit/n_gohawks

#%%
gohawks_hours = (gohawks_tweets[-1]-gohawks_tweets[0])/3600
mean_twt_gohawks = n_gohawks/gohawks_hours
