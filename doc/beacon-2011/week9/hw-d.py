import csv, urllib

def load_csv(url):
  d = {}
  fp = urllib.urlopen(url)
  for row in csv.DictReader(fp):
     key = row['date']
     value = row['fish']

     x = d.get(key, [])
     x.append(value)
     d[key] = x

  return d

fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')

def make_dates_dict(fish_d):
  dates_d = {}
  fp = urllib.urlopen('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
  for row in csv.DictReader(fp):
    key = row['fish']
    value = row['date']
    x = dates_d.get(key, [])
    x.append(value)
    dates_d[key] = x
  return dates_d

def get_fishes_by_date(date):
  fishlist = []
  for date in fish_d:
    fishlist.append(fish)
  return fishlist

def get_dates_by_fish(dates_d, fish):
  dateslist = []
  for fish in dates_d:
    dateslist.append(date)
  return dateslist

# this code is outside the functions and USES the functions to
# load data and ask questions of the data.

fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
dates_d = make_dates_dict(fish_d)

print get_fishes_by_date('1/1')
print get_dates_by_fish('plaice')
