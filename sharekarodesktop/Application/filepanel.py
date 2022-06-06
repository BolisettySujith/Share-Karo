import tkinter as tk
from tkinter.constants import *
from tkinter.ttk import Style
import scripts.model as model
from scripts.service import main as smain
from threading import Thread
from scripts.__init__ import _instances, serverIp, filesframe

class Panel(tk.Frame):
	"""
		_fileNameWrapper is a frame that hold incoming file name untill furthur actions
		
		@master Panel frame
		@outer outer class instance

		class Structure
		contructor inherit Frame
		------- config
		-------------- frame settings
		------- build
		-------------- frame widgets
		------- pack
		-------------- packing frame
	"""
	class _FilesNameWrappar(tk.Frame):
		def __init__(self, master=None, outer=None,fileName=str) -> None:
			super().__init__(master)
			self.outer = outer
			self.master = master
			self.name = fileName
			self._config()
			self.build()
			self.pack(side=TOP,fill=BOTH, anchor=NE, ipadx=4, ipady=4, padx=5, pady=3)


		def _config(self):
			self["relief"] = SUNKEN
			self["borderwidth"] = 1
		
		def clearSelection(self, name):
			"""
				to clear the file names the frames contain updated file names are rerenderd each time
			"""
			model.clear(name)
			# destroy each widget and rebuild each time cancel is pressed
			for w in self.master.winfo_children():
				if not (w.winfo_name() == "heading" or w.winfo_name() == "!actionframe"):
					w.destroy()
			self.outer.buildList(model.names.keys())
			self.outer.ac.build()

		def build(self):
			tk.Label(self, text=self.name, font=("Roboto", 10)).pack(side=LEFT)
			tk.Button(self, text="clear", fg="red", relief=RAISED, command=lambda : self.clearSelection(self.name) if not self.outer.transfer else None).pack(side=RIGHT)
			
	"""ActionFrame is a frame that has a button and info about the files parent panel"""
	class ActionFrame(tk.Frame):
		def __init__(self, master=None, outer=None, tablepane=None):
			super().__init__(master)
			self.tp = tablepane
			self.outer = outer
			self._config()
			self.configure(bg="white")
			self.build()
			self.pack(side=BOTTOM, fill=X, expand=0, ipadx=10, ipady=10)
		
		def _config(self):
			self["borderwidth"] = 1
		
		def transfer(self):
			"""
				A separate thread will be generated to handle socket connection in this way our GUI will
				not be effected.
				>>> a = Thread(*args)
			"""
			if model.names.__len__() > 0 and serverIp.__len__() is not 0:
				self.outer.transfer = True
				self.btn.config(state=DISABLED)
				panel = _instances["tablepanel"]
				panel.buildList(names=list(model.names.keys()))

				a = Thread(target=smain)
				a.start()
			
			else:
				from tkinter.messagebox import showerror as error
				error(title="Missing Server IP and files" , message="Please Add files and server ip to transfer data")

		def build(self):
			self.btn = tk.Button(self, state=ACTIVE,fg='black', name="transfer_btn", text="Start Sending",font=("Roboto", 13),relief=GROOVE,height=1,command=self.transfer)
			self.btn.pack(side=RIGHT, padx=20, fill=X)
			_instances["transferBtn"] = self.btn
			tk.Label(self,bg="white",fg='black', name="file_length", text=f"{model.names.__len__()} files selected", font=("Roboto", 13)).pack(side=RIGHT, padx=30)

	def __init__(self, master=None, tablepane=None):
		super().__init__(master)
		self.tablePane = tablepane
		self.transfer = False
		self.configure(bg="#50A7AB")

		self.style = Style()
		self.style.theme_use("default")
		
		self._config()
		self.build()
		self.pack(fill=tk.BOTH, side=tk.LEFT, expand=0)

	def _config(self):
		self.configure(
			height=500,
			border=3,
			relief=GROOVE,
		)
		
	def build(self):
		self.panel = tk.Frame(master=self, relief=GROOVE, border=1, borderwidth=3, bg="white")
		self.panel.pack(side=LEFT,pady=40,padx=10 ,expand=0,fill=X, anchor=NW)
		
		tk.Label(master=self.panel,bg="white",fg='black', name="heading",text="Selected Files",font=("Roboto", 15)).pack(side=TOP, anchor=NW, padx = 20,pady=10, expand=1)
		self.ac = self.ActionFrame(master=self.panel, outer=self)
		
	def buildList(self, names):
		self.ac.build()
		for name in names:
			filesframe[name] = self._FilesNameWrappar(master=self.panel, outer=self,fileName=name)
