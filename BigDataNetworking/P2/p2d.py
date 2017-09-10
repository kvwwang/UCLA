# -*- coding: utf-8 -*-

#%%

from sklearn.datasets import fetch_20newsgroups
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

#%%
twenty_train = fetch_20newsgroups(subset='train',shuffle=True, random_state=42)

from sklearn.feature_extraction import text
stop_words = text.ENGLISH_STOP_WORDS

vectorizer = CountVectorizer(stop_words=stop_words)
X = vectorizer.fit_transform(twenty_train.data)
tfidf = TfidfTransformer()
X_tfidf = tfidf.fit_transform(X)

#%%

from sklearn.decomposition import TruncatedSVD

svd_model = TruncatedSVD(n_components=50, random_state=42)

from sklearn.pipeline import Pipeline

svd_trans = Pipeline([('vect', vectorizer),('tfidf',tfidf),('svd', svd_model)])
X_svd = svd_trans.fit_transform(twenty_train.data)
                    

#%%

X_tfidf.shape
X_svd.shape



