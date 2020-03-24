import scipy.io
import numpy

# NOTE: This file is the single configuration test

# read data from MATLAB file
Data = scipy.io.loadmat('CarexRouting.mat')
CableSeg = Data['CableSeg']
CbRtPtBdId = Data['CbRtPtBdId']
CbRtPtCrd = Data['CbRtPtCrd']

print(Data)


