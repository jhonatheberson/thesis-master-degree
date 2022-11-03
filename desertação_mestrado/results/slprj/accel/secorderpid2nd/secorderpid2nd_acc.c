#include "__cf_secorderpid2nd.h"
#include <math.h>
#include "secorderpid2nd_acc.h"
#include "secorderpid2nd_acc_private.h"
#include <stdio.h>
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
= f1 * u1 + f2 * u2 ; } } return ( yout ) ; } static void mdlOutputs (
SimStruct * S , int_T tid ) { real_T ansdzies15 [ 2 ] ; real_T jn21tkjnfo ;
real_T * lastU ; real_T o2ud1dgl1x ; real_T dxzjs15541 ; real_T eh5ynv0hnp ;
real_T m1ajipvbw2_idx_0 ; dicgcg1lx1 * _rtB ; ahtpg2szbn * _rtP ; lo2jwq1bg0
* _rtDW ; _rtDW = ( ( lo2jwq1bg0 * ) ssGetRootDWork ( S ) ) ; _rtP = ( (
ahtpg2szbn * ) ssGetDefaultParam ( S ) ) ; _rtB = ( ( dicgcg1lx1 * )
_ssGetBlockIO ( S ) ) ; ansdzies15 [ 0 ] = ( ( p30pwn5bkq * ) ssGetContStates
( S ) ) -> lonu5kb11l [ 0 ] ; ansdzies15 [ 1 ] = ( ( p30pwn5bkq * )
ssGetContStates ( S ) ) -> lonu5kb11l [ 1 ] ; _rtB -> oue5why5hp = _rtP ->
P_1 [ 0 ] * ansdzies15 [ 0 ] + _rtP -> P_1 [ 1 ] * ansdzies15 [ 1 ] ;
ssCallAccelRunBlock ( S , 0 , 2 , SS_CALL_MDL_OUTPUTS ) ; _rtB -> aebywgdsl3
= ( ( p30pwn5bkq * ) ssGetContStates ( S ) ) -> np5tbyhx3j ;
ssCallAccelRunBlock ( S , 0 , 4 , SS_CALL_MDL_OUTPUTS ) ; if ( ssIsSampleHit
( S , 1 , 0 ) ) { _rtDW -> nawri3pupq = ( ssGetTaskTime ( S , 1 ) >= _rtP ->
P_3 ) ; if ( _rtDW -> nawri3pupq == 1 ) { _rtB -> nsqpwzyfkt = _rtP -> P_5 ;
} else { _rtB -> nsqpwzyfkt = _rtP -> P_4 ; } } _rtB -> e3zebwjzyr = _rtB ->
nsqpwzyfkt - _rtB -> oue5why5hp ; if ( ssIsMajorTimeStep ( S ) ) { _rtDW ->
jylcmfiecz = ( _rtB -> e3zebwjzyr >= 0.0 ) ; } _rtB -> hvoghdhvbp = _rtDW ->
jylcmfiecz > 0 ? _rtB -> e3zebwjzyr : - _rtB -> e3zebwjzyr ; m1ajipvbw2_idx_0
= _rtP -> P_6 [ 0 ] * ansdzies15 [ 0 ] + _rtP -> P_6 [ 2 ] * ansdzies15 [ 1 ]
; eh5ynv0hnp = _rtP -> P_6 [ 1 ] * ansdzies15 [ 0 ] + _rtP -> P_6 [ 3 ] *
ansdzies15 [ 1 ] ; { real_T * * uBuffer = ( real_T * * ) & _rtDW ->
pe00nwbcvz . TUbufferPtrs [ 0 ] ; real_T * * tBuffer = ( real_T * * ) & _rtDW
-> pe00nwbcvz . TUbufferPtrs [ 2 ] ; real_T simTime = ssGetT ( S ) ; real_T
tMinusDelay ; { int_T i1 ; real_T * y0 = & _rtB -> h4swn4t5mq [ 0 ] ; int_T *
iw_Tail = & _rtDW -> dnd10n3o4o . Tail [ 0 ] ; int_T * iw_Head = & _rtDW ->
dnd10n3o4o . Head [ 0 ] ; int_T * iw_Last = & _rtDW -> dnd10n3o4o . Last [ 0
] ; int_T * iw_CircularBufSize = & _rtDW -> dnd10n3o4o . CircularBufSize [ 0
] ; for ( i1 = 0 ; i1 < 2 ; i1 ++ ) { tMinusDelay = ( ( _rtP -> P_7 > 0.0 ) ?
_rtP -> P_7 : 0.0 ) ; tMinusDelay = simTime - tMinusDelay ; y0 [ i1 ] =
secorderpid2nd_acc_rt_TDelayInterpolate ( tMinusDelay , 0.0 , * tBuffer , *
uBuffer , iw_CircularBufSize [ i1 ] , & iw_Last [ i1 ] , iw_Tail [ i1 ] ,
iw_Head [ i1 ] , _rtP -> P_8 , 0 , ( boolean_T ) ( ssIsMinorTimeStep ( S ) &&
( ssGetTimeOfLastOutput ( S ) == ssGetT ( S ) ) ) ) ; tBuffer ++ ; uBuffer ++
; } } } ssCallAccelRunBlock ( S , 0 , 10 , SS_CALL_MDL_OUTPUTS ) ; _rtB ->
o200211ph5 [ 0 ] = ( ( p30pwn5bkq * ) ssGetContStates ( S ) ) -> gqkxslnh23 [
0 ] ; _rtB -> o200211ph5 [ 1 ] = ( ( p30pwn5bkq * ) ssGetContStates ( S ) )
-> gqkxslnh23 [ 1 ] ; ansdzies15 [ 0 ] = 0.0 ; ansdzies15 [ 0 ] += _rtP ->
P_10 [ 0 ] * _rtB -> o200211ph5 [ 0 ] ; ansdzies15 [ 0 ] += _rtP -> P_10 [ 2
] * _rtB -> o200211ph5 [ 1 ] ; ansdzies15 [ 1 ] = 0.0 ; ansdzies15 [ 1 ] +=
_rtP -> P_10 [ 1 ] * _rtB -> o200211ph5 [ 0 ] ; ansdzies15 [ 1 ] += _rtP ->
P_10 [ 3 ] * _rtB -> o200211ph5 [ 1 ] ; m1ajipvbw2_idx_0 = ( m1ajipvbw2_idx_0
+ _rtB -> h4swn4t5mq [ 0 ] ) + ansdzies15 [ 0 ] ; eh5ynv0hnp = ( eh5ynv0hnp +
_rtB -> h4swn4t5mq [ 1 ] ) + ansdzies15 [ 1 ] ; o2ud1dgl1x = _rtP -> P_11 *
_rtB -> e3zebwjzyr ; jn21tkjnfo = ( ( p30pwn5bkq * ) ssGetContStates ( S ) )
-> lj4wnam0b5 ; _rtB -> mfbkdd4rh2 = _rtP -> P_13 * _rtB -> e3zebwjzyr ; if (
( _rtDW -> o2dlqzwkec >= ssGetT ( S ) ) && ( _rtDW -> flfhkiwtms >= ssGetT (
S ) ) ) { dxzjs15541 = 0.0 ; } else { dxzjs15541 = _rtDW -> o2dlqzwkec ;
lastU = & _rtDW -> ecovxx35em ; if ( _rtDW -> o2dlqzwkec < _rtDW ->
flfhkiwtms ) { if ( _rtDW -> flfhkiwtms < ssGetT ( S ) ) { dxzjs15541 = _rtDW
-> flfhkiwtms ; lastU = & _rtDW -> bdtewvbgw2 ; } } else { if ( _rtDW ->
o2dlqzwkec >= ssGetT ( S ) ) { dxzjs15541 = _rtDW -> flfhkiwtms ; lastU = &
_rtDW -> bdtewvbgw2 ; } } dxzjs15541 = ( _rtB -> mfbkdd4rh2 - * lastU ) / (
ssGetT ( S ) - dxzjs15541 ) ; } jn21tkjnfo = ( o2ud1dgl1x + jn21tkjnfo ) +
dxzjs15541 ; _rtB -> fbqc4jezfw [ 0 ] = 0.0 ; _rtB -> fbqc4jezfw [ 0 ] +=
_rtP -> P_14 [ 0 ] * m1ajipvbw2_idx_0 ; _rtB -> fbqc4jezfw [ 0 ] += _rtP ->
P_14 [ 2 ] * eh5ynv0hnp ; _rtB -> fbqc4jezfw [ 1 ] = 0.0 ; _rtB -> fbqc4jezfw
[ 1 ] += _rtP -> P_14 [ 1 ] * m1ajipvbw2_idx_0 ; _rtB -> fbqc4jezfw [ 1 ] +=
_rtP -> P_14 [ 3 ] * eh5ynv0hnp ; _rtB -> mpfkvwmwex [ 0 ] = _rtP -> P_15 [ 0
] * jn21tkjnfo ; _rtB -> mpfkvwmwex [ 1 ] = _rtP -> P_15 [ 1 ] * jn21tkjnfo ;
_rtB -> covgaipknl = _rtP -> P_16 * _rtB -> e3zebwjzyr ; UNUSED_PARAMETER (
tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { real_T * lastU ;
dicgcg1lx1 * _rtB ; ahtpg2szbn * _rtP ; lo2jwq1bg0 * _rtDW ; _rtDW = ( (
lo2jwq1bg0 * ) ssGetRootDWork ( S ) ) ; _rtP = ( ( ahtpg2szbn * )
ssGetDefaultParam ( S ) ) ; _rtB = ( ( dicgcg1lx1 * ) _ssGetBlockIO ( S ) ) ;
{ real_T * * uBuffer = ( real_T * * ) & _rtDW -> pe00nwbcvz . TUbufferPtrs [
0 ] ; real_T * * tBuffer = ( real_T * * ) & _rtDW -> pe00nwbcvz .
TUbufferPtrs [ 2 ] ; real_T simTime = ssGetT ( S ) ; _rtDW -> dnd10n3o4o .
Head [ 0 ] = ( ( _rtDW -> dnd10n3o4o . Head [ 0 ] < ( _rtDW -> dnd10n3o4o .
CircularBufSize [ 0 ] - 1 ) ) ? ( _rtDW -> dnd10n3o4o . Head [ 0 ] + 1 ) : 0
) ; if ( _rtDW -> dnd10n3o4o . Head [ 0 ] == _rtDW -> dnd10n3o4o . Tail [ 0 ]
) { if ( ! secorderpid2nd_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
dnd10n3o4o . CircularBufSize [ 0 ] , & _rtDW -> dnd10n3o4o . Tail [ 0 ] , &
_rtDW -> dnd10n3o4o . Head [ 0 ] , & _rtDW -> dnd10n3o4o . Last [ 0 ] ,
simTime - _rtP -> P_7 , tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 ,
false , & _rtDW -> dnd10n3o4o . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ++ ) [ _rtDW ->
dnd10n3o4o . Head [ 0 ] ] = simTime ; ( * uBuffer ++ ) [ _rtDW -> dnd10n3o4o
. Head [ 0 ] ] = _rtB -> mpfkvwmwex [ 0 ] ; _rtDW -> dnd10n3o4o . Head [ 1 ]
= ( ( _rtDW -> dnd10n3o4o . Head [ 1 ] < ( _rtDW -> dnd10n3o4o .
CircularBufSize [ 1 ] - 1 ) ) ? ( _rtDW -> dnd10n3o4o . Head [ 1 ] + 1 ) : 0
) ; if ( _rtDW -> dnd10n3o4o . Head [ 1 ] == _rtDW -> dnd10n3o4o . Tail [ 1 ]
) { if ( ! secorderpid2nd_acc_rt_TDelayUpdateTailOrGrowBuf ( & _rtDW ->
dnd10n3o4o . CircularBufSize [ 1 ] , & _rtDW -> dnd10n3o4o . Tail [ 1 ] , &
_rtDW -> dnd10n3o4o . Head [ 1 ] , & _rtDW -> dnd10n3o4o . Last [ 1 ] ,
simTime - _rtP -> P_7 , tBuffer , uBuffer , ( NULL ) , ( boolean_T ) 0 ,
false , & _rtDW -> dnd10n3o4o . MaxNewBufSize ) ) { ssSetErrorStatus ( S ,
"tdelay memory allocation error" ) ; return ; } } ( * tBuffer ) [ _rtDW ->
dnd10n3o4o . Head [ 1 ] ] = simTime ; ( * uBuffer ) [ _rtDW -> dnd10n3o4o .
Head [ 1 ] ] = _rtB -> mpfkvwmwex [ 1 ] ; } if ( _rtDW -> o2dlqzwkec == (
rtInf ) ) { _rtDW -> o2dlqzwkec = ssGetT ( S ) ; lastU = & _rtDW ->
ecovxx35em ; } else if ( _rtDW -> flfhkiwtms == ( rtInf ) ) { _rtDW ->
flfhkiwtms = ssGetT ( S ) ; lastU = & _rtDW -> bdtewvbgw2 ; } else if ( _rtDW
-> o2dlqzwkec < _rtDW -> flfhkiwtms ) { _rtDW -> o2dlqzwkec = ssGetT ( S ) ;
lastU = & _rtDW -> ecovxx35em ; } else { _rtDW -> flfhkiwtms = ssGetT ( S ) ;
lastU = & _rtDW -> bdtewvbgw2 ; } * lastU = _rtB -> mfbkdd4rh2 ;
UNUSED_PARAMETER ( tid ) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { dicgcg1lx1 * _rtB ; ahtpg2szbn
* _rtP ; _rtP = ( ( ahtpg2szbn * ) ssGetDefaultParam ( S ) ) ; _rtB = ( (
dicgcg1lx1 * ) _ssGetBlockIO ( S ) ) ; { ( ( nhh1hilzkd * ) ssGetdX ( S ) )
-> lonu5kb11l [ 0 ] = _rtB -> o200211ph5 [ 0 ] ; ( ( nhh1hilzkd * ) ssGetdX (
S ) ) -> lonu5kb11l [ 1 ] = _rtB -> o200211ph5 [ 1 ] ; } { ( ( nhh1hilzkd * )
ssGetdX ( S ) ) -> np5tbyhx3j = _rtB -> hvoghdhvbp ; } { ( ( nhh1hilzkd * )
ssGetdX ( S ) ) -> gqkxslnh23 [ 0 ] = _rtB -> fbqc4jezfw [ 0 ] ; ( (
nhh1hilzkd * ) ssGetdX ( S ) ) -> gqkxslnh23 [ 1 ] = _rtB -> fbqc4jezfw [ 1 ]
; } { ( ( nhh1hilzkd * ) ssGetdX ( S ) ) -> lj4wnam0b5 = _rtB -> covgaipknl ;
} }
#define MDL_ZERO_CROSSINGS
static void mdlZeroCrossings ( SimStruct * S ) { dicgcg1lx1 * _rtB ;
ahtpg2szbn * _rtP ; eghux0pmr3 * _rtZCSV ; _rtZCSV = ( ( eghux0pmr3 * )
ssGetSolverZcSignalVector ( S ) ) ; _rtP = ( ( ahtpg2szbn * )
ssGetDefaultParam ( S ) ) ; _rtB = ( ( dicgcg1lx1 * ) _ssGetBlockIO ( S ) ) ;
_rtZCSV -> omewslx32t = ssGetT ( S ) - _rtP -> P_3 ; _rtZCSV -> e25aybzuuu =
_rtB -> e3zebwjzyr ; } static void mdlInitializeSizes ( SimStruct * S ) {
ssSetChecksumVal ( S , 0 , 2860379482U ) ; ssSetChecksumVal ( S , 1 ,
4165526610U ) ; ssSetChecksumVal ( S , 2 , 3375426071U ) ; ssSetChecksumVal (
S , 3 , 2888086143U ) ; { mxArray * slVerStructMat = NULL ; mxArray *
slStrMat = mxCreateString ( "simulink" ) ; char slVerChar [ 10 ] ; int status
= mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat , "ver" ) ; if (
status == 0 ) { mxArray * slVerMat = mxGetField ( slVerStructMat , 0 ,
"Version" ) ; if ( slVerMat == NULL ) { status = 1 ; } else { status =
mxGetString ( slVerMat , slVerChar , 10 ) ; } } mxDestroyArray ( slStrMat ) ;
mxDestroyArray ( slVerStructMat ) ; if ( ( status == 1 ) || ( strcmp (
slVerChar , "8.5" ) != 0 ) ) { return ; } } ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork ( S ) != sizeof (
lo2jwq1bg0 ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( dicgcg1lx1 ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
ahtpg2szbn ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetDefaultParam ( S , (
real_T * ) & ah2sj0g0wm ) ; rt_InitInfAndNaN ( sizeof ( real_T ) ) ; } static
void mdlInitializeSampleTimes ( SimStruct * S ) { } static void mdlTerminate
( SimStruct * S ) { }
#include "simulink.c"
