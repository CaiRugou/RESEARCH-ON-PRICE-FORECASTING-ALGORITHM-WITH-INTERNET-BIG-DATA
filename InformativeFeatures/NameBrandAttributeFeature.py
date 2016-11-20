#! /usr/bin/env python2.7
#coding=utf-8

"""
Counting the product name, product brand and product attribute appear times in the review.
This module aim to extract product_name_brand_attribute features.

"""

import textprocessing as tp

# Read txt files include product name, product brand and product attributes
"""
name = tp.get_txt_data("D:/code/product_name.txt", "lines")
brand = tp.get_txt_data("D:/code/product_brand.txt", "lines")
attribute = tp.get_txt_data("D:/code/product_attribute", "lines")
"""
name = tp.get_txt_data('E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/InformativeFeatures/product_name_brand_attribute/name.txt','lines')
brand = tp.get_txt_data('E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/InformativeFeatures/product_name_brand_attribute/brand.txt','lines')
attribute = tp.get_txt_data('E:/GraduationProject/pythoncode/project/Prediction/main/FeatureExtractionModule/InformativeFeatures/product_name_brand_attribute/attibute.txt','lines')

# Function counting feature appearing times
def name_brand_attribute(dataset):
    num = []
    n, b, a = 0, 0, 0
    for review in dataset:
        for word in review:
            if word in name:
                n += 1
            elif word in brand:
                b += 1
            elif word in attribute:
                a += 1
        num.append((n, b, a))
        n, b, a = 0, 0, 0
    return num

# Store features
def store_name_brand_attribute_features(filepath, sheetnum, colnum, data, storepath):
	data = tp.seg_fil_excel(filepath, sheetnum, colnum)
	n_b_a = name_brand_attribute(data) # Need initiallized

	f = open(storepath, 'w')
	for i in n_b_a:
	    f.write(str(i[0])+' '+str(i[1])+' '+str(i[2])+'\n')
	f.close()


"""
testing
"""
storepath = 'E:/GraduationProject/pythoncode/project/Prediction/main/result/NameBrandAttributeFeature.txt'
filepath = 'E:/GraduationProject/pythoncode/project/Prediction/main/ReviewSet/Motorala.xlsx'
data = []
store_name_brand_attribute_features(filepath,1,11,data,storepath)


"""
完成调试测试，功能实现
"""