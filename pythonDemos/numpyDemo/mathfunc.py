import numpy as np

arr = np.array([0, 10, 70, 60, 20])

print(np.sin(arr * np.pi/180))

print(np.cos(arr * np.pi/180))

print(np.tan(arr * np.pi/180))


'''________________________________'''

arr = np.array([12.202, 90.23120, 123.920, 23.202])

print("Around Of",np.around(arr, 2))
print("Around Of",np.around(arr, -1))
print("Floor Of",np.floor(arr))
print("Ceil Of",np.ceil(arr))