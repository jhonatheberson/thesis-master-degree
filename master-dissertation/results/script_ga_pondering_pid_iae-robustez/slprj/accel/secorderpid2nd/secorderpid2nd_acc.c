#include <math.h>
#include "secorderpid2nd_acc.h"
#include "secorderpid2nd_acc_private.h"
#include <stdio.h>
#include "slexec_vm_simstruct_bridge.h"
#include "slexec_vm_zc_functions.h"
#include "slexec_vm_lookup_functions.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "simtarget/slSimTgtMdlrefSfcnBridge.h"
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
#ifndef __RTW_UTFREE__  
extern void * utMalloc ( size_t ) ; extern void utFree ( void * ) ;
#endif
boolean_T secorderpid2nd_acc_rt_TDelayUpdateTailOrGrowBuf ( int_T * bufSzPtr
, int_T * tailPtr , int_T * headPtr , int_T * lastPtr , real_T tMinusDelay ,
real_T * * tBufPtr , real_T * * uBufPtr , real_T * * xBufPtr , boolean_T
isfixedbuf , boolean_T istransportdelay , int_T * maxNewBufSzPtr ) { int_T
testIdx ; int_T tail = * tailPtr ; int_T bufSz = * bufSzPtr ; real_T * tBuf =
* tBufPtr ; real_T * xBuf = ( NULL ) ; int_T numBuffer = 2 ; if (
istransportdelay ) { numBuffer = 3 ; xBuf = * xBufPtr ; } testIdx = ( tail <
( bufSz - 1 ) ) ? ( tail + 1 ) : 0 ; if ( ( tMinusDelay <= tBuf [ testIdx ] )
&& ! isfixedbuf ) { int_T j ; real_T * tempT ; real_T * tempU ; real_T *
tempX = ( NULL ) ; real_T * uBuf = * uBufPtr ; int_T newBufSz = bufSz + 1024
; if ( newBufSz > * maxNewBufSzPtr ) { * maxNewBufSzPtr = newBufSz ; } tempU
= ( real_T * ) utMalloc ( numBuffer * newBufSz * sizeof ( real_T ) ) ; if (
tempU == ( NULL ) ) { return ( false ) ; } tempT = tempU + newBufSz ; if (
istransportdelay ) tempX = tempT + newBufSz ; for ( j = tail ; j < bufSz ; j
++ ) { tempT [ j - tail ] = tBuf [ j ] ; tempU [ j - tail ] = uBuf [ j ] ; if
( istransportdelay ) tempX [ j - tail ] = xBuf [ j ] ; } for ( j = 0 ; j <
tail ; j ++ ) { tempT [ j + bufSz - tail ] = tBuf [ j ] ; tempU [ j + bufSz -
tail ] = uBuf [ j ] ; if ( istransportdelay ) tempX [ j + bufSz - tail ] =
xBuf [ j ] ; } if ( * lastPtr > tail ) { * lastPtr -= tail ; } else { *
lastPtr += ( bufSz - tail ) ; } * tailPtr = 0 ; * headPtr = bufSz ; utFree (
uBuf ) ; * bufSzPtr = newBufSz ; * tBufPtr = tempT ; * uBufPtr = tempU ; if (
istransportdelay ) * xBufPtr = tempX ; } else { * tailPtr = testIdx ; }
return ( true ) ; } real_T secorderpid2nd_acc_rt_TDelayInterpolate ( real_T
tMinusDelay , real_T tStart , real_T * tBuf , real_T * uBuf , int_T bufSz ,
int_T * lastIdx , int_T oldestIdx , int_T newIdx , real_T initOutput ,
boolean_T discrete , boolean_T minorStepAndTAtLastMajorOutput ) { int_T i ;
real_T yout , t1 , t2 , u1 , u2 ; if ( ( newIdx == 0 ) && ( oldestIdx == 0 )
&& ( tMinusDelay > tStart ) ) return initOutput ; if ( tMinusDelay <= tStart
) return initOutput ; if ( ( tMinusDelay <= tBuf [ oldestIdx ] ) ) { if (
discrete ) { return ( uBuf [ oldestIdx ] ) ; } else { int_T tempIdx =
oldestIdx + 1 ; if ( oldestIdx == bufSz - 1 ) tempIdx = 0 ; t1 = tBuf [
oldestIdx ] ; t2 = tBuf [ tempIdx ] ; u1 = uBuf [ oldestIdx ] ; u2 = uBuf [
tempIdx ] ; if ( t2 == t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else {
yout = u1 ; } } else { real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ;
real_T f2 = 1.0 - f1 ; yout = f1 * u1 + f2 * u2 ; } return yout ; } } if (
minorStepAndTAtLastMajorOutput ) { if ( newIdx != 0 ) { if ( * lastIdx ==
newIdx ) { ( * lastIdx ) -- ; } newIdx -- ; } else { if ( * lastIdx == newIdx
) { * lastIdx = bufSz - 1 ; } newIdx = bufSz - 1 ; } } i = * lastIdx ; if (
tBuf [ i ] < tMinusDelay ) { while ( tBuf [ i ] < tMinusDelay ) { if ( i ==
newIdx ) break ; i = ( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } } else { while
( tBuf [ i ] >= tMinusDelay ) { i = ( i > 0 ) ? i - 1 : ( bufSz - 1 ) ; } i =
( i < ( bufSz - 1 ) ) ? ( i + 1 ) : 0 ; } * lastIdx = i ; if ( discrete ) {
double tempEps = ( DBL_EPSILON ) * 128.0 ; double localEps = tempEps *
muDoubleScalarAbs ( tBuf [ i ] ) ; if ( tempEps > localEps ) { localEps =
tempEps ; } localEps = localEps / 2.0 ; if ( tMinusDelay >= ( tBuf [ i ] -
localEps ) ) { yout = uBuf [ i ] ; } else { if ( i == 0 ) { yout = uBuf [
bufSz - 1 ] ; } else { yout = uBuf [ i - 1 ] ; } } } else { if ( i == 0 ) {
t1 = tBuf [ bufSz - 1 ] ; u1 = uBuf [ bufSz - 1 ] ; } else { t1 = tBuf [ i -
1 ] ; u1 = uBuf [ i - 1 ] ; } t2 = tBuf [ i ] ; u2 = uBuf [ i ] ; if ( t2 ==
t1 ) { if ( tMinusDelay >= t2 ) { yout = u2 ; } else { yout = u1 ; } } else {
real_T f1 = ( t2 - tMinusDelay ) / ( t2 - t1 ) ; real_T f2 = 1.0 - f1 ; yout
= f1 * u1 + f2 * u2 ; } } return ( yout ) ; } void rt_ssGetBlockPath (
SimStruct * S , int_T sysIdx , int_T blkIdx , char_T * * path ) {
_ssGetBlockPath ( S , sysIdx , blkIdx , path ) ; } void rt_ssSet_slErrMsg (
SimStruct * S , void * diag ) { if ( ! _ssIsErrorStatusAslErrMsg ( S ) ) {
_ssSet_slErrMsg ( S , diag ) ; } else { _ssDiscardDiagnostic ( S , diag ) ; }
} void rt_ssReportDiagnosticAsWarning ( SimStruct * S , void * diag ) {
_ssReportDiagnosticAsWarning ( S , diag ) ; } static void mdlOutputs (
SimStruct * S , int_T tid ) { real_T B_0_9_0 [ 2 ] ; real_T * lastU ;
boolean_T tmp ; real_T B_0_0_0_idx_0 ; real_T B_0_0_0_idx_1 ; real_T
B_0_8_0_idx_0 ; int32_T isHit ; real_T tmp_0 ; B_secorderpid2nd_T * _rtB ;
P_secorderpid2nd_T * _rtP ; X_secorderpid2nd_T * _rtX ; DW_secorderpid2nd_T *
_rtDW ; _rtDW = ( ( DW_secorderpid2nd_T * ) ssGetRootDWork ( S ) ) ; _rtX = (
( X_secorderpid2nd_T * ) ssGetContStates ( S ) ) ; _rtP = ( (
P_secorderpid2nd_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( ( B_secorderpid2nd_T
* ) _ssGetModelBlockIO ( S ) ) ; B_0_0_0_idx_0 = _rtX -> x_CSTATE [ 0 ] ;
B_0_0_0_idx_1 = _rtX -> x_CSTATE [ 1 ] ; _rtB -> B_0_1_0 = _rtP -> P_1 [ 0 ]
* _rtX -> x_CSTATE [ 0 ] + _rtP -> P_1 [ 1 ] * _rtX -> x_CSTATE [ 1 ] ;
ssCallAccelRunBlock ( S , 0 , 2 , SS_CALL_MDL_OUTPUTS ) ; _rtB -> B_0_3_0 =
_rtX -> IAE_Comp_CSTATE ; ssCallAccelRunBlock ( S , 0 , 4 ,
SS_CALL_MDL_OUTPUTS ) ; isHit = ssIsSampleHit ( S , 1 , 0 ) ; if ( isHit != 0
) { _rtDW -> Referncia_MODE = ( ssGetTaskTime ( S , 1 ) >= _rtP -> P_3 ) ; if
( _rtDW -> Referncia_MODE == 1 ) { _rtB -> B_0_5_0 = _rtP -> P_5 ; } else {
_rtB -> B_0_5_0 = _rtP -> P_4 ; } } _rtB -> B_0_6_0 = _rtB -> B_0_5_0 - _rtB
-> B_0_1_0 ; if ( ssIsMajorTimeStep ( S ) != 0 ) { _rtDW -> Abs_MODE = ( _rtB
-> B_0_6_0 >= 0.0 ) ; } _rtB -> B_0_7_0 = _rtDW -> Abs_MODE > 0 ? _rtB ->
B_0_6_0 : - _rtB -> B_0_6_0 ; B_0_8_0_idx_0 = _rtP -> P_6 [ 0 ] *
B_0_0_0_idx_0 + _rtP -> P_6 [ 2 ] * B_0_0_0_idx_1 ; B_0_0_0_idx_1 = _rtP ->
P_6 [ 1 ] * B_0_0_0_idx_0 + _rtP -> P_6 [ 3 ] * B_0_0_0_idx_1 ; { real_T * *
uBuffer = ( real_T * * ) & _rtDW -> TransportDelay_PWORK . TUbufferPtrs [ 0 ]
; real_T * * tBuffer = ( real_T * * ) & _rtDW -> TransportDelay_PWORK .
TUbufferPtrs [ 2 ] ; real_T simTime = ssGetT ( S ) ; real_T tMinusDelay ; {
int_T i1 ; real_T * y0 = & B_0_9_0 [ 0 ] ; int_T * iw_Tail = & _rtDW ->
TransportDelay_IWORK . Tail [ 0 ] ; int_T * iw_Head = & _rtDW ->
TransportDelay_IWORK . Head [ 0 ] ; int_T * iw_Last = & _rtDW ->
TransportDelay_IWORK . Last [ 0 ] ; int_T * iw_CircularBufSize = & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 0 ] ; for ( i1 = 0 ; i1 < 2 ; i1 ++
) { tMinusDelay = ( ( _rtP -> P_7 > 0.0 ) ? _rtP -> P_7 : 0.0 ) ; tMinusDelay
= simTime - tMinusDelay ; y0 [ i1 ] = secorderpid2nd_acc_rt_TDelayInterpolate
( tMinusDelay , 0.0 , * tBuffer , * uBuffer , iw_CircularBufSize [ i1 ] , &
iw_Last [ i1 ] , iw_Tail [ i1 ] , iw_Head [ i1 ] , _rtP -> P_8 , 0 , (
boolean_T ) ( ssIsMinorTimeStep ( S ) && ( ssGetTimeOfLastOutput ( S ) ==
ssGetT ( S ) ) ) ) ; tBuffer ++ ; uBuffer ++ ; } } } _rtB -> B_0_11_0 [ 0 ] =
_rtX -> dotx_CSTATE [ 0 ] ; _rtB -> B_0_11_0 [ 1 ] = _rtX -> dotx_CSTATE [ 1
] ; _rtB -> B_0_16_0 = _rtP -> P_13 * _rtB -> B_0_6_0 ; if ( ( _rtDW ->
TimeStampA >= ssGetT ( S ) ) && ( _rtDW -> TimeStampB >= ssGetT ( S ) ) ) {
B_0_0_0_idx_0 = 0.0 ; } else { B_0_0_0_idx_0 = _rtDW -> TimeStampA ; lastU =
& _rtDW -> LastUAtTimeA ; if ( _rtDW -> TimeStampA < _rtDW -> TimeStampB ) {
if ( _rtDW -> TimeStampB < ssGetT ( S ) ) { B_0_0_0_idx_0 = _rtDW ->
TimeStampB ; lastU = & _rtDW -> LastUAtTimeB ; } } else { if ( _rtDW ->
TimeStampA >= ssGetT ( S ) ) { B_0_0_0_idx_0 = _rtDW -> TimeStampB ; lastU =
& _rtDW -> LastUAtTimeB ; } } B_0_0_0_idx_0 = ( _rtB -> B_0_16_0 - * lastU )
/ ( ssGetT ( S ) - B_0_0_0_idx_0 ) ; } B_0_0_0_idx_0 += _rtP -> P_11 * _rtB
-> B_0_6_0 + _rtX -> dotx1_CSTATE ; tmp = ( _rtP -> P_17 == 1 ) ; if ( tmp )
{ tmp_0 = 0.0 ; } else { tmp_0 = B_0_9_0 [ 0 ] ; } B_0_8_0_idx_0 = ( _rtP ->
P_10 [ 0 ] * _rtB -> B_0_11_0 [ 0 ] + _rtP -> P_10 [ 2 ] * _rtB -> B_0_11_0 [
1 ] ) + ( B_0_8_0_idx_0 + tmp_0 ) ; if ( tmp ) { tmp_0 = 0.0 ; } else { tmp_0
= B_0_9_0 [ 1 ] ; } B_0_0_0_idx_1 = ( _rtP -> P_10 [ 1 ] * _rtB -> B_0_11_0 [
0 ] + _rtP -> P_10 [ 3 ] * _rtB -> B_0_11_0 [ 1 ] ) + ( B_0_0_0_idx_1 + tmp_0
) ; _rtB -> B_0_19_0 [ 0 ] = 0.0 ; _rtB -> B_0_19_0 [ 0 ] += _rtP -> P_14 [ 0
] * B_0_8_0_idx_0 ; _rtB -> B_0_19_0 [ 0 ] += _rtP -> P_14 [ 2 ] *
B_0_0_0_idx_1 ; _rtB -> B_0_19_0 [ 1 ] = 0.0 ; _rtB -> B_0_19_0 [ 1 ] += _rtP
-> P_14 [ 1 ] * B_0_8_0_idx_0 ; _rtB -> B_0_19_0 [ 1 ] += _rtP -> P_14 [ 3 ]
* B_0_0_0_idx_1 ; _rtB -> B_0_20_0 [ 0 ] = _rtP -> P_15 [ 0 ] * B_0_0_0_idx_0
; _rtB -> B_0_20_0 [ 1 ] = _rtP -> P_15 [ 1 ] * B_0_0_0_idx_0 ; _rtB ->
B_0_21_0 = _rtP -> P_16 * _rtB -> B_0_6_0 ; UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { real_T * lastU ;
B_secorderpid2nd_T * _rtB ; P_secorderpid2nd_T * _rtP ; DW_secorderpid2nd_T *
_rtDW ; _rtDW = ( ( DW_secorderpid2nd_T * ) ssGetRootDWork ( S ) ) ; _rtP = (
( P_secorderpid2nd_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( (
B_secorderpid2nd_T * ) _ssGetModelBlockIO ( S ) ) ; { real_T * * uBuffer = (
real_T * * ) & _rtDW -> TransportDelay_PWORK . TUbufferPtrs [ 0 ] ; real_T *
* tBuffer = ( real_T * * ) & _rtDW -> TransportDelay_PWORK . TUbufferPtrs [ 2
] ; real_T simTime = ssGetT ( S ) ; _rtDW -> TransportDelay_IWORK . Head [ 0
] = ( ( _rtDW -> TransportDelay_IWORK . Head [ 0 ] < ( _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 0 ] - 1 ) ) ? ( _rtDW ->
TransportDelay_IWORK . Head [ 0 ] + 1 ) : 0 ) ; if ( _rtDW ->
TransportDelay_IWORK . Head [ 0 ] == _rtDW -> TransportDelay_IWORK . Tail [ 0
] ) { if ( ! secorderpid2nd_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 0 ] , & _rtDW ->
TransportDelay_IWORK . Tail [ 0 ] , & _rtDW -> TransportDelay_IWORK . Head [
0 ] , & _rtDW -> TransportDelay_IWORK . Last [ 0 ] , simTime - _rtP -> P_7 ,
tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 , false , & _rtDW ->
TransportDelay_IWORK . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ++ ) [ _rtDW ->
TransportDelay_IWORK . Head [ 0 ] ] = simTime ; ( * uBuffer ++ ) [ _rtDW ->
TransportDelay_IWORK . Head [ 0 ] ] = _rtB -> B_0_20_0 [ 0 ] ; _rtDW ->
TransportDelay_IWORK . Head [ 1 ] = ( ( _rtDW -> TransportDelay_IWORK . Head
[ 1 ] < ( _rtDW -> TransportDelay_IWORK . CircularBufSize [ 1 ] - 1 ) ) ? (
_rtDW -> TransportDelay_IWORK . Head [ 1 ] + 1 ) : 0 ) ; if ( _rtDW ->
TransportDelay_IWORK . Head [ 1 ] == _rtDW -> TransportDelay_IWORK . Tail [ 1
] ) { if ( ! secorderpid2nd_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
TransportDelay_IWORK . CircularBufSize [ 1 ] , & _rtDW ->
TransportDelay_IWORK . Tail [ 1 ] , & _rtDW -> TransportDelay_IWORK . Head [
1 ] , & _rtDW -> TransportDelay_IWORK . Last [ 1 ] , simTime - _rtP -> P_7 ,
tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 , false , & _rtDW ->
TransportDelay_IWORK . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ _rtDW ->
TransportDelay_IWORK . Head [ 1 ] ] = simTime ; ( * uBuffer ) [ _rtDW ->
TransportDelay_IWORK . Head [ 1 ] ] = _rtB -> B_0_20_0 [ 1 ] ; } if ( _rtDW
-> TimeStampA == ( rtInf ) ) { _rtDW -> TimeStampA = ssGetT ( S ) ; lastU = &
_rtDW -> LastUAtTimeA ; } else if ( _rtDW -> TimeStampB == ( rtInf ) ) {
_rtDW -> TimeStampB = ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeB ; } else
if ( _rtDW -> TimeStampA < _rtDW -> TimeStampB ) { _rtDW -> TimeStampA =
ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeA ; } else { _rtDW -> TimeStampB
= ssGetT ( S ) ; lastU = & _rtDW -> LastUAtTimeB ; } * lastU = _rtB ->
B_0_16_0 ; UNUSED_PARAMETER ( tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { B_secorderpid2nd_T * _rtB ;
XDot_secorderpid2nd_T * _rtXdot ; _rtXdot = ( ( XDot_secorderpid2nd_T * )
ssGetdX ( S ) ) ; _rtB = ( ( B_secorderpid2nd_T * ) _ssGetModelBlockIO ( S )
) ; _rtXdot -> x_CSTATE [ 0 ] = _rtB -> B_0_11_0 [ 0 ] ; _rtXdot -> x_CSTATE
[ 1 ] = _rtB -> B_0_11_0 [ 1 ] ; _rtXdot -> IAE_Comp_CSTATE = _rtB -> B_0_7_0
; _rtXdot -> dotx_CSTATE [ 0 ] = _rtB -> B_0_19_0 [ 0 ] ; _rtXdot ->
dotx_CSTATE [ 1 ] = _rtB -> B_0_19_0 [ 1 ] ; _rtXdot -> dotx1_CSTATE = _rtB
-> B_0_21_0 ; }
#define MDL_ZERO_CROSSINGS
static void mdlZeroCrossings ( SimStruct * S ) { B_secorderpid2nd_T * _rtB ;
P_secorderpid2nd_T * _rtP ; ZCV_secorderpid2nd_T * _rtZCSV ; _rtZCSV = ( (
ZCV_secorderpid2nd_T * ) ssGetSolverZcSignalVector ( S ) ) ; _rtP = ( (
P_secorderpid2nd_T * ) ssGetModelRtp ( S ) ) ; _rtB = ( ( B_secorderpid2nd_T
* ) _ssGetModelBlockIO ( S ) ) ; _rtZCSV -> Referncia_StepTime_ZC = ssGetT (
S ) - _rtP -> P_3 ; _rtZCSV -> Abs_AbsZc_ZC = _rtB -> B_0_6_0 ; } static void
mdlInitializeSizes ( SimStruct * S ) { ssSetChecksumVal ( S , 0 , 1373941556U
) ; ssSetChecksumVal ( S , 1 , 2770727641U ) ; ssSetChecksumVal ( S , 2 ,
4163405422U ) ; ssSetChecksumVal ( S , 3 , 2525848226U ) ; { mxArray *
slVerStructMat = NULL ; mxArray * slStrMat = mxCreateString ( "simulink" ) ;
char slVerChar [ 10 ] ; int status = mexCallMATLAB ( 1 , & slVerStructMat , 1
, & slStrMat , "ver" ) ; if ( status == 0 ) { mxArray * slVerMat = mxGetField
( slVerStructMat , 0 , "Version" ) ; if ( slVerMat == NULL ) { status = 1 ; }
else { status = mxGetString ( slVerMat , slVerChar , 10 ) ; } }
mxDestroyArray ( slStrMat ) ; mxDestroyArray ( slVerStructMat ) ; if ( (
status == 1 ) || ( strcmp ( slVerChar , "10.1" ) != 0 ) ) { return ; } }
ssSetOptions ( S , SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork (
S ) != sizeof ( DW_secorderpid2nd_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( B_secorderpid2nd_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
P_secorderpid2nd_T ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetModelRtp ( S , ( real_T *
) & secorderpid2nd_rtDefaultP ) ; rt_InitInfAndNaN ( sizeof ( real_T ) ) ; }
static void mdlInitializeSampleTimes ( SimStruct * S ) { } static void
mdlTerminate ( SimStruct * S ) { }
#include "simulink.c"
