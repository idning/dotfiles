# Copyright 2010 Carlo Calderoni
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import pygtk, gtk, gtk.glade, gobject
import dia, os, sys
import subprocess
import string,cgi, urlparse, os
from os import curdir, sep
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

import threading
import time

# in python 3: configparser
import ConfigParser



# needed for threading
gtk.gdk.threads_init()

class DiaProxyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            self.ppath = urlparse.urlparse(self.path)
            
            # list open files
            if self.ppath.path == "" or self.ppath.path == "/":
                self.ListOpenFiles()
            #get xml
            if self.ppath.path.startswith("/xml"):
                self.GetXml()
            #get png
            if self.ppath.path.startswith("/png"):
                self.GetPng()
                
            #force save
            return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)

    def ListOpenFiles(self):
        self.send_response(200)
        self.send_header('Content-type',	'text/html')
        self.end_headers()
        #self.wfile.write("path "+self.ppath.path+" query "+self.ppath.query)
              
        # list open files
        for d in dia.diagrams():
            if not os.path.exists(d.filename):
                continue
            
            # show local modify
            out = "M "
            if (d.modified == 0):
                out = "= "
        
            # show name 
            out += d.filename 
            # show last modify
            out += " " + time.strftime("%Y-%m-%d %I:%M:%S %p",time.localtime(os.path.getmtime(d.filename)))
            # link for download xml 
            out += " <a href='/xml" + d.filename + "'>XML</a>"
            # link for download visible image
            out += " <a href='/png" + d.filename + "'>PNG</a>" 
        
            #show size FIXME
            #out += os.path.getsize(d.filename) + " "

            self.wfile.write(out + "<br/>")


    def GetXml(self):
        fpath = self.ppath.path[len("/xml"):]

        self.send_response(200)
        self.send_header('Content-type',	'text/xml')
        self.end_headers()
        f = open(fpath)
        self.wfile.write(f.read())
        f.close()

    def GetPng(self):
        fpath = self.ppath.path[len("/png"):]

        self.send_response(200)
        self.send_header('Content-type',	'image/png')
        self.end_headers()
        command = "dia -t png --export=" + fpath + ".png " + fpath
        os.system(command)
        f = open(fpath+".png")
        self.wfile.write(f.read())
        f.close()



class DiaProxyThread(threading.Thread):
    def __init__(self, proxy_port):
        self.stdout = None
        self.stderr = None
        self.proxyPort = proxy_port
        if proxy_port > 0:
            threading.Thread.__init__(self)

    def run(self):
        server = HTTPServer(('', self.proxyPort), DiaProxyHandler)
        server.serve_forever()




class ScriptLauncher:
    def __init__(self):
        scriptLauncherDataPath = os.path.split(__file__)[0] + "/scriptlauncher/"
        # load gui
        self.wT = gtk.glade.XML(scriptLauncherDataPath + "scriptlauncher.glade")
        
        # load config
        self.configFile = scriptLauncherDataPath + "scriptlauncher.cfg"
        self.config = ConfigParser.ConfigParser()
        
        proxyPort = 0    # default proxy port
        try: 
            self.config.read(self.configFile)
            
            # set additional paths from config
            if self.config.get("ScriptLauncher", "paths"):
               os.environ["PATH"] += ":" + self.config.get("ScriptLauncher", "paths") 
            
            # get proxy port
            if self.config.get("ScriptLauncher", "proxy_port"):
               proxyPort = int(self.config.get("ScriptLauncher", "proxy_port"))
            
        except ConfigParser.ParsingError:
            dia.message(2, "Dia Script Launcher config file parse error")
        except (ConfigParser.NoSectionError, ConfigParser.NoOptionError):
            pass

        # init current diagram informations
        self.UpdateCurrentDiagramAndDir()
    
        # import proxy python and start proxy thread
        sys.path.append(scriptLauncherDataPath)
        self.proxy = DiaProxyThread(proxyPort)
        if proxyPort > 0:
            self.proxy.start()

        # init and start gui
        self.InitGui()

    def InitGui(self):
        """ prepare gui for initial visualization """
        # gui events and handlers
        dic = { 
                "on_scriptWindow_destroy"    : gtk.main_quit,
                "on_bLaunch_clicked"         : self.LaunchScript,
                "on_comboScript_changed"     : self.UpdatePreviewCommand,
                "on_bEditScriptList_clicked" : self.EditConfig,
                "onMiniPromptActivate"       : self.OnMiniPrompt} 
        self.wT.signal_autoconnect(dic)

        # init script selector
        combo = self.wT.get_widget("comboScript")
        model = gtk.ListStore(str)
        cell = gtk.CellRendererText()
        combo.pack_start(cell, True)
        combo.add_attribute(cell, 'text', 0) 
        # load scriptslist from config 
        try:
            for s in self.config.items("Scripts"):
                model.append([s[0]])
            if len(self.config.items("Scripts")) > 0:
                combo.set_active(0)
        except ConfigParser.NoSectionError:
            pass
        combo.set_model(model)

        # show proxy port or status
        proxyPort = "offline"
        if self.proxy.proxyPort > 0:
            proxyPort = str(self.proxy.proxyPort)
        self.wT.get_widget("labelProxy").set_label("Proxy: " + proxyPort)
        # update content of gui diagram path, 
        # execution dir, selected layer and objects
        self.RefreshCurrentDiagramAndDir()
        # updates currently selected script source
        # visualization in gui
        self.UpdatePreviewCommand(None)
        self.wT.get_widget("scriptWindow").show()
        # every 2 seconds, check and refrest source diagram data
        # if autoupdate flag is active
        gobject.timeout_add(2000, self.AutoUpdate)

        gtk.main()

    def UpdateCurrentDiagramAndDir(self):
        # set current diagram infos
        self.diagram = dia.active_display().diagram
        self.diagramPath = str(self.diagram)
        self.diagramDir = os.path.split(self.diagramPath)[0]
        self.diagramParentDir = os.path.split(self.diagramDir)[0]

        # set initial base execution dir to parent of current diagram's dir
        self.baseDir = self.diagramParentDir

        # retrieve selected layer num and name
        self.selectedLayerNum = 0
        i = 0
        self.previousLayersObjects = 0
        self.selectedId = ""
        for l in self.diagram.data.layers:
            if l == self.diagram.data.active_layer:
                self.selectedLayerNum = i

                # build selected id list string
                for o in self.diagram.data.selected:
                    self.selectedId += "O" + str(self.diagram.data.active_layer.object_index(o) + \
                                                  self.previousLayersObjects) + " "
                break
            else:
                i += 1
                self.previousLayersObjects += len(l.objects)
        self.selectedLayerName = self.diagram.data.layers[self.selectedLayerNum].name

    def AutoUpdate(self):
        # if auto update flag control is active
        # reobtain diagram values and refresh gui
        if self.wT.get_widget("flagAutoupdate").get_active():
            self.UpdateCurrentDiagramAndDir()
            self.RefreshCurrentDiagramAndDir()
        # keep alive timeout
        return True

    def RunProxy(self):
        if not self.wT.get_widget("checkRunProxy").get_active():
            return True

        # keep alive timeout
        return True


    def RefreshCurrentDiagramAndDir(self):
        # gui diagram path, execution dir, selected layer
        self.wT.get_widget("diagramName").set_text(self.diagramPath)
        self.wT.get_widget("baseDirChooser").set_current_folder(self.baseDir)
        self.wT.get_widget("layerNum").set_text(str(self.selectedLayerNum))
        self.wT.get_widget("layerName").set_text(self.selectedLayerName)
        self.wT.get_widget("selectedId").set_text(self.selectedId)


    def GetCommand(self):
        selected = self.wT.get_widget("comboScript").get_active()
        if selected >= 0  and len(self.config.items("Scripts")) > 0:
            return selected;   
        return -1

    def GetAppendedParams(self):
        return " " + self.wT.get_widget("appendParams").get_text().strip()

    def GetPrependedParams(self):
        return self.wT.get_widget("prependParams").get_text().strip()

    # return current selected script template, 
    # with appendend and prepended parameters
    def GetShellTemplate(self):
        selected = self.GetCommand()
        try:
            if selected >= 0:
                return self.GetPrependedParams() + \
                       self.config.items("Scripts")[selected][1] + \
                       self.GetAppendedParams()
        except ConfigParser.NoSectionError:
            pass
        return ""

    ##
    ## event handlers
    ##

    # updates current selected script code visualization
    def UpdatePreviewCommand(self, widget):
        self.wT.get_widget("previewCommand").set_text(self.GetShellTemplate())

    # launch editor with config file
    def EditConfig(self, widget):
        if not self.config.has_section("ScriptLauncher") or \
           not self.config.has_option("ScriptLauncher", "editor"):
            dia.message(2, "Editor not configured.\n" + \
                            "Set it or edit script list in " + self.configFile)
            return
        subprocess.Popen(self.config.get("ScriptLauncher", "editor") + " " + self.configFile, \
                         shell=True, \
                         stdout=subprocess.PIPE, \
                         stderr=subprocess.PIPE)
        self.wT.get_widget("scriptWindow").destroy()
        
    # Event handler click launch button.
    #substitute template vars in selected command
    # and executes it
    def LaunchScript(self, widget):
        # check for save modified diagram
        if self.diagram.modified == 1:
            md = gtk.MessageDialog(message_format="Diagram not saved. Save it before script launch?", \
                                   type=gtk.MESSAGE_QUESTION, \
                                   buttons=gtk.BUTTONS_YES_NO)
            c = md.run()
            md.destroy()
            if c == gtk.RESPONSE_YES:
                self.diagram.save()

        # get selected execution dir
        self.baseDir = str(self.wT.get_widget("baseDirChooser").get_filename())
        
        # build command string
        # substitute "%xyz%" template strings
        shellCmd = self.GetShellTemplate()
        shellCmd = shellCmd.replace("%diagramPath%"     , self.diagramPath).strip()
        shellCmd = shellCmd.replace("%diagramDir%"      , self.diagramDir).strip()
        shellCmd = shellCmd.replace("%diagramParentDir%", self.diagramParentDir).strip()
        shellCmd = shellCmd.replace("%layerName%"       , self.selectedLayerName).strip()
        shellCmd = shellCmd.replace("%layerNum%"        , str(self.selectedLayerNum)).strip()

        # execute command in shell subprocess
        proc = subprocess.Popen(shellCmd, cwd=self.baseDir, shell=True, \
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, \
                                env=os.environ)
        
        # print output
        # TODO update script output in real time
        executionLog = self.wT.get_widget("executionLog")
        output = self.baseDir + ": " + shellCmd + "\n\n" + proc.communicate()[0]
        executionLog.get_buffer().set_text(output)

        #set focus to output window
        executionLog.grab_focus()

    # Event handler for mini prompt return pressed.
    # executes command prompt entered
    def OnMiniPrompt(self, widget):
        # check for save modified diagram
        if self.diagram.modified == 1:
            md = gtk.MessageDialog(message_format="Diagram not saved. Save it before script launch?", \
                                   type=gtk.MESSAGE_QUESTION, \
                                   
                                   buttons=gtk.BUTTONS_YES_NO)
            c = md.run()
            md.destroy()
            if c == gtk.RESPONSE_YES:
                self.diagram.save()

        # get selected execution dir
        self.baseDir = str(self.wT.get_widget("baseDirChooser").get_filename())
       
        shellCmd = str(self.wT.get_widget("miniPrompt").get_text())
 
        # execute command in shell subprocess
        proc = subprocess.Popen(shellCmd, cwd=self.baseDir, shell=True, \
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, \
                                env=os.environ)
        
        # print output
        # TODO update script output in real time
        executionLog = self.wT.get_widget("executionLog")
        output = self.baseDir + ": " + shellCmd + "\n\n" + proc.communicate()[0]
        executionLog.get_buffer().set_text(output)

        #set focus to output window
        executionLog.grab_focus()
        # reset mini prompt entry
        self.wT.get_widget("miniPrompt").set_text('')

def launch_scriptlauncher(data, flags):
    L = ScriptLauncher()

dia.register_action("DialogsScriptlauncher", "Script launcher",
                    "/DisplayMenu/Dialogs/DialogsExtensionStart",
                    launch_scriptlauncher)


