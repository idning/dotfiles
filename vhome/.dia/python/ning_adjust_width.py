#author: ning
import math, dia

def line_v_sub(data, flags) :
    diagram = dia.active_display().diagram
    for o in data.selected :
        print 'selected: ', o, 
        print o.properties.keys(), o.properties['obj_pos']
        print 'dir(o)', dir(o)
        pos = o.properties["obj_pos"].value
        print dir(pos), pos
        print pos.x, pos.y
        o.move(0.1, 0.1)
        print o.bounding_box
        print dir(o.bounding_box)
        print o.bounding_box.bottom, o.bounding_box.left, o.bounding_box.right , o.bounding_box.top 
        #o.properties['obj_bb']['right'] = o.bounding_box['left'] 
        o.properties['obj_bb'] = ((1,1),(0.473637,4.011794))

        #o.bounding_box
        #pos['x'] -= 1
        #pos.y -= 1

    data.active_layer.update_extents() 
    diagram.add_update_all()
    diagram.update_extents ()
    diagram.flush()
    return data

def width_sub(data, flags) :
    diagram = dia.active_display().diagram
    for o in data.selected :
        o.properties["elem_width"] = o.properties["elem_width"].value - 1
    data.active_layer.update_extents() 
    diagram.add_update_all()
    diagram.update_extents ()
    diagram.flush()
    return data
    
def width_add(data, flags) :
    diagram = dia.active_display().diagram
    for o in data.selected :
        print 'selected: ', o
        o.properties["elem_width"] = o.properties["elem_width"].value + 1
    data.active_layer.update_extents() 
    diagram.add_update_all()
    diagram.update_extents ()
    diagram.flush()
    return data

def eq_warper(use_max, use_min):
    def width_eq(data, flags) :
        diagram = dia.active_display().diagram
        max_w = max([ o.properties["elem_width"].value for o in data.selected ])
        min_w = min([ o.properties["elem_width"].value for o in data.selected ])

        for o in data.selected :
            print 'selected: ', o
            if use_max:
                o.properties["elem_width"] = max_w
            else : 
                o.properties["elem_width"] = min_w

        data.active_layer.update_extents() 
        diagram.add_update_all()
        diagram.update_extents ()
        diagram.flush()
    return width_eq


dia.register_action ("LayoutForcePy1", "Width - ", 
                     "/DisplayMenu/ning/adjust_width_1", 
                     width_sub)
dia.register_action ("LayoutForcePy2", "Width + ", 
                     "/DisplayMenu/ning/adjust_width_2", 
                     width_add)
dia.register_action ("LayoutForcePy3", "Width = max(w)", 
                     "/DisplayMenu/ning/adjust_width_3", 
                     eq_warper(use_max=1, use_min=0))
dia.register_action ("LayoutForcePy4", "Width = min(w)", 
                     "/DisplayMenu/ning/adjust_width_4", 
                     eq_warper(use_max=0, use_min=1))

dia.register_action ("LayoutForcePy5", "Line v ", 
                     "/DisplayMenu/ning/adjust_width_5", 
                     line_v_sub)
