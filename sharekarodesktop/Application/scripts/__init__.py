"""
This file contains all the panel and necessary frames instances to refresh them later in the project
"""
# HOST= ""
# PORT=5000
FORMAT="utf-8"
# ADDRESS = (HOST, PORT)
VIDEOBUFFER=1048576
BUFFER=4096
QUIT="QUIT"
RECEIVED="RECEIVED"
JOIN="JOIN"
ACCEPTED="ACCEPTED"
_SEND="-s"
SIZE_RECEIVED = "SIZE RECEIVED"
START_SENDING = "START SENDING"
IMAGE_EXT = ["png", "jpg", "jpeg"]
VIDEO_EXT = ["mkv", "mp4", "3gp"]
DOC_EXT = ["docx", "pdf", "csv", "pptx", "xlxs"]
MUSIC_EXT = ['mp3']

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    
_instances = {}
transferringFilesFrames = {}
serverIp = {}
filesframe = {}