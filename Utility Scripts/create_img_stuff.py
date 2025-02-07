
#more information on README.md

import os
import tkinter as tk
import shutil
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

cwd=os.path.dirname(os.path.abspath(__file__))

file_path = filedialog.askopenfilename(initialdir = cwd, title = "Select image", filetypes = (("jpeg files","*.jpg"),("all files","*.*")))
print(file_path)
file_name = os.path.basename(file_path)
print(file_name)

zepyhr_out_folder=filedialog.askdirectory(initialdir =cwd, title = "Select zephyr output folder")
print(zepyhr_out_folder)


xmp_file=zepyhr_out_folder+"/"+file_name+".xmp"
#throw erroe if file does not exist
if not os.path.isfile(xmp_file):
    print("xmp file does not exist in the folder")
    #show error in a dialog box
    tk.messagebox.showerror("Error", "xmp file does not exist in the folder")
    exit()

visibility_file=zepyhr_out_folder+"/Visibility.txt"

#throw erroe if file does not exist
if not os.path.isfile(visibility_file):
    print("visibility file does not exist in the folder")
    #show error in a dialog box
    tk.messagebox.showerror("Error", "visibility file does not exist in the folder")
    exit()


#create new folder
new_folder=os.getcwd()+"/"+file_name.split(".")[0]+"_stuff"
#throw erroe if folder already exists
if os.path.exists(new_folder):
    print("folder already exists")
    #show error in a dialog box
    tk.messagebox.showerror("Error", "folder for stuff already exists")
    exit()

os.makedirs(new_folder)

#copy the image to the new folder
shutil.copy(file_path, new_folder)
#copy the xmp file to the new folder
shutil.copy(xmp_file, new_folder)



#read the visibility file
with open(visibility_file, 'r') as file:
    #read the file untill image name is found
    while True:
        line = file.readline()
        if line.__contains__(file_name):
            break
    
    new_visibility=line

    while True:
        line = file.readline()
        if not line.__contains__("Visibility"):
            new_visibility += line
        else:
            break

with open(new_folder+"/Visibility.txt", 'w') as file:
    file.write(new_visibility)

print("done")
#show success message
tk.messagebox.showinfo("Success", "folder for "+file_name+" created successfully")

    


    

