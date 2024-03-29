module posix_regex_wrapper
  use, intrinsic :: iso_c_binding
  private
  public :: c_ptr, c_int, c_size_t
  integer(c_int), bind(C), public :: REG_EXTENDED
  integer(c_int), bind(C), public :: REG_ICASE
  integer(c_int), bind(C), public :: REG_NOSUB
  integer(c_int), bind(C), public :: REG_NEWLINE
  integer(c_int), bind(C), public :: REG_NOTBOL
  integer(c_int), bind(C), public :: REG_NOTEOL
  integer(c_int), bind(C), public :: REG_STARTEND
  integer(c_int), bind(C), public :: REG_BADBR
  integer(c_int), bind(C), public :: REG_BADPAT
  integer(c_int), bind(C), public :: REG_BADRPT
  integer(c_int), bind(C), public :: REG_EBRACE
  integer(c_int), bind(C), public :: REG_EBRACK
  integer(c_int), bind(C), public :: REG_ECOLLATE
  integer(c_int), bind(C), public :: REG_ECTYPE
  integer(c_int), bind(C), public :: REG_EEND
  integer(c_int), bind(C), public :: REG_EESCAPE
  integer(c_int), bind(C), public :: REG_EPAREN
  integer(c_int), bind(C), public :: REG_ERANGE
  integer(c_int), bind(C), public :: REG_ESIZE
  integer(c_int), bind(C), public :: REG_ESPACE
  integer(c_int), bind(C), public :: REG_ESUBREG
  type, bind(C), public :: regmatch_t
     integer(kind=c_int) :: rm_so, rm_eo
  end type regmatch_t
  public :: alloc_regex_t, regcomp, regexec, regerror, regfree, c_free
  interface
     function alloc_regex_t() result (preg) bind(C, name = 'alloc_regex_t')
       import :: c_ptr
       implicit none
       type(c_ptr) :: preg
     end function alloc_regex_t
     subroutine regfree(preg) bind(C, name = 'regfree')
       import :: c_ptr
       implicit none
       type(c_ptr), value, intent(in) :: preg
     end subroutine regfree
     subroutine c_free(ptr) bind(C, name = 'free')
       import :: c_ptr
       implicit none
       type(c_ptr), value, intent(in) :: ptr
     end subroutine c_free
     function c_regcomp(preg, pattern, cflags) result(error_code) &
          bind(C, name = 'regcomp')
       import :: c_ptr, c_char, c_int
       implicit none
       type(c_ptr), value, intent(in) :: preg
       character(len=1, kind=c_char), dimension(*), intent(in) :: pattern
       integer(kind=c_int), value, intent(in) :: cflags
       integer(kind=c_int) :: error_code
     end function c_regcomp
     function c_regexec(preg, string, nmatch, pmatch, eflags) &
          result(error_code) bind(C, name = 'regexec')
       import :: c_ptr, c_char, c_int, c_size_t, regmatch_t
       implicit none
       type(c_ptr), value, intent(in) :: preg
       character(len=1, kind=c_char), dimension(*), intent(in) :: string
       integer(kind=c_size_t), value, intent(in):: nmatch
       type(regmatch_t), dimension(nmatch), intent(out) :: pmatch
       integer(kind=c_int), value, intent(in) :: eflags
       integer(kind=c_int) :: error_code
     end function c_regexec
     function regerror(errcode, preg, errbuf, errbuf_size) result(msg_size) &
          bind(C, name = 'regerror')
       import :: c_ptr, c_char, c_int, c_size_t
       integer(kind=c_int), value, intent(in) :: errcode
       type(c_ptr), value, intent(in) :: preg
       character(kind=c_char), dimension(*), intent(out) :: errbuf
       integer(kind=c_size_t), intent(in) :: errbuf_size
       integer(kind=c_size_t) :: msg_size
     end function regerror
  end interface
contains
  function c_string(string) result(res)
    character(*), intent(in) :: string
    character(:, kind=c_char), allocatable :: res
    res = string // c_null_char
  end function c_string
  function regcomp(preg, pattern, cflags) result(error_code)
    type(c_ptr), value, intent(in) :: preg
    character(*), intent(in) :: pattern
    integer(kind=c_int), intent(in) :: cflags
    integer(kind=c_int) :: error_code
    error_code = c_regcomp(preg, c_string(pattern), cflags)
  end function regcomp
  function regexec(preg, string, nmatch, pmatch, eflags) &
       result(error_code)
    type(c_ptr), value, intent(in) :: preg
    character(*), intent(in) :: string
    integer(kind=c_size_t), intent(in) :: nmatch
    type(regmatch_t), dimension(nmatch), intent(out) :: pmatch
    integer(kind=c_int), intent(in) :: eflags
    integer(kind=c_int) :: error_code
    integer(kind=c_size_t) :: i
    integer(kind=c_int) :: x
    error_code = c_regexec(preg, c_string(string), nmatch, pmatch, eflags)
    do i = 1_c_size_t, nmatch
       x = pmatch(i)%rm_so
       if (x >= 0) pmatch(i)%rm_so = x + 1
    end do
  end function regexec
end module posix_regex_wrapper

