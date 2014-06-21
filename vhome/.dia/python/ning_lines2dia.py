#author: ning
import re, string, sys

def ImportFile (sFile, diagramData) :
    """ read the dot file and create diagram objects """
    layer = diagramData.active_layer # can do better, e.g. layer per graph
    nodeType = dia.get_object_type('Flowchart - Box')

    x = 0 
    y = 0
    w = 20
    h = 0.2

    lines = file(sFile).readlines()
    lines = [l.strip() for l in lines if l.strip()]
    max_len = max([len(l) for l in lines])
    box_width = max_len / 2.2
    #w = max_len / 2.2

    for line in lines:
        line = line.strip() 
        print line
        y = y+1.5
        obj, h1, h2 = nodeType.create(x-w/2, y-h/2) # Dot pos is center, Dia (usually) uses top/left
        obj.move_handle(h2, (x+w/2, y+h/2), 0, 0) # resize the object
        obj.properties["text"] = line
        layer.add_object(obj)

        obj.properties["elem_width"] = box_width
        obj.properties["padding"] = 0.10
        obj.properties["elem_height"] = 1.00


# run as a Dia plug-in
import dia
dia.register_import ("lines of names", "txt", ImportFile)
