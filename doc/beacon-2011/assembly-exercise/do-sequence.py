import random, sys
import shotgun

signature = '2011.oct4.' + str(random.randint(1, 50000))

COV=10                                  # final coverage

PAIRED=False

if not PAIRED:
    L=7                                     # read length
    L_pm = None
    M = None
else:
    L_pm=5
    L=25                                    # insert size + 2*L_pm
    M=5

    assert 4*L_pm < L

# load quotes
quotes = shotgun.load_quotes(sys.argv[1])

# do a variety of sequencing
fp = open('out-pe.html', 'w')
print >>fp, "Paired-end reads, medium insert size, medium-coverage<br>"
print >>fp, signature
shotgun.run_sequencer(quotes, 25, 5, True, 5, 5, fp, True)

fp = open('out-pe2.html', 'w')
print >>fp, "Paired-end reads, long insert size, low-coverage<br>"
print >>fp, signature
shotgun.run_sequencer(quotes, 50, 2, True, 15, 8, fp, False)

fp = open('out-single.html', 'w')
print >>fp, "Single-ended reads, long, high coverage<br>"
print >>fp, signature
shotgun.run_sequencer(quotes, 15, 10, False, None, None, fp, True, MUT=.15)

fp = open('out-single2.html', 'w')
print >>fp, "Single-ended reads, long, low-coverage<br>"
print >>fp, signature
shotgun.run_sequencer(quotes, 10, 2, False, None, None, fp, False)

fp = open('out-single3.html', 'w')
print >>fp, "Single-ended reads, short, medium coverage<br>"
print >>fp, signature
shotgun.run_sequencer(quotes, 6, 5, False, None, None, fp, True, MUT=.01)
