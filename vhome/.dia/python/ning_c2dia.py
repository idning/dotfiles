#!/usr/bin/python
#coding:utf-8
#author : ning
import re, string, sys
#from pycparser import c_parser, c_ast, parse_file
def parse_method(content):
    print '[DEBUG] parse_method:', content
    if not content: return
    try:
        t = re.split(r'\(', content)[0]
        [typo, name] = t.split()
        return [typo, name]
    except :
        return ['----', '------']

def parse_field(content):
    if not content: return
    print '[DEBUG] parse_field :', content

    #[typo, name] = content.rsplit(' ', 1) #TODO: can be better ??
    name = re.split('[ \*]', content)[-1] #空格或者*
    typo = content[:len(content)-len(name)]

    if name.find('[') > 0 :         # unsigned arr[], 这种格式的.
        [a, b] = name.split('[')
        typo = typo.strip() + '[' + b
        name = a.strip()
    elif name.find(':') > 0 :         # unsigned flag:1, 这种格式的.
        [a, b] = name.split(':')
        typo = typo.strip() + ':' + b
        name = a.strip()
    typo = re.sub(' +', ' ', typo)
    return [typo, name]

def parse_struct(content):
    print '[DEBUG] parse_struct : ', content
    m = re.search(r'(struct|class) (.*?){(.*?)}', content, re.DOTALL)##
    if not m : return
    name = m.group(2)
    body = m.group(3)
    #print name , body
    fields = []
    methods = []
    for line in body.split(';'):
        line = re.sub(r'//.*', '', line) #remove comment
        line = line.strip()
        if line.find('(') > 0 and line[-1] == ')':
            m = parse_method(line)
            methods.append(m)
        else:
            f = parse_field(line)
            if (f): fields.append(f)
    return [name, fields, methods]


def parse_file(filepath):
    print '[INFO] parse_file : ', filepath
    file_content = file(filepath).read()
    p = re.compile(r'/\*.*?\*/', re.DOTALL)
    file_content = re.sub(p, '', file_content) #remove comment
    #print file_content
    rst = re.findall(r'((struct|class) (.*?){(.*?)})', file_content, re.DOTALL)##
    structs = []
    for body in rst:
        #print body
        structs.append(parse_struct(body[0]))
    return structs

if __name__ == '__main__':
    file_path = sys.argv[1]

    structs = parse_file(file_path)
    for [name, fields, methods] in structs:
        print name
        for f in fields:
            print f
        for m in fields:
            print m
    sys.exit()

import dia
def ImportFile (filename, diagramData) :
    """ read the dot file and create diagram objects """
    layer = diagramData.active_layer # can do better, e.g. layer per graph
    nodeType = dia.get_object_type('Flowchart - Box')

    x = 0
    structs = parse_file(filename)
    oType = dia.get_object_type ("UML - Class")
    for [name, fields, methods] in structs:
        x += 10
        obj, h1, h2 = oType.create (x,0) # p.x, p.y
        obj.properties["name"] = name

        dia_fields = []
        dia_methods = []
        for f in fields:
            #print f
            dia_fields.append((f[1],f[0],'','doc',0,0,0))
        for m in methods:
            #print m
            dia_methods.append((m[1],m[0],'doc','',0,0,0,0,()))
        obj.properties["operations"] = dia_methods
        obj.properties["attributes"] = dia_fields
        layer.add_object(obj)
    if diagramData :
        diagramData.update_extents()
        #diagramData.flush()
    # work with bindings test
    #return data

# run as a Dia plug-in
dia.register_import ("c file to be convert", "c", ImportFile)
dia.register_import ("c header file to be convert", "h", ImportFile)
