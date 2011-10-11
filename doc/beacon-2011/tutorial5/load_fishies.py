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

# this code is outside the functions and USES the functions to
# load data and ask questions of the data.

fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
dates_d = make_dates_dict(fish_d)

print get_fishes_by_date(fish_d, '1/1')
print get_dates_by_fish(dates_d, 'plaice')
