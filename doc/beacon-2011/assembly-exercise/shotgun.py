import random

OUTPUT_N_COLUMNS=3
COLUMN_WIDTH=25

ARTIFACT_P = .01
ARTIFACT_LEN=5

DEFAULT_MUT=0.02                                # mutation rate

BIASED_ABUNDANCE=False

def load_quotes(filename):
    # load in all the data
    data = open(filename).read()
    
    # split into different quotes based on two-line separation.
    data = data.split('\n\n')

    # lowercase & steam-clean the input: sub _ for whitespace, remove
    # punctuation.
    x = []
    for k in data:
        k = k.lower()
        k = k.replace(' ', '_')
        k = k.replace('\n', '_')
        k = k.replace('?', '_')
        k = k.replace(',', '')
        k = k.replace('\'', '')
        k = k.replace('.', '')
        k = k.replace('-', '_')
        if k:
            x.append(k)

    return x

def choose_quotes(quotes, BIASED_ABUNDANCE=False):
    chooseme = []
    for n, i in enumerate(quotes):
        if BIASED_ABUNDANCE:
            for j in range(n):
                chooseme += [n] * len(i)

        else:
            chooseme += [n] * len(i)

    return chooseme

def mutate(read, L, MUT):
    for k in range(0, L):
        if random.uniform(0, 1000) < MUT*1000:
            pos = random.choice(range(len(read)))
            s = ""
            for p in range(len(read)):
                if p == pos:
                    s += random.choice('abcdefghijklmnopqrstuvwxyz_')
                else:
                    s += read[p]
            read = s
            
    return read

def artifact(read, P, ARTIFACT_LEN):
    artifact = 'z'*ARTIFACT_LEN
    if random.uniform(0, 1000) < P*1000:
        pos = random.choice(range(len(read) - ARTIFACT_LEN))
        read = read[:pos] + artifact + read[pos + ARTIFACT_LEN:]

    return read

def sequence(quotes, chosen, L, COV, PAIRED, L_pm):
    # choose the number of samples to spit out, normalized by coverage
    n_samples = int(len(chosen) * COV / float(L) + 0.5)

    # now, grab a quote; choose randomly; output.
    samples = []
    for i in range(n_samples):
        seq = quotes[random.choice(chosen)]

        start = random.choice(range(len(seq) - L))

        if not PAIRED:
            read = seq[start:start + L]
        else:
            # yield paired ends with some variability in the insert size
            middle = int(random.normalvariate(2*L_pm, L_pm))
            if middle < 0:
                middle = 0
            elif middle > 4*L_pm:
                middle = 4*L_pm

            Lactual = L - middle
            read = seq[start + middle/2:start + Lactual + middle]

        samples.append(read)

    return samples

def run_sequencer(quotes, L, COV, PAIRED, L_pm, M, fp, SORT_OUTPUT,
                  MUT=DEFAULT_MUT):
    chosen = choose_quotes(quotes, BIASED_ABUNDANCE)

    samples = sequence(quotes, chosen, L, COV, PAIRED, L_pm)

    samples = [ mutate(read, L, MUT) for read in samples ]
    samples = [ artifact(read, ARTIFACT_P, ARTIFACT_LEN) \
                for read in samples ]

    if SORT_OUTPUT:
        samples.sort()

    SPACING=' '*10

    print >>fp, '<pre>'
    for n, i in enumerate(samples):
        if n and n % OUTPUT_N_COLUMNS == 0:
            print >>fp, ''
        if PAIRED:
            print >>fp, '%s...%s%s' % (i[:M], i[-M:], SPACING),
        else:
            print >>fp, '%s%s' % (i, SPACING),

    print >>fp, ''
    print >>fp, '</pre>'
