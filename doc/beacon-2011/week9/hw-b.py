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
    for date in fish_d:
        fish_list = list(fish_d[date])
        for i in range(len(fish_list)):
            fish = fish_list[i]
            date_list = dates_d.get(fish, [])
            date_list.append(date)
            dates_d[fish] = date_list

    return dates_d


def get_fishes_by_date(fish_d, date):
    if date in fish_d.keys():
        fishlist = fish_d[date]
    else:
        fishlist = []
    return fishlist


def get_dates_by_fish(dates_d, fish):
    if fish in dates_d.keys():
        dateslist = dates_d[fish]
    else:
        dateslist = []
    return dateslist

def get_fishes_by_datelist(fish_d, date):
    if date in fish_d.keys():
        fishlist = list(fish_d[date])
    else:
        fishlist = []
    return fishlist

def get_dates_by_fishlist(dates_d, fish):
    if fish in dates_d.keys():
        dateslist = list(dates_d[fish])
    else:
        dateslist = []
    return dateslist

fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
dates_d = make_dates_dict(fish_d)

print get_fishes_by_date(fish_d, '1/2')
print get_dates_by_fish(dates_d, 'ahi')
print get_fishes_by_datelist(fish_d, '1/3')
print get_dates_by_fishlist(dates_d, 'cod')
