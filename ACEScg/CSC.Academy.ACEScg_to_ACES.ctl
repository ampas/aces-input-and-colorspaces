
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACEScg_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ACEScg to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - ACEScg to ACES
//
// converts ACEScg (AP1 w/ linear encoding) to
//          ACES2065-1 (AP0 w/ linear encoding)
//



import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";



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
    float ACEScg[3] = { rIn, gIn, bIn};

    float ACES[3] = mult_f3_f44( ACEScg, AP1_2_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}