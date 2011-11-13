from matplotlib import pyplot

def load_fitness(filename):
    print 'loading fitness info from', filename
    updates = []
    fitnesses = []
    
    for line in open(filename):
        line = line.strip()             # eliminate whitespace @ beginning
        
        if not line:                    # skip blank lines
            continue
        
        if line.startswith('#'):
            continue                    # skip lines with a comment

        data = line.split()
        update = int(data[0])
        fitness = float(data[3])

        updates.append(update)
        fitnesses.append(fitness)

    print 'done! with', filename
        
    return updates, fitnesses

##

experiment_name = 'experiment1'
datafile = '/data/' + experiment_name + '/data/average.dat'

print 'plotting fitness for', experiment_name
eu, ef = load_fitness(datafile)
pyplot.plot(eu, ef, 'r-')

plot_file = '/root/Dropbox/%s.pdf' % experiment_name
print 'saving PDF', plot_file
pyplot.savefig(plot_file)
