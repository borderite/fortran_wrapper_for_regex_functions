CC = gcc
FC = gfortran
CCOPTIONS = -g -Wall
FCOPTIONS = -g -Wall
#OPTFLAGS = -O2 -fPIC
COPTFLAGS =
FOPTFLAGS =
LDOPTIONS = 

regex_test: regex_test.f90 regex.o regex_c.o
	gfortran $(FCOPTIONS) $(OPTFLAGS) $(LDOPTIONS) $^ -o $@

regex.o : regex.f90 regex_c.o
	gfortran -c $(FCOPTIONS) $(OPTFLAGS) $(LDOPTIONS) $<

regex_c.o : regex_c.c
	gcc -c $(CCOPTIONS) $(OPTFLAGS) $<

clean:
	rm -f *.o regex_test


