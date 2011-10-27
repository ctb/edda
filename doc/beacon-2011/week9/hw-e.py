import csv, urllib
url = 'https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv'

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

fish_dict = load_csv(url)

def make_dates_dict(fish_d):
  dates_d = {}
  
  for dates in fish_d:
      fish_in_a_day = set(fish_d[dates])
      for fish in fish_in_a_day:
          dates_list = dates_d.get(fish, [])
          dates_list.append(dates)
          dates_d[fish] = dates_list

  return dates_d

new_dict = make_dates_dict(fish_dict)
print new_dict, len(new_dict)

def get_fishes_by_date(fish_d, date):
  fish_list = fish_d.get(date, [])

  return fish_list
print get_fishes_by_date(fish_dict, '1/1')

def get_dates_by_fish(dates_d, fish):
  dateslist = []
  dates_list = dates_d.get(fish, [])

  return dates_list

# the following function takes a dictionary with keys = date, values = fish
def get_fishes_by_datelist(fish_d, datelist):
  res_dict = {}
  for dates in datelist:
    res_dict[dates] = fish_d.get(dates, [])

  return res_dict

datelist = ['1/1', '1/2', '1/3']

print get_fishes_by_datelist(fish_dict, datelist)
    
# the following function takes a dictionary with keys = fish, values = dates
def get_dates_by_fishlist(dates_d, fishlist):
  res_dict = {}
  for fish in fishlist:
    res_dict[fish] = dates_d.get(fish, [])

  return res_dict

fishlist = ['salmon', 'ahi']

print get_dates_by_fishlist(new_dict, fishlist)

fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
dates_d = make_dates_dict(fish_d)

print get_fishes_by_date(fish_dict, '1/1')
print get_dates_by_fish(new_dict, 'plaice')
