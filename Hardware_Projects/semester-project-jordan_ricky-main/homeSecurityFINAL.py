import cv2;
import numpy as np;
import time;
import tkinter as tk;
import threading;
from PIL import Image, ImageTk;
import paho.mqtt.client as mqtt;

#time counter and starting variable
timeStart = time.perf_counter();
timeCurrent = 0;

def trackTime():
    global timeCurrent;
    timeCurrent = time.perf_counter() - timeStart;

#mqtt setup values
broker = "eduoracle.ugavel.com"
topic_status = "elee2045/finalproj/light_status"
topic_control_color = "elee2045/finalproj/light_control_color"
topic_control_status = "elee2045/finalproj/light_control_status"
topic_status2 = "elee2045/finalproj/light_status2"
topic_control_color2 = "elee2045/finalproj/light_control_color2"
topic_control_status2 = "elee2045/finalproj/light_control_status2"

#bool values
personBoolA = False;
pictureBoolA = False;
personBoolB = False;
pictureBoolB = False;
cameraA = True;
running = True;

#light control functions
def toggleLight():
    light_status = 0 if light_status_var.get() == "ON" else 1
    client.publish(topic_control_status,bytearray([light_status]))
def toggleLight2():
    light_status2 = 0 if light_status_var2.get() == "ON" else 1
    client2.publish(topic_control_status2,bytearray([light_status2]))

def tryGetColorValue(Entry:tk.Entry):
    try:        
        v = int(Entry.get())
        if v > 255:
            v = 255
        elif v < 0:
            v = 0
        return v
    except:
        Entry.delete(0,tk.END)
        Entry.insert(0,"0")
        return 0
def tryGetColorValue2(Entry2:tk.Entry):
    try:        
        v2 = int(Entry2.get())
        if v2 > 255:
            v2 = 255
        elif v2 < 0:
            v2 = 0
        return v2
    except:
        Entry2.delete(0,tk.END)
        Entry2.insert(0,"0")
        return 0

def sendColor():
    r = tryGetColorValue(R_Entry)
    g = tryGetColorValue(G_Entry)
    b = tryGetColorValue(B_Entry)
    to_send = bytearray([r,g,b])
    client.publish(topic_control_color,to_send)
def sendColor2():
    r2 = tryGetColorValue2(R_Entry2)
    g2 = tryGetColorValue2(G_Entry2)
    b2 = tryGetColorValue2(B_Entry2)
    to_send2 = bytearray([r2,g2,b2])
    client2.publish(topic_control_color2,to_send2)
    
def setColor(r,g,b):
    color_frame.config(bg=f"#{r:02x}{g:02x}{b:02x}")
def setColor2(r2,g2,b2):
    color_frame2.config(bg=f"#{r2:02x}{g2:02x}{b2:02x}")

def pumpMQTT():
    client.loop(0)
    client2.loop(0)
    root.after(10,pumpMQTT) 

def onMessageFromLight(client_obj, userdata, message:mqtt.MQTTMessage):
    if message.topic == topic_status:
        on = int(message.payload[0])
        r = int(message.payload[1])
        g = int(message.payload[2])
        b = int(message.payload[3])
        setColor(r,g,b)
        if on:
            light_status_var.set("ON") 
        else:
            light_status_var.set("OFF") 
        light_time_var.set(time.ctime())
def onMessageFromLight2(client_obj2, userdata2, message2:mqtt.MQTTMessage):
    if message2.topic == topic_status2:
        on2 = int(message2.payload[0])
        r2 = int(message2.payload[1])
        g2 = int(message2.payload[2])
        b2 = int(message2.payload[3])
        setColor2(r2,g2,b2)
        if on2:
            light_status_var2.set("ON") 
        else:
            light_status_var2.set("OFF") 
        light_time_var2.set(time.ctime())

#mqtt initalization
client = mqtt.Client("light1")
client.username_pw_set("giiuser","giipassword")
client.on_message = onMessageFromLight
client.connect(broker)
client.subscribe(topic_status)
client2 = mqtt.Client("light2")
client2.username_pw_set("giiuser","giipassword")
client2.on_message = onMessageFromLight2
client2.connect(broker)
client2.subscribe(topic_status2)

#tkinter inital values
root = tk.Tk();
root.title("defNotFBI");

#GUI camera system
warningLabel = tk.Label(root, text = "WARNING: THE PROGRAM MUST BE CLOSED USING THE 'CLOSE APP' BUTTON");
warningLabel.grid(row = 0, column = 3);
cameraLabel = tk.Label(root, text = "Current Camera: A");
cameraLabel.grid(row = 2, column = 3);
cameraFrame = tk.Frame(root, width = 640, height = 640);
cameraFrame.grid(row = 3, column = 3);
cameraImage = tk.Label(cameraFrame);
cameraImage.grid(row = 3, column = 3);

#GUI light control
status_frame = tk.LabelFrame(root,text="Light 1 Status")
status_frame.grid(row=0, column=1)
light_status_var = tk.StringVar(root,"Unknown")
light_time_var = tk.StringVar(root,"Light 1 not connected")
light_status_label = tk.Label(status_frame,textvariable=light_status_var).pack()
light_time_label = tk.Label(status_frame,textvariable=light_time_var).pack()
color_frame = tk.Frame(status_frame,width=50,height=50)
color_frame.pack(fill=tk.X, expand=1,padx=10,pady=10)

status_frame2 = tk.LabelFrame(root,text="Light 2 Status")
status_frame2.grid(row=0, column=2)
light_status_var2 = tk.StringVar(root,"Unknown")
light_time_var2 = tk.StringVar(root,"Light 2 not connected")
light_status_label2 = tk.Label(status_frame2,textvariable=light_status_var2).pack()
light_time_label2 = tk.Label(status_frame2,textvariable=light_time_var2).pack()
color_frame2 = tk.Frame(status_frame2,width=50,height=50)
color_frame2.pack(fill=tk.X, expand=1,padx=10,pady=10)

control_frame = tk.LabelFrame(root,text="Light 1 Control")
control_frame.grid(row=1, column=1)
tk.Button(control_frame,text="Toggle Light 1",command=toggleLight).grid(row=0,column=0,columnspan=2)
tk.Label(control_frame,text="R:").grid(row=1,column=0)
tk.Label(control_frame,text="G:").grid(row=2,column=0)
tk.Label(control_frame,text="B:").grid(row=3,column=0)
R_Entry = tk.Entry(control_frame,width=20)
G_Entry = tk.Entry(control_frame,width=20)
B_Entry = tk.Entry(control_frame,width=20)
R_Entry.grid(row=1,column=1)
G_Entry.grid(row=2,column=1)
B_Entry.grid(row=3,column=1)
tk.Button(control_frame,text="Set Color",command=sendColor).grid(row=4,column=0,columnspan=2)

control_frame2 = tk.LabelFrame(root,text="Light 2 Control")
control_frame2.grid(row=1,column=2)
tk.Button(control_frame2,text="Toggle Light 2",command=toggleLight2).grid(row=0,column=0,columnspan=2)
tk.Label(control_frame2,text="R:").grid(row=1,column=0)
tk.Label(control_frame2,text="G:").grid(row=2,column=0)
tk.Label(control_frame2,text="B:").grid(row=3,column=0)
R_Entry2 = tk.Entry(control_frame2,width=20)
G_Entry2 = tk.Entry(control_frame2,width=20)
B_Entry2 = tk.Entry(control_frame2,width=20)
R_Entry2.grid(row=1,column=1)
G_Entry2.grid(row=2,column=1)
B_Entry2.grid(row=3,column=1)
tk.Button(control_frame2,text="Set Color",command=sendColor2).grid(row=4,column=0,columnspan=2)

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
changeCamera.grid(row = 4, column = 3)

#close program
def closeWindow():
    global running;
    running = False;
    root.destroy();
closeAllWindow = tk.Button(root, text = "CLOSE APP", command = closeWindow);
closeAllWindow.grid(row = 1, column = 3)

#video capture from docs.opencv.org, changed the file path
fourcc = cv2.VideoWriter_fourcc(*'DIVX');
outA = cv2.VideoWriter(r'C:\\School\\Programming Labs\\Git\\Final Project\\videos\\suspect1.avi', fourcc, 20.0, (640,  480));
outB = cv2.VideoWriter(r'C:\\School\\Programming Labs\\Git\\Final Project\\videos\\suspect2.avi', fourcc, 20.0, (640,  480));

#yolo initialization
netA = cv2.dnn.readNet(r'C:\\School\\Programming Labs\\Git\\Final Project\\yolov5a.onnx');
netB = cv2.dnn.readNet(r'C:\\School\\Programming Labs\\Git\\Final Project\\yolov5b.onnx');
with open(r'C:\\School\\Programming Labs\\Git\\Final Project\\classes.txt') as f:
    classesA = [s.strip() for s in f.readlines()];

#webcam
def mainA():
    global pictureBoolA, capture;
    capture = cv2.VideoCapture(0);
    while capture.isOpened():
        res, frame = capture.read();
        if not res:
            continue;
        process_frameA(frame);
        trackTime();
        #renaming image based on time
        directory = r'C:\\School\\Programming Labs\\Git\\Final Project\\pictureA\\' + str(timeCurrent) + r'.jpg';
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
    global pictureBoolB, capture2;
    capture2 = cv2.VideoCapture(1);
    while capture2.isOpened():
        res, frame = capture2.read();
        if not res:
            continue;
        process_frameB(frame);
        #renaming image based on time
        directory = r'C:\\School\\Programming Labs\\Git\\Final Project\\pictureB\\' + str(timeCurrent) + r'.jpg';
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

#tkinter and mqtt main loop
pumpMQTT()
root.mainloop();
t1.join();
t2.join();
