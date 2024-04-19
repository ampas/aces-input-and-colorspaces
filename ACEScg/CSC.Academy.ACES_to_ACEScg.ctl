
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACES_to_ACEScg.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to ACEScg</ACESuserName>

//
// ACES Color Space Conversion - ACES to ACEScg
//
// converts ACES2065-1 (AP0 w/ linear encoding) to 
//          ACEScg (AP1 w/ linear encoding)
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
    float ACES[3] = { rIn, gIn, bIn};

    float ACEScg[3] = mult_f3_f44( ACES, AP0_2_AP1_MAT);

    rOut = ACEScg[0];
    gOut = ACEScg[1];
    bOut = ACEScg[2];
    aOut = aIn;
}