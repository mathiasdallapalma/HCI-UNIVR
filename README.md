# HCI-UNIVR
This project aims to reconstruct real-world structures in VR using photogrammetry and camera pose estimation. 
The repository include several script to automatize the procedure for the construction of a Unity scene and to evaluate the proposed method of camera pose estimation using feature matching using two different methods SIFT and LoFTR.
## Documentation
The Documentation folder contains a detailed explanation of the entire workflow, including:

Project Choices: Justification for key decisions made throughout the project.
Implementation Details: In-depth descriptions of specific components, including scripts and algorithms.
Mathematical Foundations: Discussion of the theoretical background behind the methods used.
Results Analysis: Evaluation of the reconstructed model, camera pose estimation accuracy, and comparisons of different feature matching techniques.

## Structure of the repository
 
│── Documentation/           # Project documentation and reports  
│── Matlab Scripts/          # MATLAB scripts for processing and camera pose estimation  
│   ├── EsempioFiore/        # Scripts related to the "Fiore Method" alignment method  
│   ├── Matching_and_Pose/   # Feature matching and pose estimation scripts  
│   ├── MatlabScripts/       # Script to retrive camera parameters for Unity  
│   ├── Utils/               # Utility functions for MATLAB processing  
│   ├── Visibility_and_Pose/ # Scripts for camera pose from visibility file  
│── Unity/                   # Unity projects for VR scene integration  
|   ├── Homework Scene       # Implementation of images to VR wokflow and camera pose estimation
|   ├── Interactive Scene    # Interactive scene  
│── Utility Scripts/         # Python scripts for additional processing  
|   ├── create_img_stuff.py  # Compress jpg, xml and visibility files
│   ├── calc_visibility.py   # Computes the new visibility from LoFTR matching points   
│   ├── mean.py              # Measures data for analysis  
│── Zephyr workspace/        # Project files from 3D Zephyr 

## Improvements  
- **Automated MATLAB Workflow**: Every MATLAB script includes a file picker to allow easy selection of input files.  
- **Refactored MATLAB Code**: Refactored MATLAB Code: Common code has been moved to the Utils/ folder for better organization and reusability.
- **Scene Setup Script**: Automates the placement of the 3D model and sets up the first camera using extrinsic parameters.  
- **Camera Setup Script**: Allows placing an arbitrary camera in the scene to test different views and configurations. 

The pourpose of the improvements developed was to ensures a semi-automated pipeline for quickly creating and testing photogrammetry-based VR environments. 

## Results

The results of the implemented scripts and code can be explored in the homework Unity scene. This scene contains the 3D model reconstructed using Zephyr photogrammetry from the dataset images, along with the outcomes of different camera pose estimation methods. It also includes a comparison between these methods and the ground truth to evaluate their accuracy.

Additionally, the final scene showcases a simple interactive experience designed to demonstrate the effectiveness of photogrammetry in cultural heritage exploration and education.
