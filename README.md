# Fortran wrapper for POSIX regex functions

With the codes provided here, your Fortran program can call POSIX regex functions in the C libraries. If you are familiar with the POSIX regex functions (regcomp, regexec, regerror, regfree), regex_test.f90 and Makefile should give you a pretty good idea on how to use the codes.

Note: rm_so and rm_eo in type(regmatch_t) are 1-based indices, not
0-based as in the regmatch_t struct in c. Also, rm_eo is the index for
the last matched character, not the one after the last character.
