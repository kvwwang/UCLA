# -*- coding: utf-8 -*-
#%%

from sklearn.datasets import fetch_20newsgroups
from sklearn.feature_extraction.text import CountVectorizer
#%%

twenty_train = fetch_20newsgroups(subset='train',shuffle=True, random_state=42)
len(twenty_train.data)

#%%
import string
import nltk
from nltk import word_tokenize          
from nltk.stem.porter import PorterStemmer
#nltk.download()

#%%

stemmer = PorterStemmer()
def stem_tokens(tokens, stemmer):
    stemmed = []
    for item in tokens:
        stemmed.append(stemmer.stem(item))
    return stemmed

def tokenize(text):
    tokens = nltk.word_tokenize(text)
    tokens = [i for i in tokens if i not in string.punctuation]
    stems = stem_tokens(tokens, stemmer)
    return stems

#%%
from sklearn.feature_extraction import text
stop_words = text.ENGLISH_STOP_WORDS

vectorizer = CountVectorizer(tokenizer=tokenize,stop_words=stop_words)

#%%
from sklearn.feature_extraction.text import TfidfTransformer

X = vectorizer.fit_transform(twenty_train.data)
tfidf = TfidfTransformer()
X_tfidf = tfidf.fit_transform(X)
X_tfidf.shape

#%%
categories = twenty_train.target_names
#%% merge all docs in a category into 1 doc

c = []
for l in range(0,len(categories)):  
    d1=fetch_20newsgroups(subset='train', categories=[categories[l]], shuffle=True, random_state=42)
    a = ''
    for k in range(0,len(d1.data)):
        a = a+' '+d1.data[k]
    c.append(a)
a = ''

#%%

vect2 = CountVectorizer(tokenizer=tokenize,stop_words=stop_words)
CC = vect2.fit_transform(c)
tficf = TfidfTransformer()
C_tficf = tficf.fit_transform(CC)

#%%

vect2 = CountVectorizer(stop_words=stop_words)
CC = vect2.fit_transform(c)
tficf = TfidfTransformer()
C_tficf = tficf.fit_transform(CC)

#%%
import numpy as np

#comp.sys.ibm.pc.hardware = 3
#comp.sys.mac.hardware = 4
#misc.forsale = 6
#soc.religion.christian = 15
class_index = 15 #change depending on which class is of interest

features = vect2.get_feature_names()
top_n = 10
indices = np.argsort(C_tficf[class_index].todense())
top_features = []
n_max = len(features)-1
i = n_max
while (i>n_max-top_n):
    top_features.append(features[indices[0,i]])
    i = i-1
print(top_features)



