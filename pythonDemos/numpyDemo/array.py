import numpy as np
arr = np.array([[1, 2, 3, 4], [4, 5, 6, 7], [9, 10, 11, 23]])

print(arr)

print(arr.ndim)

print("Each item is of the type",arr.dtype)

print("Each item is of the type",arr.size)

print("Shape:",arr.shape)

a=arr.reshape(4,3)
print(a)

print('____',arr[1,3])




