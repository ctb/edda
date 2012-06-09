column.types <- c("character", "numeric", "numeric", "numeric")
all.data <- read.csv("short_bc_snp_data.csv", header=TRUE, colClasses=column.types)

plot.chrom.bins <- function(chrom, bin.size=10000) { #default bin size is 10000
	
	#Start making a pdf
	pdf(file="~/data/Rplots/genome_plots.pdf")

	#Extract only the SNPs that are on the desired chromosome
	chrom.data <- all.data[all.data$chrom==chrom,]
	
	#Set up the bins
	#    positions.x will be a vector of x-values;
	#    in each one, we will put the average allele frequency of all SNPs within the range (x, x+bin.size)
	positions.x <- seq(from=1, to=max(chrom.data$pos), by=bin.size)
	
	#Set up an empty vector to hold all our allele frequencies
	#    To start, we are filling it with NA's, or missing data
	#    And we are giving it the same size as positions.x
	allele.freqs <- rep(NA, length(positions.x))
	
	#Now let's fill in allele.freqs
	#    Let's do this by looping through all the bins, filling in the allele frequency for each,
	#    one at a time
	for (cur.bin in 1:length(positions.x)) { # 1:length(positions.x) creates a vector that goes from 1 to the
		                                     # number of items in positions.x
		bin.min.x <- positions.x[cur.bin] #Figure out what the x-coordinate of the left end of the current bin is
		bin.max.x <- bin.min.x + bin.size #Figure out what the x-coordinate of the right end of the current bin is
		
		#Extract a data frame that has only the SNPs within our bin
		cur.data <- chrom.data[(chrom.data$pos >= bin.min.x) & (chrom.data$pos < bin.max.x),]
		
		#Count how many total 'sam' alleles we found in this region
		sam.count <- sum(cur.data$sam)
		
		#Count how many total 'ore' alleles we found in this region
		ore.count <- sum(cur.data$ore)
		
		#Figure out the frequency of the 'sam' allele
		sam.freq <- sam.count / (sam.count + ore.count)
		
		#Store it in the appropriate slot of allele.freqs
		allele.freqs[cur.bin] <- sam.freq 
	}
	
	#Now that we have all our data, let's plot it
	
	#Set up the plot window
	plot(x=NULL, y=NULL, xlab=paste("Position on chromosome arm ", chrom), ylab="Frequency of sam allele", xlim=c(1, max(positions.x)), ylim=c(0,1))
	
	#Plot the actual points
	points(x=positions.x, y=allele.freqs, cex=0.5, col="blue") #cex=0.5 tells it to make the points half the size of the default
											                   #col="blue" tells it to plot the points in color
											                   
											                   
	#Finish the pdf
	dev.off()
}


plot.chrom.sliding.window <- function(chrom, step.size=5000, window.size=10000) {
	
	#Start making a pdf
	pdf(file="~/Dropbox/genome_plots.pdf")
	
	#Extract only the SNPs that are on the desired chromosome
	chrom.data <- all.data[all.data$chrom==chrom,]
	
	#Set up the window positions
	#    positions.x will be a vector of x-values;
	#    in each one, we will put the average allele frequency of all SNPs within the range (x-window.size/2, x+window.size/2)
	positions.x <- seq(from=1, to=max(chrom.data$pos), by=step.size)
	
	#Set up an empty vector to hold all our allele frequencies
	#    To start, we are filling it with NA's, or missing data
	#    And we are giving it the same size as positions.x
	allele.freqs <- rep(NA, length(positions.x))
	
	#Now let's fill in allele.freqs
	#    Let's do this by looping through all the window positions, filling in the allele frequency for each,
	#    one at a time
	for (cur.pos in 1:length(positions.x)) { # 1:length(positions.x) creates a vector that goes from 1 to the
		                                     # number of items in positions.x
		window.min.x <- positions.x[cur.pos] - (window.size / 2) #Figure out what the x-coordinate of the left end of the current bin is
		window.max.x <- positions.x[cur.pos] + (window.size / 2) #Figure out what the x-coordinate of the right end of the current bin is
		
		#Extract a data frame that has only the SNPs within our bin
		cur.data <- chrom.data[(chrom.data$pos >= window.min.x) & (chrom.data$pos < window.max.x),]
		
		#Count how many total 'sam' alleles we found in this region
		sam.count <- sum(cur.data$sam)
		
		#Count how many total 'ore' alleles we found in this region
		ore.count <- sum(cur.data$ore)
		
		#Figure out the frequency of the 'sam' allele
		sam.freq <- sam.count / (sam.count + ore.count)
		
		#Store it in the appropriate slot of allele.freqs
		allele.freqs[cur.pos] <- sam.freq 
	}
	
	#Now that we have all our data, let's plot it
	
	#Set up the plot window
	plot(x=NULL, y=NULL, xlab=paste("Position on chromosome arm ", chrom), ylab="Frequency of sam allele", xlim=c(1, max(positions.x)), ylim=c(0,1))
	
	#Plot the actual points
	points(x=positions.x, y=allele.freqs, cex=0.5, col="red") #cex=0.5 tells it to make the points half the size of the default
											                     #col="red" tells it to plot the points in color
			
											                     
	#Finish the pdf
	dev.off()

}

#par(mfrow=c(2,1)) #Tell R to divide the plot window into 3 horizontal panels
#plot.chrom.bins("2L")
#plot.chrom.bins("2L", 100000)
#plot.chrom.sliding.window("X", 10000, 20000)
#plot.chrom.sliding.window("X", 10000, 100000)

#par(mfrow=c(2,1)) #Tell R to divide the plot window into 3 horizontal panels
#plot.chrom.sliding.window("2L", step.size = 10000, window.size = 20000)
#plot.chrom.sliding.window("2L", step.size = 10000, window.size = 100000)