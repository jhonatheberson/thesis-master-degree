#ifndef RTW_HEADER_secorderpid2nd_acc_h_
#define RTW_HEADER_secorderpid2nd_acc_h_
#include <stddef.h>
#include <float.h>
#ifndef secorderpid2nd_acc_COMMON_INCLUDES_
#define secorderpid2nd_acc_COMMON_INCLUDES_
#include <stdlib.h>
#define S_FUNCTION_NAME simulink_only_sfcn 
#define S_FUNCTION_LEVEL 2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#endif
#include "secorderpid2nd_acc_types.h"
#include "multiword_types.h"
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include "rt_defines.h"
typedef struct { real_T B_0_1_0 ; real_T B_0_3_0 ; real_T B_0_5_0 ; real_T
B_0_6_0 ; real_T B_0_7_0 ; real_T B_0_11_0 [ 2 ] ; real_T B_0_16_0 ; real_T
B_0_19_0 [ 2 ] ; real_T B_0_20_0 [ 2 ] ; real_T B_0_21_0 ; }
B_secorderpid2nd_T ; typedef struct { real_T TimeStampA ; real_T LastUAtTimeA
; real_T TimeStampB ; real_T LastUAtTimeB ; struct { real_T modelTStart ; }
TransportDelay_RWORK ; void * Scope_PWORK ; void * ToWorkspace_PWORK ; struct
{ void * TUbufferPtrs [ 4 ] ; } TransportDelay_PWORK ; struct { int_T Tail [
2 ] ; int_T Head [ 2 ] ; int_T Last [ 2 ] ; int_T CircularBufSize [ 2 ] ;
int_T MaxNewBufSize ; } TransportDelay_IWORK ; int_T Referncia_MODE ; int_T
Abs_MODE ; char_T pad_Abs_MODE [ 4 ] ; } DW_secorderpid2nd_T ; typedef struct
{ real_T x_CSTATE [ 2 ] ; real_T IAE_Comp_CSTATE ; real_T dotx_CSTATE [ 2 ] ;
real_T dotx1_CSTATE ; } X_secorderpid2nd_T ; typedef struct { real_T x_CSTATE
[ 2 ] ; real_T IAE_Comp_CSTATE ; real_T dotx_CSTATE [ 2 ] ; real_T
dotx1_CSTATE ; } XDot_secorderpid2nd_T ; typedef struct { boolean_T x_CSTATE
[ 2 ] ; boolean_T IAE_Comp_CSTATE ; boolean_T dotx_CSTATE [ 2 ] ; boolean_T
dotx1_CSTATE ; } XDis_secorderpid2nd_T ; typedef struct { real_T x_CSTATE [ 2
] ; real_T IAE_Comp_CSTATE ; real_T dotx_CSTATE [ 2 ] ; real_T dotx1_CSTATE ;
} CStateAbsTol_secorderpid2nd_T ; typedef struct { real_T x_CSTATE [ 2 ] ;
real_T IAE_Comp_CSTATE ; real_T dotx_CSTATE [ 2 ] ; real_T dotx1_CSTATE ; }
CXPtMin_secorderpid2nd_T ; typedef struct { real_T x_CSTATE [ 2 ] ; real_T
IAE_Comp_CSTATE ; real_T dotx_CSTATE [ 2 ] ; real_T dotx1_CSTATE ; }
CXPtMax_secorderpid2nd_T ; typedef struct { real_T Referncia_StepTime_ZC ;
real_T Abs_AbsZc_ZC ; } ZCV_secorderpid2nd_T ; typedef struct { ZCSigState
Referncia_StepTime_ZCE ; ZCSigState Abs_AbsZc_ZCE ; }
PrevZCX_secorderpid2nd_T ; struct P_secorderpid2nd_T_ { real_T P_0 [ 2 ] ;
real_T P_1 [ 2 ] ; real_T P_2 ; real_T P_3 ; real_T P_4 ; real_T P_5 ; real_T
P_6 [ 4 ] ; real_T P_7 ; real_T P_8 ; real_T P_9 [ 2 ] ; real_T P_10 [ 4 ] ;
real_T P_11 ; real_T P_12 ; real_T P_13 ; real_T P_14 [ 4 ] ; real_T P_15 [ 2
] ; real_T P_16 ; uint8_T P_17 ; char_T pad_P_17 [ 7 ] ; } ; extern
P_secorderpid2nd_T secorderpid2nd_rtDefaultP ;
#endif
