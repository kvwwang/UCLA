# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
#%%

from sklearn.datasets import fetch_20newsgroups
#%% convert the 8 subcategories to 2 categories

eight_cats = ['comp.graphics','comp.os.ms-windows.misc','comp.sys.ibm.pc.hardware',
              'comp.sys.mac.hardware','rec.autos','rec.motorcycles','rec.sport.baseball',
              'rec.sport.hockey']

eight_train = fetch_20newsgroups(subset='train', categories=eight_cats, shuffle=True, random_state=42)
eight_test = fetch_20newsgroups(subset='test', categories=eight_cats, shuffle=True, random_state=42)

for k in range(0,len(eight_train.data)):
    if eight_train.target[k] < 4:
        eight_train.target[k] = 0
    else:
        eight_train.target[k] = 1

for k in range(0,len(eight_test.data)):
    if eight_test.target[k] < 4:
        eight_test.target[k] = 0
    else:
        eight_test.target[k] = 1

eight_train.target_names = ['c','r']
eight_test.target_names = ['c','r']        
            
#%%
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction import text

stop_words = text.ENGLISH_STOP_WORDS
vectorizer = CountVectorizer(stop_words=stop_words)
X = vectorizer.fit_transform(eight_train.data)
tfidf = TfidfTransformer()
X_tfidf = tfidf.fit_transform(X)

#%%

from sklearn.decomposition import TruncatedSVD

svd_model = TruncatedSVD(n_components=50, random_state=42)
X_svd = svd_model.fit_transform(X_tfidf)


#%%
from sklearn.linear_model import LogisticRegression

LSVM = LogisticRegression()
X_LSVM = LSVM.fit(X_svd,eight_train.target)

#%%
X_test = vectorizer.transform(eight_test.data)
X_test_tfidf = tfidf.transform(X_test)
X_test_svd = svd_model.transform(X_test_tfidf)

LSVM_pred = X_LSVM.predict(X_test_svd)

#%%
from sklearn.metrics import roc_curve
from sklearn.metrics import auc

fpr,tpr,thresh = roc_curve(eight_test.target,LSVM_pred)
roc_auc = auc(fpr,tpr)

#%%
import matplotlib.pyplot as plt

plt.title('ROC: Logistic Regression')
plt.plot(fpr,tpr,'b',label='AUC = %0.2f'% roc_auc)
plt.legend(loc='lower right')
plt.ylim([0,1.05])
plt.plot([0,1],[0,1],'r--')
plt.xlabel('TPR')
plt.ylabel('FPR')
plt.show()


#%%
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score

print(classification_report(eight_test.target,LSVM_pred,target_names=eight_test.target_names))
print(accuracy_score(eight_test.target,LSVM_pred))

confusion_matrix(eight_test.target,LSVM_pred)








