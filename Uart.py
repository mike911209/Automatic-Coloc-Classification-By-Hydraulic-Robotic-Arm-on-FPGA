import serial
import time
import cv2
import numpy as np
from utils.color_recognition_module import color_recognition_api

# open webcam
print("webcam opening")
webcam = cv2.VideoCapture(0)
if not webcam.isOpened():
    raise IOError("Cannot open webcam")

# open serial port
print("serial port opening")
ser = serial.Serial(port="COM5", baudrate=9600, bytesize=8, parity='N', stopbits=serial.STOPBITS_ONE)  # Replace 'COMX' with your actual port (e.g., 'COM3' on Windows or '/dev/ttyUSB0' on Linux)
if ser.is_open:
    print("Serial port opened successfully.")

color = ''
count = 0
while True:
    ret, frame = webcam.read()
    frame = cv2.resize(frame, None, fx=1, fy=1, interpolation=cv2.INTER_AREA)
    cv2.imshow('Input', frame)

    predict = color_recognition_api.color_recognition(frame)

    # delay
    if (color != predict):
        count = 0
        color = predict
    else:
        count += 1

    # output the color
    if (count == 50):
        count = 0
        if (color == 'red'):
            ser.write(b'A')
        elif (color == 'black'):
            ser.write(b'B')
        elif (color == 'blue'):
            ser.write(b'C')
        else:
            ser.write(b'\0')
        print(color)
    else:
        ser.write(b'\0')

    c = cv2.waitKey(1)
    if c == 27:
        break

webcam.release()
cv2.destroyAllWindows()