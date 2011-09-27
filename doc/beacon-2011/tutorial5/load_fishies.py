import csv, urllib

def load_csv(url):
    datadict = {}
    fp = urllib.urlopen(url)

    for row in csv.DictReader(fp):
        key = row['date']
        datadict[key] = row

    return datadict

def get_fish_by_day(datadict, date):
    if date in datadict:
        fish = datadict[date]
    else:
        fish = []

    return fish

url = 'https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv'

# load in the CSV file
fish_d = load_csv(url)

# try running the 'get_fish_by_day' function.
print get_fish_by_day(fish_d, '6/1')


