error_has_occurred = False

def fn(beacon_orgs, university):
    global error_has_occurred
    if university not in beacon_orgs:
        error_has_occurred = True
        return None

    return beacon_orgs[university]

####

# define something
beacon_orgs = { 'msu' : 'spartans',
                'austin' : 'longhorns' }

####
# success:

sports = fn(beacon_orgs, 'msu')
if error_has_occurred:
    print 'ERROR, msu is not in beacon orgs'
else:
    print 'MSU sports are', sports

####
# fail:

sports = fn(beacon_orgs, 'idaho')
if error_has_occurred:
    print 'ERROR, idaho is not in beacon orgs'
else:
    print 'idaho sports are', sports

