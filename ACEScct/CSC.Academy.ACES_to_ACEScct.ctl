
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACES_to_ACEScct.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to ACEScct</ACESuserName>

//
// ACES Color Space Conversion - ACES to ACEScct
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          ACEScct (AP1 w/ logarithmic encoding)
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

const float AP0_to_AP1_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                               AP1);

const float X_BRK = 0.0078125;
const float Y_BRK = 0.155251141552511;
const float A = 10.5402377416545;
const float B = 0.0729055341958355;

float lin_to_ACEScct(float in)
{
    if (in <= X_BRK)
        return A * in + B;
    else // (in > X_BRK)
        return (log2(in) + 9.72) / 17.52;
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
    float ACES[3] = {rIn, gIn, bIn};

    float lin_AP1[3] = mult_f3_f33(ACES, AP0_to_AP1_MAT);

    rOut = lin_to_ACEScct(lin_AP1[0]);
    gOut = lin_to_ACEScct(lin_AP1[1]);
    bOut = lin_to_ACEScct(lin_AP1[2]);
    aOut = aIn;
}