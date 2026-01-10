# ELEE Final Project
## Group members:
1. Jordan
2. Ricky

## Goal: Final project will consist of a home security system and light control using M5 stick and webcam integration. 
1. GUI in Tkinter/Pygame
2. Control 2 M5sticks, light, color, on/off status
3. Detect people in webcams.
4. Save screenshot of camera footage and timestamp when person detected.
5. Switch between 2 cameras in tkinter/pygame. 

## Final project file: 
1. https://github.com/elee2045sp23/semester-project-edwin_ricky/blob/main/homeSecurityFINAL.py

## Video of project working: 
1. https://github.com/elee2045sp23/semester-project-edwin_ricky/blob/main/projectVideo.mp4

## Finished product features:
1. Light on/off control through the tkinter GUI and the M5Stick button
2. M5Stick color control
3. Light status indicator in the GUI
4. 2 M5Sticks connected
5. Ability to view live camera footage through tkinter
6. Ability to switch between the 2 connected camera outputs
7. YOLO to detect whether or not a person is in view of each camera
8. Each camera acts independently of eachother
9. Each camera will individually start recording video once a person is detected
10. Each camera will individually save pictures with timestamps whenever a person is view

## Work completed by each group member
1. M5Stick arduino code, light control GUI, mqtt integration: Jordan
2. Camera detection, camera tkinter integration, camera recording + pictures: Ricky
3. Integration of the two halves of the project: Together

## Product quirks
1. A video file is created at the beginning, even if a camera does not record. If a camera does record, then it will be a normal video. If the camera does not record, then the video file will exist, but it will be empty.
2. There are white flashes in the camera footage at times in tkinter, but this does not show up in camera recording or pictures. It does not show up in the cv2 window either during testing.

## MUST DO BEFORE USING PROGRAM
1. Change the directory for the camera outputs to a location where you want the files to be saved before using the program. The variables are: outA (videoA), outB (videoB), and directory (inside the functions mainA() and mainB()). NOTE: If you want to save the files within a new folder, said folder must already exist prior to running the program. Failure to do so may result in no videos or images being saved to your computer.
2. Change the directory of the location for the yolov5a.onnx, yolov5b.onnx, and classes.txt to where they are located on your computer. The variables for these are: netA (yolov5a), netB (yolov5b), and the 'with open()' function right below netB (classes.txt). Failure to do so will prevent the program from running.

## WARNING
1. THE PROGRAM MUST CLOSE THROUGH THE 'CLOSE ALL' BUTTON IN TKINTER
2. Failure to do so will result in the camera functions perpetually 'using' the video files they created. You will be unable to move, edit, or delete the files until the program is manually stopped in vscode.
3. Putting 'running = False' along with 'capture.release()' and 'capture2.release' after 'root.mainloop' does not fix the issue when you close out tkinter with the 'x'
4. The 'CLOSE ALL' button breaks the camera functions before tkinter is closed using 'root.destroy'. For some reason this is the only sequence that works.
