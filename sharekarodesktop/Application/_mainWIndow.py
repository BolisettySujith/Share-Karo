# Main window for our interface
import tkinter as tk
from tkinter import filedialog as fileSelector
from tkinter import simpledialog
from tkinter import messagebox
import scripts.model as model
from filepanel import Panel as file_panel
from tablepanel import Panel as table_panel, ServerStatus as server_status
import scripts.__init__ as init

class MainApp(tk.Tk):
	"""
		MainApp inherits the tk class hence this will act as root window in our application
		>>> self._config() // contains the root window configurations
		>>> self.render() // this will render all the frames on our root window
	"""
	def __init__(self):
		super().__init__()
		self._config()
		self.render()
	
	def _config(self):
		self.config(menu=self.__renderMenu())
		self.geometry("1400x850+200+100")

		self.configure(bg="white")
		self.bind('<Control-o>', self._filesSelected)
	
	def __renderMenu(self):

		def getServer():
			init.serverIp["ip"] = simpledialog.askstring(title="Add server", prompt="Add servers IP")
			self.serverStatus.update(color="green")
		
		# def aboutus():
		# 	messagebox.showinfo(title="About us", message="This project is developed by \n\tMuhammad Muddassar\n\nOccupation: Student\nEmail: muddassar087@gmail.com\n\nWhat is it about?\n\tThis project will be used"+
		# 	" to transfer files from laptop to mobile using core network libraries. Mobile hotspot should be connected and the IP should be known for the mobile in order to transfer data mobile will act as a server in our case.")

		menubar = tk.Menu(self, background="#00D1D1", font=("Roboto", 12))
		filemenu = tk.Menu(menubar, tearoff=0,)
		filemenu.add_command(label="Open Files",command=self._filesSelected)
		
		servermenu = tk.Menu(menubar, tearoff=False)
		servermenu.add_command(label='Add server', command=getServer)
		# aboutusmenu = tk.Menu(master=menubar, tearoff=0)
		# aboutusmenu.add_command(label="About us", command=aboutus)

		menubar.add_cascade(label='File',menu=filemenu)
		menubar.add_cascade(label='Server',menu=servermenu)
		# menubar.add_cascade(label='Renderer About us',menu=aboutusmenu)
		return menubar

	def _filesSelected(self, event=None):
		__names = fileSelector.askopenfilenames()
		model.paths = __names
		model.names = model.getFileNames()
		self.filepanel.buildList(list(model.names.keys()))

	def render(self):
		self.filepanel = file_panel(self)
		self.tablepanel = table_panel(self)
		self.serverStatus = server_status(self)
		init._instances["serverStatus"] = self.serverStatus
		init._instances["filepnanel"] = self.filepanel
		init._instances["tablepanel"] = self.tablepanel
		
if __name__ == "__main__":
	window = MainApp()
	init._instances["root"] = window

	window.mainloop()