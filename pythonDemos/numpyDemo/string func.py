import numpy as np


print(np.char.add(['welcome','Hey '], [' to Chedo', 'python'] ))

print(np.char.multiply("Hi ",3))


print(np.char.center("chedo", 20, '*'))

print(np.char.capitalize("welcome to chedo"))

print(np.char.title("welcome to chedo"))

print(np.char.lower("welcome to chedo"))

print(np.char.upper("welcome to chedo"))

print(np.char.split("welcome to chedo"),sep=' ')

str = "     Hello World     "
print(np.char.strip(str))

print(np.char.join(':','HM'))

print(np.char.replace(str, "o","p"))


s = 'ab12cd'
enstr = np.char.encode(s, 'cp500')
dstr =np.char.decode(enstr, 'cp500')

print('Encode of s',enstr)
print('Decode of s',dstr)
