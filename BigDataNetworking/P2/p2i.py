# -*- coding: utf-8 -*-
#%%

from sklearn.datasets import fetch_20newsgroups
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
#%% convert the 8 subcategories to 2 categories

four_cats = ['comp.sys.ibm.pc.hardware','comp.sys.mac.hardware',
             'misc.forsale','soc.religion.christian']

four_train = fetch_20newsgroups(subset='train', categories=four_cats, shuffle=True, random_state=42)
four_test = fetch_20newsgroups(subset='test', categories=four_cats, shuffle=True, random_state=42)       
            
#%%
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction import text

stop_words = text.ENGLISH_STOP_WORDS
vectorizer = CountVectorizer(stop_words=stop_words)
X = vectorizer.fit_transform(four_train.data)
tfidf = TfidfTransformer()
X_tfidf = tfidf.fit_transform(X)

#%%
from sklearn.decomposition import TruncatedSVD

svd_model = TruncatedSVD(n_components=50, random_state=42)
X_svd = svd_model.fit_transform(X_tfidf)

#%% Naive Bayes
from sklearn.naive_bayes import MultinomialNB

MNB = MultinomialNB()
X_MNB = MNB.fit(X_tfidf,four_train.target)
X_test = vectorizer.transform(four_test.data)
X_test_tfidf = tfidf.transform(X_test)
MNB_pred = X_MNB.predict(X_test_tfidf)

print(classification_report(four_test.target,MNB_pred,target_names=four_test.target_names))
print(accuracy_score(four_test.target,MNB_pred))

confusion_matrix(four_test.target,MNB_pred)


#%% 1 vs 1
from sklearn.svm import LinearSVC
from sklearn.multiclass import OneVsOneClassifier

clf = OneVsOneClassifier(LinearSVC())
X_LSVM = clf.fit(X_svd,four_train.target)

X_test = vectorizer.transform(four_test.data)
X_test_tfidf = tfidf.transform(X_test)
X_test_svd = svd_model.transform(X_test_tfidf)
pred = X_LSVM.predict(X_test_svd)

print(classification_report(four_test.target,pred,target_names=four_test.target_names))
print(accuracy_score(four_test.target,pred))

confusion_matrix(four_test.target,pred)

#%% 1 vs Rest
from sklearn.svm import LinearSVC
from sklearn.multiclass import OneVsRestClassifier

clf = OneVsRestClassifier(LinearSVC())
X_LSVM = clf.fit(X_svd,four_train.target)

X_test = vectorizer.transform(four_test.data)
X_test_tfidf = tfidf.transform(X_test)
X_test_svd = svd_model.transform(X_test_tfidf)
pred = X_LSVM.predict(X_test_svd)

print(classification_report(four_test.target,pred,target_names=four_test.target_names))
print(accuracy_score(four_test.target,pred))

confusion_matrix(four_test.target,pred)










