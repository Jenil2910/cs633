# -*- coding: utf-8 -*-
"""
Created on Thu Aug 15 20:48:21 2019

@author: Sanket
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib
import sys

matplotlib.rc('figure', figsize=(13, 7))

if(len(sys.argv)<4):
    print("Usage: python heatmap.py data_file plot_file keep_center. If keep_center = 0, then center will be zeroed")

file = open(sys.argv[1], "r")
plotfile = sys.argv[2]
center = int(sys.argv[3])

dix = {}

X, Y, Z = [], [], []

for l in file:
    row = l.split()
    x = float(row[0].lstrip().rstrip())
    y = float(row[1].lstrip().rstrip())
    z = float(row[2].lstrip().rstrip())

    if x not in dix.keys():
        dix[x] = {}
    if y not in dix[x].keys():
        dix[x][y] = []

    if( x!=y or (x==y and center)):
        dix[x][y].append(z)
    else:
        dix[x][y].append(0)

for x in dix.keys():
    for y in dix[x].keys():
        X.append(x)
        Y.append(y)
        z = np.median(dix[x][y])
        Z.append(z)


file.close()


data = pd.DataFrame({'X': X, 'Y': Y, 'Z': Z})
data_pivoted = data.pivot("Y", "X", "Z")
ax = sns.heatmap(data_pivoted)
plt.savefig(plotfile)
# plt.show()

