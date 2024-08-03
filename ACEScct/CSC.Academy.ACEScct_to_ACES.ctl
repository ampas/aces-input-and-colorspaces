
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACEScct_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ACEScct to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - ACEScct to ACES
//
// converts ACEScct (AP1 w/ ACESlog encoding) to
//          ACES2065-1 (AP0 w/ linear encoding)
//

// *-*-*-*-*-*-*-*-*
// ACEScct is intended to be transient and internal to software or hardware
// systems, and is specifically not intended for interchange or archiving.
// ACEScct should NOT be written into a container file in actual implementations!
// *-*-*-*-*-*-*-*-*

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities AP1 = // Working space primaries for ACES
    {
        {0.713, 0.293},
        {0.165, 0.830},
        {0.128, 0.044},
        {0.32168, 0.33767}};

const float AP1_to_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP1,
                                                               AP0);

const float X_BRK = 0.0078125;
const float Y_BRK = 0.155251141552511;
const float A = 10.5402377416545;
const float B = 0.0729055341958355;

float ACEScct_to_lin(float in)
{
    if (in > Y_BRK)
        return pow(2., in * 17.52 - 9.72);
    else
        return (in - B) / A;
}

void main(
    input varying float rIn,
    input varying float gIn,
    input varying float bIn,
    input varying float aIn,
    output varying float rOut,
    output varying float gOut,
    output varying float bOut,
    output varying float aOut)
{
    float lin_AP1[3];
    lin_AP1[0] = ACEScct_to_lin(rIn);
    lin_AP1[1] = ACEScct_to_lin(gIn);
    lin_AP1[2] = ACEScct_to_lin(bIn);

    float ACES[3] = mult_f3_f33(lin_AP1, AP1_to_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}