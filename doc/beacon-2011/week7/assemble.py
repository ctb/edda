import sys

K=6
kmers = set()

def next_words(wordset, word):
    prefix = word[1:]
    for ch in "abcdefghijklmnopqrstuvwxzy ":
        word = prefix + ch
        if word in wordset:
            yield ch

def retrieve_all_sentences(wordset, start, max_depth=100):
    if max_depth == 0:
        yield start + '...'
        return
        
    word = start[-K:]

    found = False
    for ch in next_words(wordset, word):
        found = True
        for sentence in retrieve_all_sentences(wordset, start + ch,
                                               max_depth-1):
            yield sentence

    if not found:
        yield start

###

print 'loading shredded reads'

# for each line in the input file,
for line in open(sys.argv[1]):
    # remove newline
    line = line.strip()

    # & break down into words of length K
    for start in range(len(line) - K + 1):
        word = line[start:start+K]
        kmers.add(word)

x = list(retrieve_all_sentences(kmers, "the quick"))
print x
