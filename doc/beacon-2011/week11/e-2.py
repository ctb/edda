# define something
beacon_orgs = { 'msu' : 'spartans',
                'austin' : 'longhorns' }

####
# success:

try:
    sports = beacon_orgs['msu']
    print 'MSU sports are', sports
except KeyError:
    print 'ERROR, msu is not in beacon orgs'

####
# fail:

try:
    sports = beacon_orgs['idaho']
    print 'idaho sports are', sports
except KeyError:
    print 'ERROR, idaho is not in beacon orgs'
