import numpy as np
a = np.array([[10,20],[23,12]])
b = np.array([[10,20],[11,12]])

dot = np.dot(a,b)
print(dot)

'''sum of the product of corresponding elements of multi-dimensional arrays.'''
vdot = np.vdot(a,b)
print(vdot)

'''it returns the sum of the product of elements over the last axis.'''
a = np.array([1,2,3,4,5,6])
b = np.array([2,3,11,2,9,2])
inner = np.inner(a,b)
print(inner)

a = np.array([[1,2,3],[4,5,6],[7,8,9]])
b = np.array([[2,3,1],[2,1,2],[5,2,9]])
mul = np.matmul(a,b)
print(mul)