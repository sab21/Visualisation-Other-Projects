# -*- coding: utf-8 -*-
"""
Created on Thu Nov 28 20:43:59 2019

@author: Sabyasachi
"""
# =============================================================================
# Project 1: Camera
# A dataset of about 1000 cameras with 13 properties such as weight, 
# focal length, price, etc.
# =============================================================================

# =============================================================================

# Task 1: Create a dataframe “Camera_data” using Camera.csv

#Importing Packages
import pandas as pd
import numpy as np

RawCamera=pd.read_csv("C:/Users/acer/Desktop/Python Classnotes/Python Project/Python Project 1/Project 1/Camera.csv")

RawCamera.head()
RawCamera.shape #(1038 rows, 13 columns)


#Creating another data set from raw file
camera=RawCamera

camera.columns
#Index(['Model', 'Release date', 'Max resolution', 'Low resolution',
#       'Effective pixels', 'Zoom wide (W)', 'Zoom tele (T)',
#       'Normal focus range', 'Macro focus range', 'Storage included',
#       'Weight (inc. batteries)', 'Dimensions', 'Price']


# Task 2: Find out the percentage of blank values in each column.

print(camera.isnull().sum()/camera.shape[0]*100)

# Model                       0.000000
# Release date                0.000000
# Max resolution              0.096339
# Low resolution              5.202312
# Effective pixels            0.000000
# Zoom wide (W)               8.188825
# Zoom tele (T)               0.000000
# Normal focus range          0.000000
# Macro focus range           0.096339
# Storage included           12.042389
# Weight (inc. batteries)     2.215800
# Dimensions                  1.541426
# Price                       0.000000

# or
print(camera.isnull().mean())


# Task 3: View the statistical summary of the data

DescriptiveStats=camera.describe()
print(DescriptiveStats)

print("Mean: \n",camera.mean())
print("Median: \n",camera.median())
print("Mode: \n",camera.mode())
print("Max: \n",camera.max())
print("Min: \n",camera.min())
print("Var: \n",camera.var())
print("Stdev: \n",camera.std())
print("Kurtosis: \n",camera.kurt())
print("Skew: \n",camera.skew())


# Task 4: Replace all the blank values with NaN.
camera=camera.replace(np.nan,np.NaN)


# Task 5: Now replace all the Blank values with the column median.
camera=camera.fillna(camera.median())
camera.isnull().sum()


# Task 6: Add a new column “Discounted_Price” in which give a discount of 5% in the Price column.
camera["Discounted_Price"]=camera.Price*.95


# Task 7: Drop the columns Zoom Tele & Macro Focus range
camera=camera.drop(["Zoom tele (T)","Macro focus range"],axis=1)


# Task 8: Replace the Model Name “Agfa ePhoto CL50” with “Agfa ePhoto CL250”
camera.Model[camera.Model=="Agfa ePhoto CL50"]="Agfa ePhoto CL250"


# Task 9: Rename the column name from Release Date to Release Year.
camera.columns
camera=camera.rename(columns = {'Release date':'Release year'})


# Task 10: Which is the most expensive Camera?
camera.Model[camera.Price==np.max(camera["Price"])]
camera["Model"][camera.Price==camera.Price.max()]
camera.loc[:,["Model","Price"]][camera.Price==np.max(camera["Price"])]
camera.iloc[:,[0,11]][camera.Price==np.max(camera["Price"])]


# Task 11: Which camera have the least weight?
camera.Model[camera["Weight (inc. batteries)"]==np.min(camera["Weight (inc. batteries)"])]
camera.loc[:,["Model","Weight (inc. batteries)"]][camera.iloc[:,-4]==camera["Weight (inc. batteries)"].min()]


# Task 12: Group the data on the basis of their release year.
gb=camera.groupby("Release year")
gbi=camera.groupby("Release year",as_index=False)
gb["Model"].first()
gbi["Model"].first()
gb.get_group(2007)
gb.get_group(1994)
gb.groups.keys()
[gb.get_group(x) for x in gb.groups]
gb["Release year"].count()
gb.head()


# Task 13: Extract the Name, Storage Include, Price, Disounted_Price & Dimensions columns.
camera.loc[:,["Model","Storage included","Price","Discounted_Price","Dimensions"]]
camera.iloc[:,[0,7,10,11,9]]


# Task 14: Extract the records for the cameras released in the year 2005 & 2006
camera[(camera["Release year"]==2005) |(camera["Release year"]==2006)]
# or
camera[camera["Release year"].isin([2005,2006])]


# Task 15: Find out 2007’s expensive & Cheapest Camera.
cam2007=camera[camera["Release year"]==2007]
cam2007[(cam2007.Price==cam2007.Price.max())|(cam2007.Price==cam2007.Price.min())]
#or
camera[camera["Release year"]==2007][(camera[camera["Release year"]==2007].Price==camera[camera["Release year"]==2007].Price.max())|(camera[camera["Release year"]==2007].Price==camera[camera["Release year"]==2007].Price.min())]


# Task 16: Which Year maximum number of models is released?
#as exact
gbi=camera.groupby("Release year",as_index=False)
gbi['Model'].count().max()
#renaming the index Model to Model Released
gbi["Model"].count().max().rename(index={"Model":"Model_Released"})

# as list
camera["Release year"].value_counts()
gbi["Model"].count()

# =====================================END========================================

