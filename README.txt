Software for personal or collaborative commenting of Sphinx code, inspired
by Ian Bicking's Commentary.

To run (UNIX), you'll need Python 2.6, virtualenv and setuptools.  Then
check it out::

   % git clone git://github.com/ctb/edda.git
   % cd edda

Use a virtualenv to install everything necessary::

   % python2.6 -m virtualenv env
   % . env/bin/activate
   % easy_install sphinx

Assuming that succeeded, do:

   % cd doc
   % make html
   % python ../bin/serve-doc

...and then go to 'http://localhost:8555/'.
