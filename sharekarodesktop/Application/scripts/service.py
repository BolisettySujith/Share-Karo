import json
import math
import socket
from tkinter import EXCEPTION, Widget
from tkinter.constants import ACTIVE
import scripts.model as model
from scripts.__init__ import _instances, serverIp, BUFFER, VIDEO_EXT, VIDEOBUFFER, FORMAT, START_SENDING, transferringFilesFrames, IMAGE_EXT, DOC_EXT,MUSIC_EXT, filesframe
""""
this file is used to tranfer files
"""
def main():
    _listFiles = model.names
    
    ind = 0
    t = _listFiles.__len__()
    for _file, path in _listFiles.items():
        try:
            soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            soc.connect((serverIp["ip"], 5000))
            # print(soc.recv(1024))
        except Exception:
            from tkinter.messagebox import showerror as error
            error(title="Server error", message="Server not connected check your IP")

        _fileName = path
        fileName = _file
        fileType = getFileType(filename=fileName)
        size = getFileSize(path=path)
        buffer = BUFFER
        if fileType == "video":
            buffer = VIDEOBUFFER
        dictionary = {
            "size":size,
            "type":fileType,
            "fileName":fileName
        }
        dictionary = json.dumps(dictionary)
        soc.send(f"{dictionary}".encode(FORMAT))
        while True:
            data = soc.recv(VIDEOBUFFER).decode(FORMAT)
            if data == START_SENDING:
                print("SENDING file...")
                file_ = open(_fileName, 'rb')
                if file_:
                    s = 0.0
                    _chunck = file_.read(buffer)
                    while _chunck:
                        s += len(_chunck)
                        f = transferringFilesFrames[_file]
                        soc.sendall(_chunck)
                        f.update(val=math.floor((s/1024/1024/size)*100))
                        _chunck = file_.read(buffer)
                else:
                    raise FileNotFoundError().strerror
                file_.close()
                break
        soc.close()
        

        ind+=1
        """updating the progress bar"""
        af = _instances["tablepanel"]
        af.af.update(val=(ind/t)*100)
    
    for val in filesframe.values():
        val.destroy()
    fp = _instances["filepanel"]
    fp.transfer = False
    btn = _instances["transferBtn"]
    btn["state"] = ACTIVE
    filesframe.clear()
    transferringFilesFrames.clear()

def getFileType(filename):
    _ext = filename[-3:] if filename[-4] == '.' else filename[-4:]
    if IMAGE_EXT.__contains__(_ext):
        return "image"
    elif VIDEO_EXT.__contains__(_ext):
        return "video"
    elif DOC_EXT.__contains__(_ext):
        return "doc"
    elif MUSIC_EXT.__contians__(_ext):
        return "audio"

def getFileSize(path):
    file = open(path, 'rb')
    size = len(file.read())
    file.close()
    return (size/1024/1024) # in MB's