import matplotlib.pyplot as plt
import numpy as np

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import ConnectionPatch
import random

#read output csv file
SIFT_matches=np.genfromtxt('SIFT_matches.csv', delimiter=',', skip_header=0)
LoFTR_matches=np.genfromtxt('LoFTR_matches.csv', delimiter=',', skip_header=0)

LoFTR_selected_matches=np.genfromtxt('LoFTR_selected.csv', delimiter=',', skip_header=0)
SIFT_selected_matches=np.genfromtxt('SIFT_selected.csv', delimiter=',', skip_header=0)

target_img_path="./trg_img.jpg"
reference_image_path="./ref_img.jpg"

#read images
target_img=plt.imread(target_img_path)
reference_image=plt.imread(reference_image_path)

#plot reference image with SIFT matches
fig, ax = plt.subplots(1,1)
ax.set_title('SIFT keypoints', fontsize=16)
ax.imshow(reference_image)

ax.axis('off')

for i in range(SIFT_matches.shape[0]):
    ax.plot(SIFT_matches[i, 0], SIFT_matches[i, 1], 'ro', markersize=2)
for i in range(SIFT_selected_matches.shape[0]):
    ax.scatter(SIFT_selected_matches[i, 0], SIFT_selected_matches[i, 1], s=80, facecolors='none', edgecolors='blue', linewidth=1)


#plot reference image with LoFTR matches
#LoFTR keypoints are calculated on 480x360 image, so they need to be scaled by 5.1 in x and 3.825 in y
fig, ax = plt.subplots(1,1)
ax.set_title('LoFTR keypoints', fontsize=16)
ax.imshow(reference_image)

ax.axis('off')


for i in range(LoFTR_matches.shape[0]):
    ax.plot(LoFTR_matches[i, 0]*5.1, LoFTR_matches[i, 1]*3.825, 'ro', markersize=2)
for i in range(LoFTR_selected_matches.shape[0]):
    ax.scatter(LoFTR_selected_matches[i, 0]*5.1, LoFTR_selected_matches[i, 1]*3.825, s=80, facecolors='none', edgecolors='blue', linewidth=1)


#plot LoFTR matches between reference and target image 
fig, ax = plt.subplots(1,2)
fig.suptitle('LoFTR matches', fontsize=16)
ax[0].set_title('Reference image', fontsize=16)
ax[1].set_title('Target image', fontsize=16)

ax[0].axis('off')
ax[1].axis('off')

ax[0].imshow(reference_image)
for i in range(LoFTR_selected_matches.shape[0]):
    ax[0].scatter(LoFTR_selected_matches[i, 0]*5.1, LoFTR_selected_matches[i, 1]*3.825, s=80, facecolors='none', edgecolors='blue', linewidth=1)
    ax[0].plot(LoFTR_selected_matches[i, 0]*5.1, LoFTR_selected_matches[i, 1]*3.825, 'ro', markersize=1)


ax[1].imshow(target_img)
for i in range(LoFTR_selected_matches.shape[0]):
    ax[1].scatter(LoFTR_selected_matches[i, 2]*5.1, LoFTR_selected_matches[i, 3]*3.825, s=80, facecolors='none', edgecolors='blue', linewidth=1)
    ax[1].plot(LoFTR_selected_matches[i, 2]*5.1, LoFTR_selected_matches[i, 3]*3.825, 'ro', markersize=1)

#plot the connection between the points
for i in range(LoFTR_selected_matches.shape[0]):
    
    xy_source = (LoFTR_selected_matches[i,0]*5.1,LoFTR_selected_matches[i,1]*3.825)
    xy_target = (LoFTR_selected_matches[i,2]*5.1,LoFTR_selected_matches[i,3]*3.825)

    con = ConnectionPatch(xyA=xy_source, xyB=xy_target, coordsA="data", coordsB="data",
                        axesA=ax[0], axesB=ax[1], color="red")
    ax[1].add_artist(con)
 

#plot SIFT matches between reference and target image
fig, ax = plt.subplots(1,2)
fig.suptitle('SIFT matches', fontsize=16)
ax[0].set_title('Reference image', fontsize=16)
ax[1].set_title('Target image', fontsize=16)

ax[0].axis('off')
ax[1].axis('off')


ax[0].imshow(reference_image)
for i in range(SIFT_selected_matches.shape[0]):
    ax[0].scatter(SIFT_selected_matches[i, 0], SIFT_selected_matches[i, 1], s=80, facecolors='none', edgecolors='blue', linewidth=1)
    ax[0].plot(SIFT_selected_matches[i, 0], SIFT_selected_matches[i, 1], 'ro', markersize=1)

ax[1].imshow(target_img)
for i in range(SIFT_selected_matches.shape[0]):
    ax[1].scatter(SIFT_selected_matches[i, 2], SIFT_selected_matches[i, 3], s=80, facecolors='none', edgecolors='blue', linewidth=1)
    ax[1].plot(SIFT_selected_matches[i, 2], SIFT_selected_matches[i, 3], 'ro', markersize=1)

#plot the connection between the points
for i in range(SIFT_selected_matches.shape[0]):
    
    xy_source = (SIFT_selected_matches[i,0],SIFT_selected_matches[i,1])
    xy_target = (SIFT_selected_matches[i,2],SIFT_selected_matches[i,3])

    con = ConnectionPatch(xyA=xy_source, xyB=xy_target, coordsA="data", coordsB="data",
                        axesA=ax[0], axesB=ax[1], color="red")
    ax[1].add_artist(con)

plt.show(block=True)


