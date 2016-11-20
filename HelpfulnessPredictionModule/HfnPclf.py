__author__ = 'zhf'
#! /usr/bin/env python2.7
#coding=utf-8

from sklearn.externals import joblib
from random import shuffle
import numpy as np


# 1. Load data
def read_data(datapath):
	f = open(datapath)
	f.readline()
	data = np.loadtxt(f)
	return data
#filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/result/feature_word_ngram.txt'
filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/HelpfulnessPredictionModule/FeatureSetWithDifferentThreshold/f9.txt'
#data = read_data("D:/code/machinelearning/feature.txt")
data = read_data(filefeature)
#shuffle(data) # Make data ramdon
helpfulness_feature = data[:, 1:] # The rest of the dataset is review helpfulness features

clf=joblib.load('rf.pkl')
target_pred = clf.predict(helpfulness_feature)
len_tag = len(target_pred)
# for i in range(len_tag):
#     print int(target_pred[i])
storepath = 'E:/GraduationProject/pythoncode/project/Prediction/main/HelpfulnessPredictionModule/FeatureSetWithDifferentThreshold/f9_result.txt'
p_file = open(storepath, 'w')

for i in range(len_tag):
    p_file.write(str(int(target_pred[i]))+'\n')


p_file.close()

