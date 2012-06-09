# R tutorial for NGS2011
 
# Written by Ian Dworkin
# Last updated June10th 2011

# TOC
# Section 1: What is R;  R at the console; quiting R
# Section 2: R basics; R as a calculator; assigning variables; vectorized computation in R
# Section 3: pre-built functions in R
# Section 4: Objects, classes, modes - Note: should I add attributes?
# Section 5: The R workspace; listing objects, removing objects (should I add attach and detach?)
# Section 6: Getting Help in R
# Section 7: Using a script editor for R
# Section 8: Writing simple functions in R
# Section 8b: Using source() to call a set of functions 
# Section 9: Regular sequences in R
# Section 10: Extracting (and replacing), indexing & subsetting (using the index). Can also be used for sorting.

#### Advanced stuff to learn on your own...
# .....  setting attributes of objects.... (names, class, dim )
# .....  environments   (see ?environments)


# For this tutorial, if you do not have R installed locally on your machine, please get an instance up and running with dropbox.


#### Installing R

# R can be installed on all of your local computers, or on your EC2 machine.
# go to 
# http://www.r-project.org/
# click download and follow for your OS. (see power point slides)

# For the EC2 machine that we are using (Debian Linux) we can use
apt-get install r-base

# To log into R on your instance just type::
R



#################
#What is R, really.... (demonstration from the console)
#Where to find stuff in GUI R (navigating GUI-R)

#pull down menu's


##############


# How to close R

# to quit R
q()  ##NOTE to MAC (OS X) users... this will no longer work when running locally on the mac (R V2.11.+ ) from the Mac R GUI... See below in OS X specific notes..

### NOTE
# for the moment when it asks you to save workspace image, say no.
#############



########### R Basics ############


# anything followed by the number sign is ignored by R

#R as a calculator
2+2

#creating variables in R
y = 2
# When you  create a variable like this, it does not provide any immediate output.

# but when you type y and press return
y

#Note that the "[1]" is just an index for keeping track where the answer was put.  It actually means that it is the first element in a vector.

# Note that R is case SENSITIVE that is  y  & Y are not the same

y

Y

#####

x = 3
x + y
z  <-  x+y


########
# You will notice that sometimes I am using "=" and sometimes "<-". 
# These are called assignment operators. In most instances they are equivalent. but the "<-" is preferred in R, and can be used anywhere
# You can look at the help file (more on this in a second) to try to parse the difference
?"="

#If you can not find something that you know is there... use the ??


#### We may want to ask whether a variable that we have computed equals something in particular
# for this we need to use "==" not  "=" (one equals is an assignment, two means "equal to")
 x==3 
 x==4
 x==y


# what happens if we write
x = y
# we have now assigned the current value of y (2) to x. This also shows you that you can overwrite a variable assignment.


########
# standard mathematical operators apply
# * for multiplication
2*3

# / for division
 6/3

# ^ for exponents. Can also use **
3^2
3**2  # same as above

# you can use "^0.5" or sqrt() function for square root
9^0.5
sqrt(9)


# to raise something to e^some exponent

exp(2)  # this is the performing e^2

# natural log (base e)
log(2.7)

# To raise to an arbitrary base

log(2.7, 10) # base 10
# can also use log10() or log2() for base 10 or base 2.


########


#R is vectorized.. it can do its operations on vectors

a <- c(2, 6, 4, 5)
b <- c(2, 2, 2, 1)
#The c is short for concatenate
#you can add the elements of the vectors together
a+b

#Or multiply the elements of the vector together (note this is NOT vector multiplication.. Those have special operators, i.e. %*%)
a*b

#if you want to make one big vector out of them
c <- c(a, b)


# how might you make a vector that repeats vector "a" 3 times ?




############## Simple functions in base R

#you can find out the length of the new vector
length(c) # This uses one of R's pre-built functions

#length() is an example of a pre-built function in R. Most things in R revolve around using functions to do something, or extract something. We will write our own simple functions soon.

#here are some more common ones that you may use

mean(c)
sum(c)
sd(c)  # standard deviation
var(c)  # variance
cor(a, b) # Pearson correlation (there are options to change this to other types of correlations, among the arguments for this function.....)

# Say we want to keep the mean of c for later computation we can assign it to a variable
mean.c <- mean(c)


####START HERE THURS
# We can look at the underlying code of the function (although some times it is buried, in these cases).

# so we can clearly add up all of the elements of the vector.


 #we can also join the two vectors together to make a matrix
d <- cbind(a,b)
d
# double check that we really made a matrix
is.matrix(d) # sets up a "Boolean". In other words when we ask "is d a matrix" it answers TRUE or FALSE
mode(d)
class(d)
 # while the mode of d is still numeric, the class is now a matrix.

#### Make a new vector q that goes a,b,ab


# There are many different classes of objects each with their own features.
# The basic data types are numeric, character, dates, factor, formula,...
# The basic data structures matrix, data.frame, array, list, time series, ...

# There are many more than we will come across, as we start using some functions


# We can also make vectors that are not numeric
cities <- c("Okemos", "E.Lansing", "Toronto", "Montreal")

class(cities)
mode(cities)

length(cities) # note this tells us how many strings we have in the object "cities" not the length of the string
nchar(cities)  # This tells us how many characters we have for each string.

rivers  <- c("Red Cedar", "Red Cedar", "Don Valley", "Saint Laurent")
cities.rivers <- cbind(cities, rivers)
cities.rivers
class(cities.rivers)
mode(cities.rivers)

# In this above example we have made a matrix, but filled with characters, not numerical values.



##########Objects in R, classes of objects, mode of objects #########

#R is an object-oriented language. Everything in R is considered an object. Each object has one or more attributes (which we do not generally need to worry about, but useful for programming.)
# Most objects in R have a "class", which is what we will usually care about. R has a bunch of useful classes for statistical programming.

mode(c) # mode of the object. The most basic (atomic?) feature. NOTE this does not mean the "mode" of a distribution
class(c) # class of the object
# typeof(c) # internal representation of type

mode(mean.c) # type of object
class(mean.c) #


 # as we will see soon, mode and class are not always going to report back the same thing.

# mode and class are not the same thing. modes are the basic 'structures" for the objects. integer, numeric, vector, matrix, character... class is a a bit more complicated.. but we will not get into it here.


### The last type of object we will need for this class (eventually) is called formula
# Not surprisingly this is used generally to generate a formula for a statistical model we want to fit.
model.1 <- y ~ x1 + x2 + x1:x2 # note this is just the model formula, and we HAVE NOT FIT ANY MODEL YET!!!!!! It just tells us the model we want to fit. That is the object model.1 has not yet been "evaluated"
model.1
typeof(model.1)
terms(model.1) # also see all.names() and all.vars

#When we use lm() or glm() or other mle2() or other model FITTING functions, then the model formula is used during the fitting procedure. 
# Usually we do not need to worry about this, or specify the model outside of the context of fitting.


##################



############## Workspaces, and objects in them ###################

#R stores variables, datafiles, functions, vectors, etc in what is called the Workspace.  This contains all of the items that you can #access directly within your R session.  You can list all of the objects in your workspace using:
ls()

# If you want to remove a particular variable (say x) use the rm() function

rm(x)

# you could remove multiple objects

rm(x,y,z)

# If you want to remove all of the objects in your workspace
rm(list=ls()) # We will learn what this means later, but basically we are making a list that contains all of the objects found by performing ls()


# Saving the workspace.

# Some people like to save their workspaces, not only because it contains all of the commands they have written, but also all of the objects they have created during that session.
# I personally do not do this unless I have created objects that have taken a long time to compute. Instead I just save the scripts I write (which I will show you in the next part).

# However if you write your commands directly at the console (like we have been doing) without a script editor, you should save your workspaces

save.image("file_name")

# if you want to load it again
load("file_name.RData")

# you will need to have the correct working directory set, which I will show you how to do shortly.



########### GETTING HELP in R ################
 
#There are a number of places where you can get help with R directly from the console.
 
?lm
 
?"*" # for help for operators use quotes

#This brings up a description of the function "lm"
 
# sometimes you will need to use
help.search("lm")
 #This brings up all references to the lm function in packages and commands in R.  We will talk about packages later.
 

RSiteSearch("lm")
#This is quite a comprehensive search that covers R functions, contributed packages and R-help postings.  It is very useful but uses the web.

# You can also use the html version of the help
help.start()

# or just go to the help menu


# Using the various help functions answer the following questions

#1
#2
#3

###########################




#### Writing everything at the console can be a bit annoying, so we will use a script editor. ########

# In Mac OS X I personally find the built-in script editor useful
# You can highlight the text in the script editor and press command (apple) + return to send it to the R console. Or place the cursor at the end of the line that you want to submit to R with command+ return.

# It also provides syntax highlighting, and shows the syntax & options for functions

# However, most of you are under the spell of Bill Gates....... While the basic script editor does not have much functionality, many people have written excellent script editors (show webpage)

# There are many windows script editors with syntax highlighting (such as Tinn-R)

# For a list of some 
# http://www.sciviews.org/_rgui/
# In general we will save R scripts with the extension .R



# now let's type something into our new script

 x <- c(3,6,6,7)

# now highlight that line and press 
#ctrl+r (windows) 
#apple key + return (mac)

# This should send the highlighted portion to R

# This does not seem to work on all versions of Tinn-R anymore (alas)

# go to options - > shortcut customizations  - > r_sending 
# double click on it and bind it to something like alt+f1 (or whatever you want)

# input the following

x <- c(2, 2, 2, 2)
y <- c(3, 3, 3, 3)
z <- cbind(x, y)
z

# highlight it all and it should send it to R.

a <-  c(x, y)
b <- c(x, x, y)

#################



############### Writing our own functions in R ###########

# we have now used a few built in functions in R (there are many). 
# anything where you use "()" is a function.

# We will often want to compute something for which there is no pre-built function. 

# Thankfully it is very easy to write our own functions in R. You should definitely get in the habit of doing so.

# functions have the following format

a.function <- function(input variable 1, input variable 2, arguments, ...) {expressions to calculate}

# this is abstract so let me give you a real example

# We want to compute the standard error of the mean which is ~equal to the sd/sqrt(sample size). How might we do it?

# We want to compute it for the numeric vector a

# we could do it by hand
sd.a <- sd(a)
sample.a <- length(a)

sd.a/sqrt(sample.a)

# or we could do it in one line
sd(a)/sqrt(length(a))  # notice the function within a function

# but we can also do it so that we can use any vector input we wanted by writing a function

sem <- function(vector) {
       sd(vector)/sqrt(length(vector)) } 

# now type sem
sem

# repeats the function

# If you want to edit the function just type
edit(sem)

sem(a)
# gives the result

# we can now use this vector for as long as we have this workspace open (and do not remove it)
sem(b)

# Exercise
# 1) Write your own function to do something simple, like calculate the co-efficient of variation (CV)  which is the sd/mean.

# 2) Write a function (or set of functions, with one nested within another) to....


# it takes some practice but learning "functional programming" can be extremely helpful for R.

# One thing to keep in mind, is that it is very easy to call one function from within another.  It is generally considered good practice to write functions that do one thing, and one thing only. It is way easier to find problems (debug).
#####################


#################### 8b: Using source() to load your functions

# One of the great things about writing simple functions, is that once you have them working, you can keep using them over and over. 
# However, it is generally a pain to have to include the text of the function in every script you write.
# instead, R has a function source() which allows you to "load" a script that contains functions you have written (and other options you may want), so that you can use them.

# For instance, I have written a little script that contains just two useful functions, for estimating the CV and SE (as discussed above.). It is in a file called "useful_R_function_ID_2011.R".
# to use it I just call
source('/root/Dropbox/ngs-scripts/RSatMorning/NGS2011_R_source_functions.R')




# Once you have written functions that you "trust", you can make your own collections so that you can utilize them at your leisure....




######### Regular Sequences #############

# Sometimes we want regular sequences or to create objects of repeated numbers or characters. R makes this easy.

# If you want to create regular sequences of integers by units of 1

one.to.20 <- 1:20
one.to.20

twenty.to.1 <- 20:1
twenty.to.1

 # for other more complicated sequences, use the seq() function

seq1 <- seq(from=1,to=20,by=0.5)
seq1

#or
seq1  <- seq(1,20,0.5)
seq1


 # this shows that for default options (in the correct order) you do not need to specify things like "from" or "by"

##### Exercise:  Make a sequence from -10 to 10 by units of 2



#### What if you want to repeat a number or character a set number of times?

many.2 <- rep(2, times=20)

# works for characters as well
many.a <- rep("a", times  = 10)

#We can even use this to combine vectors

seq.rep  <- rep(20:1, times = 2)
seq.rep 

seq.rep <- rep(one.to.20, 3)

# What if you wanted to repeat a sequence of numbers (1,2,3) 3 times?
rep.3.times <- rep(c(1,2,3), times=3)
# or
rep(1:3, times=3)

#let's say you wanted to create a factor within lakes. the first 5 observations are benthic, the second set of 5  observations are limnetics. One way (there is another way to generate levels of a factor, the function gl()   )
# Here we will use the "each" option

lakes.rivers <- rep(c("lake", "river"), each=5)
lakes.rivers


# what if we wanted to perform this to create a matrix

matrix(rep(20:1,4),20,4)


### Exercise... 

# now we have all the tools we need to build some data sets from scratch (which is helpful for simulations)



######### Indexing, extracting values and subsetting from the objects we have created ##########

# often we will want to extract certain elements from a vector, list or matrix. Sometimes this will be a single number, sometimes a whole row or column.


# We index in R using [ ]  (square brackets) 

a <- 1:20
b <- 5*a
a
b

length(a)
length(b)

#If we want to extract the 5th element from "a"
a[5]

# if we want to extract the 5th and 7th element from "b"
b[c(5,7)]

# if we want to extract the fifth through 10th element from "b"
b[5:10]

# how about if we want all but the 20th element of "a"?
a[-20]


# indexing can also be used when we want all elements greater than (less than etc...) a certain value
b[b > 20]

# or between certain numbers
b[b > 20 & b < 80]



# Indexing for matrices
c <- a+b
q.matrix <- cbind(a,b,c) #cbind "binds" column vectors together into a matrix (also see rbind)
q.matrix

# what happens if we ask for the length of q.matrix?

# we can instead ask for number of rows or columns
nrow(q.matrix)
ncol(q.matrix)

# it is more useful perhaps to find out the dimensions of the matrix
dim(q.matrix)  # R always specifies in row by column format.

# now say we want to extract the element from the 3rd row of the second column (b)
q.matrix[3, 2]

# how about if we want to extract the entire third row?

q.matrix[ 3, ]


# how about the second column?



# we can also pull things out by name
q.matrix[ ,"c"] # This is an example of indexing via "key" instead of numerical order



######################## A few thoughts about indexing for those used to Python (If you don't, ignore this)


# R indexing begins at 1 (not 0 like Python)
# Negative values of indexes in R mean something very different. for instance
a[-1] # this removes the first element of a, and prints out all of the remaining elements.

# As far as I know all classes of objects are mutable, which means you can write over the name of the objects, values within the objects, and slots....

# Indexing on a character string does not work in R
string.1 <- "hello world"
string.1[1]

# instead you need to use the substr() function
substr(string.1,1,1)
#################################







################ subsetting data sets.....

#Subsetting by indexing

#Subsetting by using subset()


# For more advanced data manipulations (including data sorting), see the reshape library, and the bok by Phil Spector (Data manipulation in R. See resources on ANGEL for a link)




#### Accessing values in objects


#  the at "@" is used to extract the contents of a slot in an object.. We will not use it much for this class, but it is essential for object oriented programming in R.
#  objectName@slotName

# The dollar sign "$" is used to extract elements of an object. We will use this a lot to extract information from objects (scuh as information from our models, like co-efficients)
# object.name$element.name

# For more information ?"$"



######## Ok let's take a break





#### A few advanced topics... For your own amusement (not nescessary for this class, but helps for more advanced R programming)

### Setting attributes of objects.

# Objects have attributes. The one we have thought about most is the class of the object, which tells us (and R) how to think about the object, and how it can be used or manipulated (methods). # We have also looked at dim() which is another attribute
# Here is a list of common ones:
# class, comment, dim, dimnames, names, row.names and tsp

# 


# We can set attributes of objects in easy ways like
x <- 4:6
names(x) <- c("observation_1", "observation_2", "observation_3")
x
# you can see the attributes in a bunch of ways
str(x)
attributes(x)
attr(x, "names") # Same as above, but we will be able to use this to set attributes of the object x as well

y <- cbind(1:5, 11:15)
attributes(y)
colnames(y) <- c("vec1", "vec2")
comment(y)  <- c("the first column is pretend data", "the second column is yet more pretend data ")
str(y)
attributes(y)....

# Generic functions and methods
# calling a function like summary() will do very different things for different object classes.  We will use this call alot for data frames and output from statistical models 
summary(x) # numeric vector
summary(string.1) # character string
# the call to summary() is generic, which first looks at the class of the object, and then uses a class specific method
# for x
summary(x)
summary.default(x)
# but..
summary.lm(x).. # Since this was looking for an object of class lm
methods(summary) # to see all of the methods used when you call the generic summary() for S3 classes.


### Need to in the future add material on S3 vs S4 classes.... But for now read on your own.

# R style guide (modified from Google and Hadley Wickham)
https://www.msu.edu/~idworkin/ZOL851_style_guide.html


# Note about using q() on the Mac R GUI in v2.11.+
# The programming team decided the default behaviour was potentially "dangerous", and people may lose their files, so they have changed it to command + q to quit instead. If you are an old-fogey like me and like to use q(), you have a couple of options.
base::q() # This will work, but it is annoying.

# you can set your .Rprofile to have the following line.
options(RGUI.base.quit=T)
# and the next time you run R the old q() will work.

# If you do not know how to create or edit .Rprofile, come speak with me...

