#! /usr/bin/env python2.7
#coding=utf-8
__author__ = 'zhf'

"""
Use scikit-learn to test different classifier's review helpfulness prediction performance, and test different feature subset's prediction performance
This module is the last part of review helpfulness prediction research.
filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/HelpfulnessPredictionModule/FeatureSetWithDifferentThreshold/f0581.txt'
#data = read_data("D:/code/machinelearning/feature.txt")
"""



import numpy as np
from random import shuffle

from sklearn import svm
from sklearn.linear_model import LogisticRegression
from sklearn import tree
from sklearn.naive_bayes import GaussianNB, BernoulliNB
from sklearn.ensemble import RandomForestClassifier,GradientBoostingClassifier,AdaBoostClassifier

from sklearn.multiclass import OneVsOneClassifier, OneVsRestClassifier

from sklearn import cross_validation
from sklearn.metrics import f1_score, precision_score, recall_score,roc_auc_score,accuracy_score

from sklearn.externals import joblib
# store the best classifier

# 1. Load data
def read_data(datapath):
	f = open(datapath)
	f.readline()
	data = np.loadtxt(f)
	return data
#filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/result/feature_word_ngram.txt'
filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/HelpfulnessPredictionModule/FeatureSetWithDifferentThreshold/f6.txt'
#data = read_data("D:/code/machinelearning/feature.txt")
data = read_data(filefeature)
shuffle(data) # Make data ramdon

development = data[:20,:]
test = data[20:,:]


train = development[:,1:]
tag = development[:, 0]

helpfulness_target = data[:, 0 ] # First column of the dataset is review helpfulness label
helpfulness_feature = data[:, 1:] # The rest of the dataset is review helpfulness features


# 2. Feature subset
# linguistic = data[:, 4:10]
# informative = np.hstack((data[:, 1:4], data[:, 20:21]))
# difference = data[:, 10:12]
# sentiment = data[:, 12:20]

# IDS = np.hstack((data[:, 1:4], data[:, 10:21]))
# LIS = np.hstack((data[:, 1:10], data[:, 12:21]))
# LDS = data[:, 4:20]
# LID = np.hstack((data[:, 1:12], data[:, 20:21]))

# LI = np.hstack((data[:, 1:10], data[:, 20:21]))
# LD = data[:, 4:12]
# LS = np.hstack((data[:, 4:10], data[:, 12:20]))
# ID = np.hstack((data[:, 1:4], data[:, 10:12], data[:, 20:21]))
# IS = np.hstack((data[:, 1:4], data[:, 12:21]))
# DS = data[:, 10:20]

# L1 = data[:, 4:7]
# L2 = data[:, 7:10]
# S1 = data[:, 12:14]
# S2 = data[:, 14:16]
# S3 = data[:, 16:18]
# S4 = data[:, 18:20]

# Sentiment feature subset
# S12 = data[:, 12:16]
# S13 = np.hstack((data[:, 12:14], data[:, 16:18]))
# S14 = np.hstack((data[:, 12:14], data[:, 18:20]))
# S23 = data[:, 14:18]
# S24 = np.hstack((data[:, 14:16], data[:, 18:20]))
# S34 = data[:, 16:20]

# SP = np.hstack((data[:, 12:13], data[:, 14:15], data[:, 16:17], data[:, 18:19]))
# SN = np.hstack((data[:, 13:14], data[:, 15:16], data[:, 17:18], data[:, 19:20]))


# 3. Load classifier
# 3.1 Classifier for binary classifiy
#clf = svm.SVC(gamma=0.001, C=100.)
#clf = svm.SVR()
#clf = LogisticRegression(penalty='l2', tol=0.001)
#clf = tree.DecisionTreeClassifier()
#clf = GaussianNB()
#clf = BernoulliNB()
clf = RandomForestClassifier(n_estimators=20, max_depth=None, min_samples_split=1, random_state=0)
#clf =GradientBoostingClassifier(n_estimators=20)
#clf = AdaBoostClassifier(tree.DecisionTreeClassifier(max_depth=1),algorithm="SAMME",n_estimators=200)

# 3.2 Classifier for mulit classify
# clf = OneVsOneClassifier(svm.SVC(gamma=0.001, C=100.))
# clf = OneVsOneClassifier(svm.SVR())
#clf = OneVsRestClassifier(LogisticRegression(penalty='l1', tol=0.01))


# 4. Cross validate classifier's accuracy
#k_fold = cross_validation.KFold(len(helpfulness_feature), n_folds=10)

#clf_accuracy = cross_validation.cross_val_score(clf, x, y, cv=k_fold)
#clf_accuracy = cross_validation.cross_val_score(clf,train,tag,cv=k_fold)
#print clf_accuracy.mean()


# 5. Cross validate for all metrics, include precision, recall and f1 measure (macro, micro)
def metric_evaluation(feature, target):
	k_fold = cross_validation.KFold(len(feature), n_folds=10) # 10-fold cross validation

	metric = []
	for train, test in k_fold:
		target_pred = clf.fit(feature[train], target[train]).predict(feature[test])
		p = precision_score(target[test], target_pred)
		r = recall_score(target[test], target_pred)
		f1_macro = f1_score(target[test], target_pred, average='binary')#macro
		f1_micro = f1_score(target[test], target_pred, average='binary')#micro
        ras = roc_auc_score(target[test], target_pred)
        metric.append([p,r,f1_macro,f1_micro,ras])

	metric_array = np.array(metric)
	print np.mean(metric_array[:, 0]) # Precision score
	print np.mean(metric_array[:, 1]) # Recall score
	print np.mean(metric_array[:, 2]) # F1-macro score
	print np.mean(metric_array[:, 3]) # F1-micro score
	print np.mean(metric_array[:,4]) #roc_auc_score

# Testing
metric_evaluation(helpfulness_feature, helpfulness_target)

#store model
def stroe_model(classfiy):
    joblib.dump(classfiy,'rf.pkl')

stroe_model(clf)