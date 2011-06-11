## functions calling functions
## they say hello!
## 
## Python 2.7
## Created: RCK - 7/10/11
## Last Update: RCK - 7/10/11

## import modules
from optparse import OptionParser


################## functions! #########################
def print_hello( from_name, to_name ):
    print from_name + ": Hello " + to_name + "!"

def print_hello_to_each_other( name1, name2 ):
    print_hello( name1, name2 )
    print_hello( name2, name1 )

################### set up parameters ##################
## program usage
usage = """usage: %prog <greeter> <greetee>
"""

### init the options parser
parser = OptionParser( usage )

## fetch the args
( options, args ) = parser.parse_args()

## parameter error
if len(args) < 2:
    parser.error("incorrect number of arguments")

name1 = args[0] ## the first argument
name2 = args[1] ## the second argument

################### say hello #########################
print_hello_to_each_other( name1, name2 )

