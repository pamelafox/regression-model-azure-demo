from time import time
import pickle
import joblib

t1 = time()
lis = []
d = pickle.load(open("function/yearly-comp.pkl_pickle", "rb"))
print("time for loading file size with pickle", time()-t1)

t1 = time()
joblib.load("function/yearly-comp.pkl_joblib")
print("time for loading file size joblib", time()-t1)