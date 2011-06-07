===================
Mapping with bowtie
===================

bowtie is an open source mapping program that's fast and easy to use.

Installing bowtie
-----------------

First, set up a new EC2 server as in
:doc:`renting-a-computer-from-amazon`.  You'll need to use a different
machine image (AMI) so that we can have more memory and disk space;
use 'ami-fb16f992', and leave the instance as 'large' (the default).
This gives you 7.5gb of RAM, 2 processors, each twice as fast as the
machine we've been using, and 850gb of disk space to work with!  It
does cost 3 times as much (34 cents/hour) so please remember to shut
them down...

Now, log in, and download bowtie.  Ordinarily you would do this by going
to the bowtie site:

   http://bowtie-bio.sourceforge.net/index.shtml

and downloading the latest source release, a zip file -- note that
it's tough to use curl to download files from Sourceforge because they
hide the real URL from you, so this might be a situation where
(outside of this course) you need to download the file to your laptop
first.

For the course, I've put it on my Amazon files section (in S3) where
you can download it directly, so do::

  %% cd
  %% curl -O https://s3.amazonaws.com/angus.ged.msu.edu/bowtie-0.12.7-src.zip
  %% unzip bowtie-0.12.7-src.zip 

This creates a directory 'bowtie-0.12.7', containing the source code.
Bowtie is written in C and C++, so unlike Python, you have to go
through a compilation step where you build the C/C++ source code into
something that the computer can run.  To do that, ::

  %% cd bowtie-0.12.7
  %% make
  %% cp bowtie bowtie-build bowtie-inspect /usr/local/bin

(This will take a while.)

Great!  We've installed bowtie!

Running bowtie on a Campylobacter data set
------------------------------------------

Now, let's go get a data set.  We're going to put it in a directory on
a different disk::

  %% mkdir /mnt/campy
  %% cd /mnt/campy

You can see using 'df' that '/mnt' is much bigger than '/', which is where
we were working before. ::

  %% df

Note that you can always see how much disk space you have in a particular
directory using 'df $directory', so e.g. ::

  %% df .

shows the disk space left on your current disk.

Now get the files::

  %% curl -O https://s3.amazonaws.com/angus.ged.msu.edu/campy.fa.gz
  %% curl -O https://s3.amazonaws.com/angus.ged.msu.edu/campy-pre-1m.fastq.gz

This uses the program 'curl' to grab the files at those URLs and download
them to the EC2 computer; it's similar to downloading them to your
laptop by entering them into your Web browser, then copying them over
to the EC2 computer with SCP.  The difference is that the files don't
actually have to travel over your local network connection, which is
a big advantage -- they go straight from wherever they're hosted (in
this case, Amazon S3) to the EC2 computer.

Now, if you do ::

  %% ls

you should see two files, ``campy-pre-1m.fastq.gz`` and ``campy.fa.gz``.
Uncompress them both::

  %% gunzip *.gz

You will now have two files: one, 'campy.fa', is the campylobacter
genome in FASTA format.  The other, 'campy-pre-1m.fastq' is a bunch
of genome resequencing reads in FASTQ format -- take a look at it
with 'less' if you're interested.

Now you need to index the genome so that bowtie can work with it.  You
only need to do this once for each genome::

  %% bowtie-build campy.fa campy

And, finally... map! ::

  %% bowtie -p 2 campy campy-pre-1m.fastq > campy-pre-1m.map

Here, the '-p 2' says "use both processors".  By default bowtie will
use only one.

You should see the following output::

  # reads processed: 1000000
  # reads with at least one reported alignment: 992463 (99.25%)
  # reads that failed to align: 7537 (0.75%)
  Reported 992463 alignments to 1 output stream(s)

1m reads, 99.25% of which match! 

You can now take a look at the mapping file with 'less'::

  %% less campy-pre-1m.map

Each line looks like this::

  HWI-EAS216_0019:4:1:1095:15232#0/1      +       campy_genome    830405  TGTTCATTTTCNTTAAACACTGTTCTTGNNACACT     ><7><7>>>5/&0008888;AAAAA##########     0       11:A>N,25:C>T,28:A>N,29:A>N

That's: the name of the read, the orientation, the chromosome, the
position (starting) of the mapped read, the mapped read, the quality
scores of the mapped read, something more complicated, and a
description of where this read contains mismatches with the reference.
