#! /usr/bin/env python2.7
#coding=utf-8

"""
Counting review's word number, sentence number and review length
This module aim to extract review's word number and sentence number and review length features.

"""

"""
计算评论中的 词数、句子数量、评论特征长度
"""
import textprocessing as tp
#文本预处理中包含 读取txt excel文件， 将评论分句，将句子分词，标记词性。



#word_sent_count(para) 函数接受数据集为参数，函数功能：计数评论中的词数，句子数量和评论的长度
# Function counting review word number, sentence number and review length
def word_sent_count(dataset):
    word_sent_count = []
    for review in dataset:
        sents = tp.cut_sentence_2(review)       #将每条评论进行分句，得到每条评论的 分句
        words = tp.segmentation(review,'list')  #将每条评论进行分词，保存分词结果到列表数组中
        sent_num = len(sents)                   #记录每条评论分句完后的句子数量
        word_num = len(words)                   #记录每条评论的 分词后的 词数
        sent_word = float(word_num)/float(sent_num)         #评论的长度 = 分词数/分句数
        word_sent_count.append([word_num,sent_num,sent_word])
    return word_sent_count




"""
testing
"""

"""
def word_sent_count(dataset):
    word_sent_count = []
    for review in dataset:
        sents = tp.cut_sentence_2(review)
        words = tp.segmentation(review,'list')
        sent_num = len(sents)
        word_num = len(words)
        sent_word = float(word_num)/float(sent_num)  # review length = word number/sentence number
        word_sent_count.append([word_num, sent_num, sent_word])
    return word_sent_count
"""

# Store features
#存储评论的特征
def store_word_sent_num_features(filepath, sheetnum, colnum, data, storepath):
    data = tp.get_excel_data(filepath, sheetnum, colnum,'data')

    word_sent_num = word_sent_count(data)     #需要初始化
    print word_sent_num
    f = open(storepath, 'w')
    for i in word_sent_num:
        f.write(str(i[0])+' '+str(i[1])+' '+str(i[2])+'\n')
    f.close()

"""
testing
"""

filepath = 'E:/GraduationProject/pythoncode/project/Prediction/main/ReviewSet/Motorala.xlsx'
result = 'E:/GraduationProject/pythoncode/project/Prediction/main/result/Linguisitic_len_Features.txt'
data = []
store_word_sent_num_features(filepath,1,11,data,result)

"""
功能完善，修复若干bug
"""



"""
def store_word_sent_num_features(filepath, sheetnum, colnum, data, storepath):
    data = tp.seg_fil_excel(filepath, sheetnum, colnum)

    word_sent_num = word_sent_count(data) # Need initiallized

    f = open(storepath,'w')
    for i in word_sent_num:
        f.write(str(i[0])+' '+str(i[1])+' '+str(i[2])+'\n')
    f.close()
"""