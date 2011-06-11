## Reads a CSV file, and output lines with a * in the third column
## 
## Python 2.7
## Created: RCK - 7/10/11
## Last Update: RCK - 7/10/11

## import modules
from optparse import OptionParser
import csv

################### set up parameters ##################
## program usage
usage = """usage: %prog <infile.csv> <outputfile.csv>
"""

### init the options parser
parser = OptionParser( usage )

## fetch the args
( options, args ) = parser.parse_args()

## parameter error
if len(args) < 2:
    parser.error("incorrect number of arguments")

inputfile = args[0] ## the first argument
outputfile = args[1] ## the second argument

################### iterate over the files and extract the content ############

## use the Sniffer class to automatically identify the format of the file
inputfile_handle = open( inputfile, "rb" ) ## r: read; b: a file
dialect = csv.Sniffer().sniff( inputfile_handle.read( 1024 ) )
inputfile_handle.seek( 0 ) ## reset the read head to the beginning of the file

## create a CSV reader based on the dialect we deduced
inputfile_reader = csv.reader( inputfile_handle, dialect ) ## open the file using the deduced dialect

## create a CSV writer based on the style of the reader
outputfile_handle = open( outputfile, "wb" ) ## w: write; b: a file
outputfile_writer = csv.writer( outputfile_handle, dialect ) ## use the detected dialect 

### loop through every row in the file and output the proper lines
for row in inputfile_reader: ## row is a list of items (fields)
    if len(row) > 0 and row[2] == '*': ## if the row has a * in the third column
        outputfile_writer.writerow( row ) ## write the line to the output file


