def fn2(i):
    if i % 2 == 0:
        print 'fiz'
        return True
    else:
        return False

def fn3():
    for x in range(10):
        if not fn2(x):
            break

    return x

x = fn3()
print 'x is', x
