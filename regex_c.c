#include <stdlib.h>
#include <regex.h>

const int reg_extended = REG_EXTENDED;
const int reg_icase = REG_ICASE;
const int reg_nosub = REG_NOSUB;
const int reg_newline = REG_NEWLINE;
const int reg_notbol = REG_NOTBOL;
const int reg_noteol = REG_NOTEOL;
const int reg_startend = REG_STARTEND;
const int reg_badbr = REG_BADBR;
const int reg_badpat = REG_BADPAT;
const int reg_badrpt = REG_BADRPT;
const int reg_ebrace = REG_EBRACE;
const int reg_ebrack = REG_EBRACK;
const int reg_ecollate = REG_ECOLLATE;
const int reg_ectype = REG_ECTYPE;
const int reg_eend = REG_EEND;
const int reg_eescape = REG_EESCAPE;
const int reg_eparen = REG_EPAREN;
const int reg_erange = REG_ERANGE;
const int reg_esize = REG_ESIZE;
const int reg_espace = REG_ESPACE;
const int reg_esubreg = REG_ESUBREG;

regex_t * alloc_regex_t() {
  return malloc(sizeof(regex_t));
}

