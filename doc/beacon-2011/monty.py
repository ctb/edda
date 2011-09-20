import random

def monty_hall(switch):
    # first, set up the doors to be empty.  use a dictionary, so that
    # we don't have to worry about list indices or anything.
    doors = {}

    doors[1] = doors[2] = doors[3] = 'empty'

    # now, pick one (at random) to contain a million bucks.
    full_num = random.randint(1, 3)
    doors[full_num] = 'a million bucks!'

    # ok!  set up is done.  now, pretend we're the contestant.  pick one
    # of the doors at random.
    your_choice = random.randint(1, 3)

    # monty is now going to reveal one of the other doors to you.
    while True:
        monty_choice = random.randint(1, 3)
        if monty_choice != your_choice and doors[monty_choice] == 'empty':
            break

    # ok, now - do you switch to the other door?
    if switch:
        door_list = [1,2,3]
        door_list.remove(your_choice)
        door_list.remove(monty_choice)
        assert len(door_list) == 1
        your_choice = door_list[0]      # we'll only have one left!

    # now, what'd you get? 'empty' or 'a million bucks!'?
    return doors[your_choice]

###

def monte_carlo(do_switch):
    results = []
    for i in range(100):
        results.append(monty_hall(do_switch))

    return (100 - results.count('empty'))/float(100.)

print monte_carlo(True)
