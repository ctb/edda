
# Written by Ian Dworkin, last modified on Sept 12/2010
# make sure you start in the correct directory (working directory), with the input data


# Table of Contents
# Section 1: Getting data into R (why you should use .csv,  setting your working directories, read.csv() vs read.table())
# Section 2: Examining your data: Did it import correctly? (checkin that the data imported correctly, examining raw data, summarizing it, changing classes for columns in your data.frame)
# Section 3: looking at specific columns of your data, and why you should use with() instead of attach()
# Section 4: Data manipulations (subsetting, sorting, merging)
# Section 5: Exporting fata from R
# Section 6: Installing libraries in R.
# Section 7: VERY BASIC plotting (much more in class)
# Section 8: Notes on Using R in linux/OS X vs Windows
# Section 9: Things for Ian to add in the future.



###Section 1:
#### Getting your data into R

# often the most difficult aspect people have with R is getting it read data in the first place!!!




#### I recommend that you use the read.csv() function with .csv files whenever possible.

 # When starting with a spreadsheet from a program like excel or open office,  let me make a couple of suggestions.
 
 # For missing data, make sure the cells are empty and do not have some "dummy" character like a "." or NA (for read.csv())
 
 # Make sure that your column headings are clear like "sex" or "log.femur.length"
 
 # We are going to use one (of many ways) to read our data in. using comma seperated files (CSV)
 
 # thus it is important that you do not have any commas in your data set, as this will muck up your file.
 
 # in excel file -> save as.....



#### Back to R....

# One important thing to do is make sure you access the correct working directory for your files.

# I personally organize my projects around folders, so that both my R scripts, data sets and output for a particular project are all in the same folder. If you save workspaces, you should probably keep your workspace in this folder as well.

# Setting working Directory for Windows - using unix slashes
setwd('C:/Documents and Settings/Ian Dworkin/My Documents/Work/R-Project/Dll data')


 # or you can use windows/Dos slashes, but you need to  to use "\\"
setwd("C:\\Documents and Settings\\IAN\\My Documents\\Work\\R-Project\\Dll data")

# this sets the working directory.  Alternatively use the GUI
# under windows under the R GUI go to file -> change dir.

# Command prompt in Windows (So you can be cool like the people who work on UNIX)
# You need to set the path in the environmental variables if you do not
# want to have to go to the Program Files\R-version\bin directory each time
# At the prompt type "R.exe" and work in the R terminal.  
 

# I don't think it matters for this if you use double or single quotes... but don't quote me on that :)

# Mac OSX - Setting working directory under Mac OSX  - see notes on using R in OSX at bottom
setwd("/Users/ian/R/R scripts/Dll data/") 
# GUI method - under the R gui go to misc -> change working directory.

# Under Linux  - see notes on using R in Linux  at bottom of script
setwd("/home/Ian/R scripts/Dll data")



# Two other useful commands
getwd()  # check current working directory
dir()    # List the files in the working directory (list.files() does the same thing)



# Other alternatives you can always use
file.choose() # to choose a file
scan() ## reads data into a vector or list 

# For all systems
#    or
#   setwd(dirname(file.choose()))


 
 
  ##### Importing YOUR data from a text (csv file)
  
  # Now that we are in our working directory
  
dll.data = read.csv("dll.csv", header=TRUE)   #data frame input
# lots of ways of importing the data. I prefer csv (comma seperated) since it 
# it tends not to mess up when there is an empty cell representing missing data

dll <- read.csv("http://datadryad.org/bitstream/handle/10255/dryad.8377/dll.csv", h=T)


#read.table("filename", h=F, sep="",...) # read.table is a more general function to read in data, at a cost of speed, and in some cases mistakes. The speed only matters for very large data sets.


# Section #2 Looking at your data (and doing some minor fixes)
# take a look at the data
fix(dll.data) # provides a spreadsheet to examine data. Useful to see if missing
# values are encoded correctly.
# you need to close the spreadsheet before proceeding.


# Quality Control of the data frame - making sure that everything makes sense
str(dll.data) # displays the structure of the object (in this case the data frame)
## i.e. lists variables and their types (numeric, integer or factor)


summary(dll.data) # basic summary information for variables in the object

head(dll.data) # outputs the first 6 observations
tail(dll.data) # outputs LAST 6 observations
dim(dll.data) # the dimensions of the data sheet.

# since this is not a vector we can not use length(), instead we can use nrow() or ncol(). All that information is in dim() however.

class(dll.data) # outputs the class of the object
mode(dll.data) # a list... data.frame is just a special form of a list.

names(dll.data) # names of variables

### What if we wanted to look at a particular column of data

dll.data$genotype  #   data.set$column
summary(dll.data$genotype)
#################################


##### Attaching the data
attach(dll.data)

# this is one way of getting the data.frame object so that you can directly call
# upon variables. However, below I show another approach that I often use.
# One warning about attach() is that it makes a static copy of the data frame
# any changes made post "attaching" will not be placed in the attached copy in memory

detach(dll.data) # does what you would expect, but works imperfectly


# we will not use attach() for the moment.

# An alternative to attach is to use the with() function
with(dll.data, mean(SCT))  # Notice the NA... not so useful...


 # removing  missing data (NA's)
# one approach is to "clean-up" the data set from the beginning.
dll.data.vetted = na.omit(dll.data)  # This removes all rows with missing data.  This is a pretty extreme option that you do not want to generally use.

# We can just do this as needed
with(dll.data, mean(na.omit(SCT))) 



# Fixing the data as need be
#   transform numeric (integer) to "character" variables
#   both temperature and replicate were coded numerically originally
str(dll.data) # lists variables and their types to show this
dll.data$temp <- factor(dll.data$temp)
dll.data$replicate <- factor(dll.data$replicate)
str(dll.data) # check that this fixed the problem

 # After making these changes is when I would consider using attach(dll.data)



##########################################
#manipulating and extracting data from the data frame object (the data!!).

  # Subsetting the data often you want a subset of the data
 
 # You can performing subsetting from the index. 
 
 SCT_Dll <-  dll.data[dll.data$genotype == "Dll",]
 dim(SCT_Dll)
 head(SCT_Dll)
 
#However, there is also a pre-built function that acts as an easy to use wrapper. Subsetting using the index is faster. Indeed, just about any operation can be done using indexing, and it is faster.

 
  SCT_Dll.2 = subset(dll.data, genotype == "Dll" )
  dim(SCT_Dll.2)
  
  SCT_wt= subset(dll.data, genotype == "wt" )
  hist(SCT_Dll$SCT, xlim = c(5,20), col= "blue", breaks=7)
  hist(SCT_wt$SCT, xlim = c(5,20),br=7,col="red" , add = TRUE)
  
  
# treat the data frame as a matrix, and extract a column vector
#  var =data.set[,"column_name"] # keep row entry blank for this
sct = dll.data[,"SCT"]
tarsus = dll.data[,"tarsus"]
tibia = dll.data[,"tibia"]
femur = dll.data[,"femur"]


#alternatively treating the data frame as a list and extracting columns
# this approach may not be nesc, but perhaps useful.
# sct = dll.data[["SCT"]]
# tarsus = dll.data[["tarsus"]]
# tibia = dll.data[["tibia"]]
# femur = dll.data[["femur"]]



# summarize the extracted object
table(sct)
hist(sct, br=(5:32)) # histrogram  with breaks specificed
#alternatively
hist(dll.data$SCT)


hist(dll.data[dll.data$genotype=="wt", "SCT"], add=F, freq=T, border="blue", breaks=br)


####### Sorting the data: how to re-order data frames########

# this will order the dataset by the variable genotype
dll.order <- dll.data[order(dll.data$genotype),]

# The reverse order for the same things
dll2 <- dll.data[order(-rank(dll.data$genotype)),]

# relevel seems to be the easiest way.
#relevel
#reorder  # the most flexible I think


# merging data frames

# We can obviously use functions like cbind() to place columns together, or rbind() to do the same for rows.. 

individuals <- as.factor(letters[1:11])
individuals

height <- rnorm(11, 10, 1)
weight <- rnorm(11, 60, 2)

# If we wanted to put all of these together into a dataset we could
data.1 <- cbind(individuals, height, weight)
# or better yet

data.1.alt <- data.frame(individuals, height,weight)

#However often, the data do not match perfectly.. Missing information for instance, or a different order
age <- rpois(n = 7, lambda = 22)
individuals.2 <- as.factor(c("a", "c", "b", "f", "k", "i", "e"))
data.2 <- data.frame(individuals.2, age)


# See what happens if we merge these data sets together... (check by yourself)
data.frame(data.1, data.2)
# you could force it numerically, but you will end up recycling the shorter vector

# instead we use the merge() function.
data.merged <- merge(data.1.alt, data.2, by.x ="individuals", by.y="individuals.2", all=T)
data.merged


# reshaping data.. For basic stuff see reshape() which is part of base R


# there are a number of packages that will do all of the above sorts of things, and much more (including reshaping the data). Check out "reshape" & "plyr"



##### outputting FILES from R  ######

write.csv(sct, file='SCT.csv') # with column labels
#or
write(sct, file='SCT2.csv', ncolumns=1,sep=",")     # no column labels



####### Installing & using libraries

# There is a vast collection of libraries available for R. They are available from CRAN and various mirror sites.

# There are numerous ways of installing libraries

# If there is a particular library that you want to use
install.packages("bbmle")
# or you can use the GUI

# R does not keep all of the packages on your system in memory (waste of space, literally)
# So to use a library from a package you need to write
library(bbmle)

# you can also use require(), but this has some specific uses when you are building your own functions

# now you can use specific functions from those libraries (and you can now find them using ?)
  
# if there are specific data sets associated with a library, you can now use
data() # to access them

install.packages("emdbook")
library(emdbook)
data(ReedfrogPred)



###############PLOTTING#############
# graphical summary of ALL data
plot(dll.data) # all two-way scatterplots. Not so useful but try it once :)



 #  simple correlation and plot
cor(tibia,tarsus, use="pairwise.complete.obs")
# just the pearson correlation, the use= just tells it how to deal with missing data
cor.test(tibia,tarsus, use="pairwise.complete.obs") # to get  r, SD and p-value.
plot(tibia, tarsus)

# alternatively - and generally preferred.
cor(dll.data$tibia,dll.data$tarsus, use="pairwise.complete.obs")
cor.test(dll.data$tibia,dll.data$tarsus, use="pairwise.complete.obs")
plot(dll.data$tibia, dll.data$tarsus)




  
  ##### Notes on Using R under Apple OSX #############
  #If you have the choice for plotting, run your scripts under OS X/ 
  # THe Quartz system (native graphical system with aqua GUI) 
  # produces extremely high quality figures in PDF or PS
  
  # You have three choices for running R in OSX
  # 1 - (aqua based) Click on the R icon in your applications (or better yet your dock)
  # This has all of the nice GUI options for point and click and has the highlighted
  # editor built in. This is often the easiest way to go.
  # However this does not support X11 windowing (and Tcl-tk libraries)
  
  # 2 - For the X windowing system (like the one used in Linux and BSD) make sure you have installed
  #  X11 from the OSX install disc
  # open an X11 terminal window 
  # at the prompt ($)  type " R" for a basic terminal window
  # or
  # $ R --gui=tk (for a Linux like GUI)
  # This will allow you to use the tk libraries and things like the qvalue.gui() function
  
  # 3- Regular terminal window
  # At the terminal prompt ($) type "R" for terminal based R
  # This DOES NOT SUPPORT X Windowing systems.
  
  ##### Notes on Using R under Linux (maybe BSD as well.. not sure)
  
  # Open a terminal window at the prompt type "R" and use the shell
  # or for the X11 tk GUI type "R --gui=tk"
  # If you want to maximize the system resources for R (and you either do not
  # need plots, or are happy to not look at them while they are saved) I suggest
  # Rebooting your computer at runlevel 3, work at the shell and then reboot at run level 5
  # For graphing. Make sure you know what you are doing in Linux!!!!
  
  # Adding libraries on Unix based systems - local versus admin
  # For all Unix based systems (BSD, Linux and OS X) installing and updating
  # libraries/packages should be done by someone with administrative privelages
  # for the computer system (i.e. root for linux). Otherwise the libraries will only
  # be installed locally in the users home directory, and if multiple people are using the
  # same computer, you may install multiple versions of the same library.
  
  
  
  
  ### NOTE: FEB 2010. 
# conditionals
# iterations (for).. Use the conditional and iterations tutorial I wrote.
# apply like functions?
# Clarify re-ordering
# removing unused levels with factor() or drop.levels () from gdata.
# using with(dataset, function() )
# Some introduction to vector functions (apply, replicate, colSums, rowSums, rowMeans, colMeans)
