/** *************************************************************************
    \fn ADM_mangle.h
    \brief Handle symbol mangling & register name for inline asm
                      
    copyright            : (C) 2008 by mean
    
 ***************************************************************************/
#pragma once

#include "ADM_coreConfig.h"
#ifdef _MSC_VER
#include "ADM_mangle_vs.h"
#else
#include "ADM_mangle_gcc.h"
#endif
