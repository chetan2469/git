import numpy as np

a = 5
b = 7


print("Binary representation:",np.binary_repr(a))
print("Binary representation:",np.binary_repr(b))

print("Bitwise-and  : ", np.bitwise_and(a, b))
print("Bitwise-and  : ", np.bitwise_or(a, b))
print("Bitwise-and  : ", np.bitwise_xor(a, b))