import tkinter as tk
from tkinter import font, wantobjects
import tkinter.ttk as ttk
from tkinter.constants import *
from scripts.__init__ import transferringFilesFrames, serverIp

class Panel(tk.Frame):

	class TableHeaderFrame(tk.Frame):
		def __init__(self, master=None):
			super().__init__(master)
			self._config()
			self.build()
			self.configure(bg="white")
			self.pack(side=TOP, expand=0, fill=X, padx=20)
		
		def _config(self):
			self['border'] = 2
			self["relief"] = GROOVE

		def build(self):

			tk.Label(master=self,fg='black',bg="white", text="Files", font=("robot", 12)).pack(side=LEFT,  anchor=NW,expand=0 , padx=20)
			tk.Label(master=self,fg='black',bg="white", text="Complete", font=("robot", 12)).pack(side=RIGHT ,anchor=NE,expand=0 , padx=20)

	class _FilesNameWrappar(tk.Frame):
		def __init__(self, master=None, fileName=str) -> None:
			super().__init__(master)
			self.name = fileName
			self.complete = "waiting"
			self._config()
			self.configure(bg="white")
			self.build()
			self.pack(fill=X, side=TOP, anchor=N, ipadx=4, ipady=4, padx=20, pady=3)
		
		def _config(self):
			pass
			
		def update(self, val):
			self.complete["text"] = f"{val}%"
		
		def build(self):
			tk.Label(self, text=self.name,fg='black',bg="white", font=("Roboto", 11)).pack(side=LEFT, padx=20)
			self.complete = tk.Label(self,fg='black',bg="white", text="waiting",font=("Roboto", 11))
			self.complete.pack(side=RIGHT, padx=30)
		
		def delete(self):
			self.destroy()
			
	class ActionFrame(tk.Frame):
		def __init__(self, master=None):
			super().__init__(master)
			self._config()
			self.build()
			self.configure(bg="white")
			self.pack(side=BOTTOM, fill=X, expand=0, ipadx=10, ipady=10, pady=10, padx=20)
		
		def _config(self):
			self["borderwidth"] = 1
			self["relief"] = GROOVE
		
		def hide(self):
			self.pack_forget()
		
		def show(self):
			self.pack(side=BOTTOM, fill=X, expand=0, ipadx=10, ipady=10, pady=10, padx=20)

		def update(self, val):
			self.pb["value"] = val

		def build(self):
			# tk.Label(self, text="1 of 18 send", font=("Roboto", 13)).pack(side=LEFT, padx=30)
			self.pb = ttk.Progressbar(self,value=0)
			self.pb.pack(side=LEFT,expand=1, fill=X, padx=10)
		
	def __init__(self, master=None):
		super().__init__(master)
		self._config()
		self.build()
		self.configure(bg="white")
		self.pack(fill=tk.BOTH, side=tk.LEFT, expand=True, anchor=NW)

	def _config(self):
		self['width'] = 876

	def build(self):
		self.panel = tk.Frame(master=self,bg="white" ,width=self["width"], height=self["height"], border=2, relief=GROOVE)
		self.panel.pack(side=LEFT , pady=60, expand=1, fill=X, anchor=NW, padx=10)	
		tk.Label(master=self.panel,fg='black',bg="white", text="Transferring Files", font=("roboto", 14)).pack(padx=20, pady=10, anchor=NW)

		self.TableHeaderFrame(master=self.panel)	
		self.af = self.ActionFrame(master=self.panel)
		self.initS = self._FilesNameWrappar(self.panel, "No files to display here!")
		self.af.hide()

	def buildList(self, names):
		self.initS.delete()
		self.af.show()
		if transferringFilesFrames.__len__() != 0:
			for val in transferringFilesFrames.values(): val.destroy()
			
		for i in names:
			transferringFilesFrames[i] = self._FilesNameWrappar(self.panel, i)

class ServerStatus(tk.Frame):
	def __init__(self, master=None):
		super().__init__(master)
		self.build()
		self.configure(bg="white")
		self.pack(fill=tk.BOTH, side=tk.LEFT, expand=0)
	
	def update(self, color="red"):
		self.f["bg"] = color

	def build(self, color="red"):
		tk.Label(master=self ,background='white',foreground="black",text="Server Status", font=("Roboto", 12)).pack(expand=1 ,side=LEFT, anchor=N)
		self.f = tk.Frame(self, width=10, bg=color, height=10)
		self.f.pack(side=LEFT, anchor=NW)


