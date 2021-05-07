# -*- coding: utf-8 -*-
"""
Project 6 part A
"""
#%%
#import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


#%% Get data

uciwd ="https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
bcnames = ("ID","clump_thick","cell_size","cell_shape", "marginal","epithelial","nuclei",
                    "chromatin","nucleoli","mitoses","class")

bcancer = pd.read_csv(uciwd, names=bcnames)

#%% 

# handle ?'s
bcancer.nuclei.value_counts()

bcancer.nuclei = bcancer.nuclei.apply(pd.to_numeric,errors="coerce")
bcancer.nuclei.value_counts()

bcancer.drop(["ID"],axis=1,inplace=True) 

#%% Imputation
from sklearn.impute import KNNImputer

bcancer.isnull().sum().sort_values(ascending = False)

bcancer_imp = KNNImputer().fit_transform(bcancer)
bcancer_impdf = pd.DataFrame(bcancer_imp,columns=bcancer.columns)

#%%

X = bcancer_impdf.drop(["class"],axis=1)
Y = bcancer_impdf['class']

#%% Logistic Regression
from sklearn.linear_model import LogisticRegression
# from sklearn.metrics import accuracy_score
from sklearn.model_selection import cross_val_score

log_clf = LogisticRegression()
log_clf.fit(X,Y)

log_acc = cross_val_score(estimator = log_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(log_acc)
print(log_clf.score(X,Y))

#%% KNN

from sklearn.neighbors import KNeighborsClassifier

knn_clf = KNeighborsClassifier()
knn_clf.fit(X,Y)

knn_acc = cross_val_score(estimator = knn_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(knn_acc)
print(knn_clf.score(X,Y))

#%% LDA

from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

lda_clf = LinearDiscriminantAnalysis()
lda_clf.fit(X,Y)

lda_acc = cross_val_score(estimator = lda_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(lda_acc)
print(lda_clf.score(X,Y))

#%% Gaussian Naive Bayes

from sklearn.naive_bayes import GaussianNB

gnb_clf = GaussianNB()
gnb_clf.fit(X,Y)

gnb_acc = cross_val_score(estimator = gnb_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(gnb_acc)
print(gnb_clf.score(X,Y))

#%% Support Vector Machines

from sklearn.svm import SVC

svc_clf = SVC()
svc_clf.fit(X,Y)

svc_acc = cross_val_score(estimator = svc_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(svc_acc)
print(svc_clf.score(X,Y))

#%% Decision Tree

from sklearn.tree import DecisionTreeClassifier

dtree_clf = DecisionTreeClassifier()
dtree_clf.fit(X,Y)

dtree_acc = cross_val_score(estimator = dtree_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(dtree_acc)
print(dtree_clf.score(X,Y))

#%% Bagging 

from sklearn.ensemble import BaggingClassifier

bag_clf = BaggingClassifier()
bag_clf.fit(X,Y)

bag_acc = cross_val_score(estimator = bag_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(bag_acc)
print(bag_clf.score(X,Y))

#%% Random Forest Classifier

from sklearn.ensemble import RandomForestClassifier

rf_clf = RandomForestClassifier()
rf_clf.fit(X,Y)

rf_acc = cross_val_score(estimator = rf_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(rf_acc)
print(rf_clf.score(X,Y))

#%% Gradient Boosting Classifier

from sklearn.ensemble import GradientBoostingClassifier

gbc_clf = GradientBoostingClassifier()
gbc_clf.fit(X,Y)

gbc_acc = cross_val_score(estimator = gbc_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(gbc_acc)
print(gbc_clf.score(X,Y))

#%% AdaBoost Classiflier

from sklearn.ensemble import AdaBoostClassifier

ada_clf = AdaBoostClassifier()
ada_clf.fit(X,Y)

ada_acc = cross_val_score(estimator = ada_clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()
print(ada_acc)
print(ada_clf.score(X,Y))

#%% Determine best

accs = (log_acc,knn_acc,lda_acc,gnb_acc,svc_acc,dtree_acc,bag_acc,rf_acc,gbc_acc,ada_acc)
accs
print(np.argmax(accs))

# All of the cross-validated accuracies are high and approximately the same ~0.96
# Depending on the random seed, the top model changes
# SVC or RF are typically the highest

#%% Tune parameters for Random Forest and SVC to compare results

# RF
from sklearn.model_selection import GridSearchCV

max_feat = ['auto','sqrt','log2',None]
n_est = [10,20,30]
min_sl = [0.25,0.4,1]
params = {"max_features":max_feat,"n_estimators":n_est,"min_samples_leaf":min_sl}

clf = RandomForestClassifier()

gsmodel = GridSearchCV(clf,param_grid=params,cv=10,n_jobs=-1)
gsmodel.fit(X,Y)
print("Best params:",gsmodel.best_params_)

# Best params: {'max_features': 'sqrt', 'min_samples_leaf': 1, 'n_estimators': 30}

test_fit = RandomForestClassifier(n_estimators=30,min_samples_leaf=1,max_features='sqrt')
test_fit.fit(X,Y)

rf_gs = cross_val_score(estimator = clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()


#%% SVC

C = [0.001,0.01,0.1,1,10]
g = [0.001,0.01,0.1,0.5,1]
params = {"C":C,"gamma":g}

clf = SVC()

gsmodel = GridSearchCV(clf,param_grid=params,cv=10,n_jobs=-1)
gsmodel.fit(X,Y)
print("Best params:",gsmodel.best_params_)

# Best params: {'C': 1, 'gamma': 0.01}

test_fit = SVC(C=1,gamma=0.01)
test_fit.fit(X,Y)

svc_gs = cross_val_score(estimator = clf, X = X, y = Y, cv = 10, n_jobs = -1).mean()

#%%

rf_gs > svc_gs # False

# 0.96855 vs 0.96998

# It appears SVC is marginally better when run in this seed
# Best parameters and scoring changed each time the code is run due to
# different random seeds


