
#more information on README.md

import numpy as np
import os
from scipy.spatial import KDTree

#read visibility
path='./LoFTR/imgs'

folders=os.listdir(path)

#for folder in folders:
folder=folders[0]

#read LoFTR matches
matches_file=path+"/"+folder+"/output.csv"
p_ref_matched=[]
p_trg_matched=[]

with open(matches_file, 'r') as file:
    line=file.readline()
    while line:
        #[x_ref, y_ref, x_tar, y_tar]=line.split(',')
        [x_tar, y_tar, x_ref, y_ref]=line.split(',')
        p_ref_matched.append(np.array([float(x_ref)*5.1, float(y_ref)*3.825]))
        p_trg_matched.append(np.array([float(x_tar)*5.1, float(y_tar)*3.825]))

        line=file.readline()

visibility_file=path+"/"+folder+"/Visibility.txt"
kdtree=KDTree(p_ref_matched)

#read visibility
new_visibility=""
with open(visibility_file, 'r') as file:
    line0 = file.readline()
    line1 = file.readline()

    points=0

    line = file.readline()
    while line:
        [p3D, x, y] = line.split()
        p2D=np.array([float(x), float(y)])
        distance,index=kdtree.query(p2D)
        if(distance<4):
            new_visibility+="{} {} {}\n".format(p3D,p_trg_matched[index][0],p_trg_matched[index][1])
            points+=1
        line = file.readline()

new_visibility_path=path+"/"+folder+"/NewVisibility.txt"

new_visibility="Visibility for image 000000000000000000.jpg\n{}\n{}".format(points,new_visibility)

with open(new_visibility_path, 'w') as file:
    file.write(new_visibility)


