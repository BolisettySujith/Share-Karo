def getFileNames():
    names = {}
    for i in paths:
        if i.find("//"):
            names[i.split("/")[-1]] = i
    return names
    
def clear(name):
    names.pop(name)

paths = []
names = {}
