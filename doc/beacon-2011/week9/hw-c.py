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

def make_dates_dict(fish_d):
  dates_d = {}
  fp=urllib.urlopen(url)
  for row in csv.DictReader(fp):
       
     key = row['fish']
     value = row['date']

     y = dates_d.get(key, [])
     y.append(value)
     dates_d[key] = y
     
  return dates_d

def get_fishes_by_date(fish_d, date):
  fishlist = []
  # write code HERE to fill in fishlist
  for date in fish_d:
      fishlist=(set(fish_d[date]))
   
  return fishlist

def get_dates_by_fish(dates_d, fish):
  dateslist = []
  for fish in dates_d:
      dateslist=(set(dates_d[fish]))

  return dateslist

def get_fishes_by_dateslist(fish_d, dateslist):
  fishdateslist=[]
  for fishes in fish_d:
    fishdateslist=(set(fish_d[fishes]))

  return fishdateslist

def get_dates_by_fishlist(dates_d, fishlist):
  datesfishlist=[]
  for listdates in dates_d:
    datesfishlist=(set(dates_d[listdates]))

  return datesfishlist

url='https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv'
fish_d = load_csv(url)
dates_d = make_dates_dict(fish_d)
dateslist = get_dates_by_fish(dates_d, 'plaice')
fishlist= get_fishes_by_date(fish_d, '1/1')

print 'get_fishes_by_date', get_fishes_by_date(fish_d, '1/1')
print 'get_dates_by_fish', get_dates_by_fish(dates_d, 'plaice')
 
