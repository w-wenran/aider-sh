#!/bin/bash

ffmpeg  -video_size 320x240 -f dshow -i video="Integrated Camera" -f rtsp rtsp://192.168.30.136:8080/live/my
