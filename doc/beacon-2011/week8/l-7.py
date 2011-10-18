x = [5, 6]
y = [7, 8]

x.extend(y)
y.extend(x)

for item in y:
    print item
