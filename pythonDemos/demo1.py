class A:
	def disp(self):
		print('default')

	def disp(self,y):
		print('para')	


a = A()
a.disp(1,2)