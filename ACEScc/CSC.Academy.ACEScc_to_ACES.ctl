
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACEScc_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ACEScc to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - ACEScc to ACES
//
// converts ACEScc (AP1 w/ ACESlog encoding) to 
//          ACES2065-1 (AP0 w/ linear encoding)
//
// This transform follows the formulas from section 4.4 in S-2014-003
//

// *-*-*-*-*-*-*-*-*
// ACEScc is intended to be transient and internal to software or hardware 
// systems, and is specifically not intended for interchange or archiving.
// ACEScc should NOT be written into a container file in actual implementations!
// *-*-*-*-*-*-*-*-*



import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";



float ACEScc_to_lin( input varying float in)
{
  if (in < -0.3013698630) // (9.72-15)/17.52
    return (pow( 2., in*17.52-9.72) - pow( 2.,-16.))*2.0;
  else if ( in < (log2(HALF_MAX)+9.72)/17.52 )
    return pow( 2., in*17.52-9.72);
  else // (in >= (log2(HALF_MAX)+9.72)/17.52)
    return HALF_MAX;
}



void main
(   
    input varying float rIn,
    input varying float gIn,
    input varying float bIn,
    input varying float aIn,
    output varying float rOut,
    output varying float gOut,
    output varying float bOut,
    output varying float aOut
)
{
    float lin_AP1[3];
    lin_AP1[0] = ACEScc_to_lin( rIn);
    lin_AP1[1] = ACEScc_to_lin( gIn);
    lin_AP1[2] = ACEScc_to_lin( bIn);

    float ACES[3] = mult_f3_f44( lin_AP1, AP1_2_AP0_MAT);
  
    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}