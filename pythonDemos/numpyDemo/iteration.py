import numpy as np
a = np.array([[1,2,3,4],[1,4,1,6],[9,6,4,3]])
print(a);

for x in np.nditer(a):
    print(x,end=' ')  