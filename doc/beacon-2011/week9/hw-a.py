import csv, urllib

def load_csv(url):
    d = {}

    #short list
    #fp = urllib.urlopen('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies-short.csv')
    
    #long list
    fp = urllib.urlopen('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')

    for row in csv.DictReader(fp):
        key = row['date']
        value = row['fish']

        x = d.get(key, [])
        x.append(value)
        d[key] = x

    return d

def make_dates_dict(fish_d):
    dates_d = {}
    list_of_fish = []
    list_of_fish_w_dates = []
    

    for day in fish_d:
        row = fish_d[day]

        for fish_name in row:
            new_key = fish_name
            new_value = day

            list_of_fish.append(new_key)

            list_of_fish_w_dates = dates_d.get(new_key, [])
            list_of_fish_w_dates.append(new_value)
            dates_d[new_key] = list_of_fish_w_dates
          
    return dates_d

#==============================================

def get_fishes_by_date(fish_d, date):
    fishlist = []

    date_check = is_date_in_list(fish_d, date)
    
    if date_check == 0:
        return fishlist
    else:
        all_fish_eaten_on_day = fish_d[date]
        each_type_fish_eaten_on_day = set(all_fish_eaten_on_day)

        for name in each_type_fish_eaten_on_day:
            fishlist.append(name)
    
        return fishlist

def get_dates_by_fish(dates_d, fish):
    dateslist = []

    fish_name_check = is_fish_name_in_list(dates_d, fish)

    if fish_name_check == 0:
        return dateslist
    else:
        which_days_fish_was_eaten = dates_d[fish]
        each_day_fish_was_eaten = set(which_days_fish_was_eaten)

        for day in each_day_fish_was_eaten:
            dateslist.append(day)
 
        return dateslist

def is_fish_name_in_list(dates_d, fish):
    fish_in_list = 0

    for name in dates_d:
        if fish == name:
            fish_in_list = fish_in_list + 1
        else:
            fish_in_list = fish_in_list + 0

    if fish_in_list == 0:
        return 0
    else:
        return 1

def is_date_in_list(fish_d, day_of_interest):
    date_in_list = 0

    for date in fish_d:
        if day_of_interest == date:
            date_in_list = date_in_list + 1
        else:
            date_in_list = date_in_list + 0

    if date_in_list == 0:
        return 0
    else:
        return 1

def get_fishes_by_datelist(fish_d, datelist):

    dict_of_fish_for_all_days_in_list = {}

    for date in datelist_of_interest:
        list_of_fish_for_each_day = []
        list_of_fish_for_each_day = get_fishes_by_date(fish_d, date)

        list_of_fish_for_each_day.sort()
        
        dict_of_fish_for_all_days_in_list.setdefault(date, []).append(list_of_fish_for_each_day)

    return dict_of_fish_for_all_days_in_list

def get_dates_by_fishlist(dates_d, fishlist_of_interest):
    dict_of_days_for_all_fish_in_list = {}

    for fish in fishlist_of_interest:
        list_of_days_for_each_fish = []
        list_of_days_for_each_fish = get_dates_by_fish(dates_d, fish)
        list_of_days_for_each_fish.sort()

        dict_of_days_for_all_fish_in_list.setdefault(fish, []).append(list_of_days_for_each_fish)

    return dict_of_days_for_all_fish_in_list 


fish_d = load_csv('https://raw.github.com/ctb/edda/master/doc/beacon-2011/tutorial5/fishies.csv')
print
dates_d = make_dates_dict(fish_d)

day_of_interest = '13/1'
print "This is get_fishes_by_date(fish_d,'",day_of_interest,"'): "
print get_fishes_by_date(fish_d, day_of_interest)
print


fish_of_interest = 'salmon'
print "This is get_dates_by_fish(dates_d,'",fish_of_interest,"'): "
print get_dates_by_fish(dates_d, fish_of_interest)
print

fishlist_of_interest = ['salmon', 'maguro']
dates_for_fishes = get_dates_by_fishlist(dates_d, fishlist_of_interest)

for f, v in dates_for_fishes.iteritems():
    print f,v
print

datelist_of_interest = ['1/12', '9/9', '14/1']
fishies_for_dates = get_fishes_by_datelist(fish_d, datelist_of_interest)
print "this is the result of get_fishes_by_datelist function: "
for d, v in fishies_for_dates.iteritems():
    print d,v


