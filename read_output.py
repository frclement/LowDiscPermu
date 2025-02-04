# -*- coding: utf-8 -*-
"""
Created on Tue Feb  4 09:57:34 2025

@author: f.clement00
"""



import matplotlib.pyplot as plt
import math

from operator import itemgetter
import csv


def readplot_jl(filename,n):
    f=open(filename,'r')
    X=f.readline().split()
    Y=f.readline().split()
    A=f.readline().split()
    Z=f.readline().split()
    f.close()
    L=[]
    M=[]
    P=[]
    for i in range(n):
        if (i==0):
            L.append(float(X[2+i][1:-1]))
            M.append(float(Y[2+i][1:-1]))
        else:
            L.append(float(X[2+i][:-1]))
            M.append(float(Y[2+i][:-1]))
    for i in range(n):# Last block doesn't matter
        t=i*(n+1)
        for j in range(n): #Dummy variable in the way
            if (j==0 and i==0):
                if (float(A[2+t+j][1:-1])>0.5):
                    P.append([L[i],M[j]])
            else:
                if (float(A[2+t+j][:-1])>0.5):
                    P.append([L[i],M[j]])
    return(P, float(Z[2]))


def locdisc(x,y,P):
    no=0
    nc=0
    n=len(P)
    for i in range(n):
        if (P[i][0]<x and P[i][1]<y):
            no+=1
        if (P[i][0]<=x and P[i][1]<=y):
            nc+=1
    f=max(x*y-no/n,nc/n-x*y)
    return(f)  

def heatmap(filename,n):
    (P,z)=readplot_jl(filename,n)
    PX=[P[i][0] for i in range(n)]
    PY=[P[i][1] for i in range(n)]
    X=[0.001*i for i in range(0,1001)]
    Y=[0.001*i for i in range(0,1001)]
    Z=[[0 for i in range(1001)] for j in range(1001)]
    maxi=0
    mxii=0
    mxjj=0
    for i in range(len(X)):
        for j in range(len(Y)):
            Z[j][i]=locdisc(X[i],Y[j],P)
            if (Z[j][i]>maxi):
                maxi=Z[j][i]
                mxii=i
                mxjj=j
    plt.figure(figsize=(7,6))
    cs=plt.contourf(X,Y,Z,40)
    cbar=plt.colorbar(cs)
    plt.scatter(PX,PY,c='r',s=50,linewidth=5,alpha=0.5)
    plt.scatter(mxii/1000,mxjj/1000,c='black')
    plt.savefig(filename[:-3]+".png",dpi=300)
    plt.show()
    return(maxi)