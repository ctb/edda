import random, calendar, csv, sys

menu = ['mackerel', 'salmon', 'halibut', 'mackerel', 'mackerel',
         'plaice', 'halibut', 'halibut', 'salmon', 'halibut', 'tilapia',
         'cod', 'halibut', 'mackerel', 'cod', 'salmon', 'cod', 'sole',
         'plaice', 'tilapia', 'mackerel', 'salmon', 'mackerel', 'cod',
         'mackerel', 'salmon', 'salmon', 'halibut', 'salmon', 'plaice',
         'sole', 'sole', 'ahi', 'mackerel', 'halibut', 'tilapia', 'ahi',
         'halibut', 'salmon', 'sole', 'sole', 'ahi', 'salmon',
         'halibut', 'plaice', 'char', 'sole', 'char', 'char', 'sole',
         'sole', 'sole', 'halibut', 'char', 'plaice', 'mackerel',
         'tilapia', 'halibut', 'maguro', 'maguro', 'plaice', 'maguro',
         'char', 'mackerel', 'halibut', 'maguro', 'plaice', 'maguro',
         'tilapia', 'salmon', 'mackerel', 'maguro', 'cod', 'sole',
         'mackerel', 'salmon', 'maguro', 'mackerel', 'salmon', 'ahi',
         'cod', 'maguro', 'mackerel', 'plaice', 'tilapia', 'tilapia',
         'sole', 'maguro', 'salmon', 'plaice', 'halibut', 'sole',
         'tilapia', 'salmon', 'salmon', 'sole', 'halibut', 'plaice',
         'salmon', 'cod', 'tilapia', 'ahi', 'mackerel', 'mackerel',
         'ahi', 'char', 'ahi', 'maguro', 'mackerel', 'sole', 'maguro',
         'cod', 'mackerel', 'halibut', 'sole', 'plaice', 'sole', 'cod',
         'ahi', 'halibut', 'char', 'halibut', 'cod', 'sole', 'mackerel',
         'plaice', 'sole', 'mackerel', 'tilapia', 'char', 'sole',
         'maguro', 'cod']

fish_types = list(set(menu))

days = {}
for month in range(1, 13):
    (_, n_days) = calendar.monthrange(2011, month)
    for i in range(1, n_days + 1):
        days[(month, i)] = []

daylist = sorted(days.keys())

for (month, day) in daylist:
    n_fish = random.randint(2, 10)
    x = days[(month, day)]
    for i in range(n_fish):
        x.append(random.choice(fish_types))

outfp = csv.writer(sys.stdout)
for (month, day) in daylist:
    for fish in days[(month, day)]:
        row = ["%s/%s" % (month, day), fish, ]
        outfp.writerow(row)
