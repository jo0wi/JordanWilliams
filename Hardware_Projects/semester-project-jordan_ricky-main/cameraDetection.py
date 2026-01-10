import cv2;
import numpy as np;
import time;
import tkinter as tk;
import threading;
from PIL import Image, ImageTk;

#time counter and starting variable
timeStart = time.perf_counter();
timeCurrent = 0;

def trackTime():
    global timeCurrent;
    timeCurrent = time.perf_counter() - timeStart;

#bool values
personBoolA = False;
pictureBoolA = False;
personBoolB = False;
pictureBoolB = False;
cameraA = True;
running = True;

#tkinter inital values
root = tk.Tk();
root.title("defNotFBI");

#GUI
warningLabel = tk.Label(root, text = "WARNING: THE PROGRAM MUST BE CLOSED USING THE 'CLOSE APP' BUTTON");
warningLabel.grid(row = 0, column = 0);
cameraLabel = tk.Label(root, text = "Current Camera: A");
cameraLabel.grid(row = 2, column = 0);
cameraFrame = tk.Frame(root, width = 640, height = 640);
cameraFrame.grid(row = 3, column = 0);
cameraImage = tk.Label(cameraFrame);
cameraImage.grid(row = 3, column = 0);

#change camera in tkinter
def cameraValue():
    global cameraA;
    if cameraA == True:
        cameraA = False;
        cameraLabel.configure(text = "Current Camera: B");
    else:
        cameraA = True;
        cameraLabel.configure(text = "Current Camera: A");
changeCamera = tk.Button(root, text = "Change Camera", command = cameraValue);
changeCamera.grid(row = 4, column = 0)

#close program
def closeWindow():
    global running;
    running = False;
    root.destroy();
closeAllWindow = tk.Button(root, text = "CLOSE APP", command = closeWindow);
closeAllWindow.grid(row = 1, column = 0)

#video capture from docs.opencv.org, changed the file path
fourcc = cv2.VideoWriter_fourcc(*'DIVX');
outA = cv2.VideoWriter('C:\School\Programming Labs\Git\Final Project\\videoA\suspect1.avi', fourcc, 20.0, (640,  480));
outB = cv2.VideoWriter('C:\School\Programming Labs\Git\Final Project\\videoB\suspect2.avi', fourcc, 20.0, (640,  480));

#yolo initialization
netA = cv2.dnn.readNet('C:\School\Programming Labs\Git\Final Project\yolov5a.onnx');
netB = cv2.dnn.readNet('C:\School\Programming Labs\Git\Final Project\yolov5b.onnx');
with open('C:\School\Programming Labs\Git\Final Project\classes.txt') as f:
    classesA = [s.strip() for s in f.readlines()];

#webcam
def mainA():
    global pictureBoolA;
    capture = cv2.VideoCapture(0);
    while capture.isOpened():
        res, frame = capture.read();
        if not res:
            continue;
        process_frameA(frame);
        trackTime();
        #renaming image based on time
        directory = 'C:\School\Programming Labs\Git\Final Project\pictureA\\' + str(timeCurrent) + '.jpg';
        #starts recording video once person enters frame: DOES NOT STOP UNTIL PROGRAM EXITS
        if personBoolA == True:
            outA.write(frame);
        #starts taking pictures whenever person is in fame
        if pictureBoolA == True:
            cv2.imwrite(directory, frame);
            pictureBoolA = False;
        #using pillow to convert from cv2 to tkinter
        if running == True:
            imageColor = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frameImage = Image.fromarray(imageColor);
            tkinterImage = ImageTk.PhotoImage(image = frameImage);
            if cameraA == True:
                cameraImage.configure(image = tkinterImage);
        if running == False:
            capture.release();
            break;

def mainB():
    global pictureBoolB;
    capture2 = cv2.VideoCapture(1);
    while capture2.isOpened():
        res, frame = capture2.read();
        if not res:
            continue;
        process_frameB(frame);
        #renaming image based on time
        directory = 'C:\School\Programming Labs\Git\Final Project\pictureB\\' + str(timeCurrent) + '.jpg';
        #starts recording video once person enters frame: DOES NOT STOP UNTIL PROGRAM EXITS
        if personBoolB == True:
            outB.write(frame);
        #starts taking pictures whenever person is in fame
        if pictureBoolB == True:
            cv2.imwrite(directory, frame);
            pictureBoolB = False;
        #using pillow to convert from cv2 to tkinter
        if running == True:
            imageColor = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frameImage = Image.fromarray(imageColor);
            tkinterImage = ImageTk.PhotoImage(image = frameImage);
            if cameraA == False:
                cameraImage.configure(image = tkinterImage);
        if running == False:
            capture2.release();
            break;

#YOLO
def format_yolov5A(frame):
    col, row, _ = frame.shape; #image in square
    _max = max(col, row); #max dimension
    resized = np.zeros((_max, _max, 3), np.uint8); #new square frame
    resized[0:col, 0:row] = frame; #insert og image
    result = cv2.dnn.blobFromImage(resized, 1/255.0, (640, 640), swapRB = True);
    return result;

def format_yolov5B(frame):
    col, row, _ = frame.shape; #image in square
    _max = max(col, row); #max dimension
    resized = np.zeros((_max, _max, 3), np.uint8); #new square frame
    resized[0:col, 0:row] = frame; #insert og image
    result = cv2.dnn.blobFromImage(resized, 1/255.0, (640, 640), swapRB = True);
    return result;

def process_frameA(frame):
    blob = format_yolov5A(frame); #convert to yolo input
    netA.setInput(blob);
    predictions = netA.forward();
    output = predictions[0];
    boxes = [];
    confidences = [];
    class_ids = [];
    for row in output: #xc, yc, w, h, conf
        if row[4] > 0.5:
            xc, yc, w, h = row[0], row[1], row[2], row[3];
            max_index = cv2.minMaxLoc(row[5:])[3][1]; #find the highest probability class
            class_ids.append(max_index);
            left = int(xc-w/2);
            top = int(yc-h/2);
            width = int(w);
            height = int(h);
            confidences.append(row[4]);
            boxes.append([left, top, width, height]);
    indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.25, 0.45); #remove duplicate boxes
    draw_boxes(frame, boxes, indexes, class_ids);

def process_frameB(frame):
    blob = format_yolov5B(frame); #convert to yolo input
    netB.setInput(blob);
    predictions = netB.forward();
    output = predictions[0];
    boxes = [];
    confidences = [];
    class_ids = [];
    for row in output: #xc, yc, w, h, conf
        if row[4] > 0.5:
            xc, yc, w, h = row[0], row[1], row[2], row[3];
            max_index = cv2.minMaxLoc(row[5:])[3][1]; #find the highest probability class
            class_ids.append(max_index);
            left = int(xc-w/2);
            top = int(yc-h/2);
            width = int(w);
            height = int(h);
            confidences.append(row[4]);
            boxes.append([left, top, width, height]);
    indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.25, 0.45); #remove duplicate boxes
    draw_boxes2(frame, boxes, indexes, class_ids);

def draw_boxes(frame, boxes, indexes, class_ids):
    global personBoolA, pictureBoolA;
    sf = int(max(frame.shape[0], frame.shape[1])/640); #determine scale factor to convert back
    for i in indexes:
        x, y, w, h = [v*sf for v in boxes[i]]; #extract box values multiplied by scale factor
        cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2); #draws blue box
        cv2.putText(frame, classesA[class_ids[i]], (x, y), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255));
        #logic for checking if classes appeared in frame
        if classesA[class_ids[i]] == 'person':
            personBoolA = True;
            pictureBoolA = True;

def draw_boxes2(frame, boxes, indexes, class_ids):
    global personBoolB, pictureBoolB;
    sf = int(max(frame.shape[0], frame.shape[1])/640); #determine scale factor to convert back
    for i in indexes:
        x, y, w, h = [v*sf for v in boxes[i]]; #extract box values multiplied by scale factor
        cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2); #draws blue box
        cv2.putText(frame, classesA[class_ids[i]], (x, y), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255));
        #logic for checking if classes appeared in frame
        if classesA[class_ids[i]] == 'person':
            personBoolB = True;
            pictureBoolB = True;

#new thread for camera
t1 = threading.Thread(target = mainA);
t2 = threading.Thread(target = mainB);
t1.start();
t2.start();

#tkinter main loop...running variable to close the cv2 instances before the loops merge
root.mainloop();
t1.join();
t2.join();
