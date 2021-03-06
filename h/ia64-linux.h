#include "linux.h"

#undef MPROTECT_ACTION_FLAGS
#define MPROTECT_ACTION_FLAGS SA_RESTART|SA_SIGINFO
#ifdef IN_GBC
#define GET_FAULT_ADDR(sig,code,scp,addr) \
  ((siginfo_t *)code )->si_addr
#endif
/* #define SGC *//*FIXME ia64 specific fread/getc restart failure and hang*/

#define STATIC_FUNCTION_POINTERS
#define BRK_DOES_NOT_GUARANTEE_ALLOCATION

#define NOFREE_ERR
