
#more information on README.md

import os
from xml.dom import minidom
import numpy as np
from scipy.spatial.transform import Rotation  
import pandas as pd


def parseXml(file):
    #parse xmp file
    xmldoc = minidom.parse(file)
    #get extrinsics
    extrinsics = xmldoc.getElementsByTagName('extrinsics')
    #get rotation
    rotation = extrinsics[0].getElementsByTagName('rotation')
    #get translation
    translation = extrinsics[0].getElementsByTagName('translation')
    #store inside numpy matrix
    rotation = rotation[0].firstChild.data
    translation = translation[0].firstChild.data
    #store inside numpy matrix
    rotation = np.fromstring(rotation, sep=' ')
    rotation=rotation.reshape((3,3))
    translation = np.fromstring(translation, sep=' ')


    #Mirror y-axis:
    Sy=np.array([[1,0,0],[0,-1,0],[0,0,1]])
    #Invert Y-axis with Z-axis
    YZ=np.array([[1,0,0],[0,0,1],[0,1,0]])


    translation=np.dot(YZ, np.dot((-(np.dot(Sy,rotation))).T,np.dot(Sy,translation)))
    rotation=np.dot(YZ, (np.dot(Sy, rotation)).T)


    R_eun=np.array([[rotation[0][2],rotation[0][0],rotation[0][1]],
                    [rotation[1][2],rotation[1][0],rotation[1][1]],
                    [rotation[2][2],rotation[2][0],rotation[2][1]]])
    
    rotation=np.array([[R_eun[2][0],R_eun[2][1],R_eun[2][2]],
                    [R_eun[0][0],R_eun[0][1],R_eun[0][2]],
                    [R_eun[1][0],R_eun[1][1],R_eun[1][2]]])


    ### first transform the matrix to euler angles
    r =  Rotation.from_matrix(rotation)
    angles = r.as_euler("xyz",degrees=True)
    angles=[angles[1], angles[2],angles[0]]

    n_indsel=0
    n_matches=0

    calcs=xmldoc.getElementsByTagName('calcs')
    if(calcs):
        n_matches=int(calcs[0].getAttribute('n_matches'))
        n_indsel=int(calcs[0].getAttribute('n_indsel'))


    return translation.T,angles,n_matches,n_indsel
 

#list the file inside cwd folder
path='./LoFTR/IMG_20241230_135708_stuff'
files = os.listdir(path)

#remove visibility.txt
#files.remove('Visibility.txt')
#filter for .xmp file
xmp_file = [file for file in files if file.endswith('.xmp')][0]
#retrive r and t as numpyarray

R_true, T_true, n_matches, n_indsel = parseXml(path+"/"+xmp_file)
df = pd.DataFrame(columns=['n_matches', 'n_indsel', 'T_diff', 'R_diff'])


calc_files=[file for file in files if file.endswith('.txt')]
for file in calc_files:
    R_clc, T_clc,n_matches, n_indsel = parseXml(path+"/"+file)

    R_diff = np.array(R_true) - np.array(R_clc)
    T_diff = np.array(T_true) - np.array(T_clc)


    print(T_clc)
    print(T_true)
    #add line in df
    df.loc[len(df)] = [n_matches, n_indsel, np.linalg.norm(T_diff), np.linalg.norm(R_diff)]

    #magnitude of difference
    print(file)
    print(np.linalg.norm(R_diff))
    print(np.linalg.norm(T_diff))
    #add line in df

#save df
df.to_csv('res.csv')
