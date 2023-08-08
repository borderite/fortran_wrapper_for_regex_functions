program regex_test
  ! posix_regex_wrapper is the module for the wrapper functions.
  use posix_regex_wrapper
  implicit none
  ! preg: The first argument for regcomp, regexec, regfree
  ! functions. It is a pointer to regex_t structs on the C side. The
  ! regex_t sstruct is pretty complex and may depend on
  ! platforms. Also, we don't directly manipulate the struct
  ! members. So, we simply handle as a generic pointer, type(c_ptr),
  ! in our fortran code.
  type(c_ptr) :: preg
  ! nmatch is the third argument of regexec.
  integer(kind=c_size_t) :: nmatch
  ! pmatch is the fourth argument of regexec. It is a struct
  ! consisting of two int values on the C side. In our fortran code,
  ! it is a drived type, type(regmatch_t), consistenting of two
  ! integer(kind=c_int)'s. (See regex.f90.)
  type(regmatch_t), dimension(:), allocatable :: pmatch
  ! error_code receives the return value of regex. 
  integer(kind=c_int) :: error_code
  ! errbuf_size is the size of the buffer for the error message
  ! generated by regerror().
  integer(kind=c_size_t), parameter :: errbuf_size = 120_c_size_t
  ! errbuf is the buffer to which regerror() writes an error message.
  character(len=errbuf_size) :: errbuf
  ! msg_size receives the return value from regerror(), which is the
  ! length of the error message. Though we probably never need this
  ! value, we need something on the left hand side of the equality
  ! sign in calling a function in Fortran.
  integer(kind=c_size_t) :: msg_size
  ! This variable is used below in do loop.
  integer(kind=c_size_t) :: i
  !
  ! alloc_regex_t() dinamically allocate a memory for preg on the C
  ! side and returns the pointer to it. You normally need to call
  ! alloc_regex_t only once in a program. At the end of the program,
  ! you should call regfree and c_free as you see below.
  preg = alloc_regex_t()
  !
  ! Compile your regular expression and save the compiled result in
  ! the memory address pointed by preg. You can set the last parameter
  ! of regcomp() to a desired value using REG_EXTENDED, REG_ICASE,
  ! REG_NOSUB, and REG_NEWLINE, all of which are predefined in
  ! posix_wrapper_module. See the POSIX regex's manual for
  ! detains. Also, the returned value, error_code, can be compared
  ! against REG_BADBR, REG_BADPAT, etc, which are again predefined in
  ! the module. You can find all values in the POSIX regex' manual.
  error_code = regcomp(preg, &
       "^\([A-Z]\)[^.?!]*\([.?!]\)$", &
       0)
  if (error_code == 0) then
     print *, "The regular expression was successfully compiled."
  else
     print *, "Something went wrong in compiling the regular expression. See below."
     msg_size = regerror(error_code, preg, errbuf, errbuf_size)
     print *, errbuf(1:msg_size - 1)
  end if
  nmatch = 10
  allocate(pmatch(nmatch))
  error_code = regexec(preg, &
       "This is an example of *correct* sentence.", &
       nmatch, pmatch, 0)
  msg_size = regerror(error_code, preg, errbuf, errbuf_size)
  print *, errbuf(1:msg_size - 1)
  print *, "Here are the contents of the pmatch array."
  do i = 1, nmatch
     print *, pmatch(i)%rm_so, pmatch(i)%rm_eo
  end do
  ! To release the memories allocated by regexec, we have to call
  ! regfree().
  call regfree(preg)
  ! Also, we need to free the memory allocated for preg, too. The name
  ! of the function is c_free() rather than free(), because gfortran
  ! has a subroutine called free(). c_free() does nothing but calls c's
  ! free function.
  call c_free(preg)
end program regex_test
  
