def fn(x, item):
    # put code in here to satisfy tests below
    pass

###

# test code

# test 1
somelist = []
fn(somelist, "tuna")

assert len(somelist) == 1
assert "tuna" in somelist
