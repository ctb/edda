def fn(x, item):
    # put code in here to satisfy tests below
    pass

###

# test code

# test 1
somelist = []
fn(somelist, "tuna")

assert len(somelist) == 1
assert "tuna" in somelist, somelist

# test 2
somelist = []
fn(somelist, "tuna")
fn(somelist, "ahi")

assert "tuna" in somelist
assert "ahi" in somelist
assert len(somelist) == 2, somelist

# test 3
somelist = []
fn(somelist, "tuna")
fn(somelist, "ahi")
fn(somelist, "ahi")

assert "tuna" in somelist
assert "ahi" in somelist
assert len(somelist) == 2, somelist
