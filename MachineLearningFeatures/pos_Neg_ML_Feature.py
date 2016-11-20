#! /usr/bin/env python2.7
#coding=utf-8

"""
Use a stored sentiment classifier to identifiy review positive and negative probability.
This module aim to extract review sentiment probability as review helpfulness features.

"""


import textprocessing as tp
import pickle
import itertools
from random import shuffle

import nltk
from nltk.collocations import BigramCollocationFinder
from nltk.metrics import BigramAssocMeasures
from nltk.probability import FreqDist, ConditionalFreqDist

import sklearn
from nltk.classify.scikitlearn import SklearnClassifier

##my classifier path
filefeature = 'E:/GraduationProject/pythoncode/project/Prediction/main/result/feature_word_ngram.txt'
filename = 'E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/SentimentFeatures/MachineLearningFeatures/senti_class_word_ngram.pkl'

# 1. Load data
"""
review = tp.get_excel_data("D:/code/sentiment_test/review_set.xlsx", "1", "1", "data")
sentiment_review = tp.seg_fil_senti_excel("D:/code/sentiment_test/review_set.xlsx", "1", "1")
"""


review = tp.get_excel_data("E:/GraduationProject/pythoncode/project/Prediction/main/ReviewSet/Samsung.xlsx", 1, 12, "data")


sentiment_review = tp.seg_fil_senti_excel("E:/GraduationProject/pythoncode/project/Prediction/main/ReviewSet/Samsung.xlsx", 1, 12)


# 2. Feature extraction method
# Used for transform review to features, so it can calculate sentiment probability by classifier
def create_words_bigrams_scores():
    posdata = tp.seg_fil_senti_excel("E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/SentimentFeatures/MachineLearningFeatures/SenimentReviewSet/pos_review.xlsx", 1, 1)
    negdata = tp.seg_fil_senti_excel("E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/SentimentFeatures/MachineLearningFeatures/SenimentReviewSet/neg_review.xlsx", 1, 1)

    
    posWords = list(itertools.chain(*posdata))
    negWords = list(itertools.chain(*negdata))

    bigram_finder = BigramCollocationFinder.from_words(posWords)
    bigram_finder = BigramCollocationFinder.from_words(negWords)
    posBigrams = bigram_finder.nbest(BigramAssocMeasures.chi_sq, 5000)
    negBigrams = bigram_finder.nbest(BigramAssocMeasures.chi_sq, 5000)

    pos = posWords + posBigrams
    neg = negWords + negBigrams

    word_fd = FreqDist()
    cond_word_fd = ConditionalFreqDist()
    for word in pos:
        #word_fd.inc(word)
        word_fd[word] += 1
        #cond_word_fd['pos'].inc(word)
        cond_word_fd['pos'][word] += 1
    for word in neg:
        #word_fd.inc(word)
        word_fd[word] += 1
        #cond_word_fd['neg'].inc(word)
        cond_word_fd['neg'][word] += 1

    pos_word_count = cond_word_fd['pos'].N()
    neg_word_count = cond_word_fd['neg'].N()
    total_word_count = pos_word_count + neg_word_count

    word_scores = {}
    for word, freq in word_fd.iteritems():
        pos_score = BigramAssocMeasures.chi_sq(cond_word_fd['pos'][word], (freq, pos_word_count), total_word_count)
        neg_score = BigramAssocMeasures.chi_sq(cond_word_fd['neg'][word], (freq, neg_word_count), total_word_count)
        word_scores[word] = pos_score + neg_score

    return word_scores

def find_best_words(word_scores, number):
    best_vals = sorted(word_scores.iteritems(), key=lambda (w, s): s, reverse=True)[:number]
    best_words = set([w for w, s in best_vals])
    return best_words

# Initiallize word's information score and extracting most informative words
word_scores = create_words_bigrams_scores()

best_words = find_best_words(word_scores, 2000) # Be aware of the dimentions

def best_word_features(words):
    return dict([(word, True) for word in words if word in best_words])


# 3. Function that making the reviews to a feature set
def extract_features(dataset):
    feat = []
    for i in dataset:
        feat.append(best_word_features(i))
    return feat


# 4. Load classifier
#clf = pickle.load(open('D:/code/sentiment_test/sentiment_classifier.pkl'))

clf = pickle.load(open(filename))

# Testing single review
#pred = clf.batch_prob_classify(extract_features(sentiment_review[:2])) # An object contian positive and negative probabiliy

pred = clf.prob_classify_many(extract_features(sentiment_review[:]))

pred2 = []
for i in pred:
    pred2.append([i.prob('pos'), i.prob('neg')])

for r in review[:]:
    print r
    print "pos probability score: %f" %pred2[review.index(r)][0]
    print "neg probability score: %f" %pred2[review.index(r)][1]
    print



# 5. Store review sentiment probabilty socre as review helpfulness features
# def store_sentiment_prob_feature(sentiment_dataset, storepath):
# 	pred = clf.batch_prob_classify(extract_features(sentiment_dataset))
# 	p_file = open(storepath, 'w')
# 	for i in pred:
# 	    p_file.write(str(i.prob('pos')) + ' ' + str(i.prob('neg')) + '\n')
# 	p_file.close()
def store_sentiment_prob_feature(sentiment_dataset, storepath):
	#pred = clf.batch_prob_classify(extract_features(sentiment_dataset))
    pred = clf.prob_classify_many(extract_features(sentiment_dataset))
    p_file = open(storepath, 'w')
    for i in pred:
        p_file.write(str(i.prob('pos')) + ' ' + str(i.prob('neg')) + '\n')
    p_file.close()

store_sentiment_prob_feature(sentiment_review[:],filefeature)