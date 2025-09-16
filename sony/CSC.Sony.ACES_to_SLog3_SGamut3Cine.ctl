// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Sony.ACES_to_SLog3_SGamut3Cine.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Sony S-Log3 S-Gamut3.Cine</ACESuserName>

//
// ACES Color Space Conversion - ACES to Sony S-Log3 S-Gamut3.Cine
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Sony S-Log3 S-Gamut3.Cine
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities SONY_SGAMUT3_CINE_PRI =
    {
        {0.766, 0.275},
        {0.225, 0.800},
        {0.089, -0.087},
        {0.3127, 0.3290}};

const float AP0_2_SGAMUT3_CINE_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                       SONY_SGAMUT3_CINE_PRI,
                                                                       CONE_RESP_MAT_CAT02);

float lin_to_SLog3(input varying float in)
{
    float out;
    if (in >= 0.01125000)
    {
        out = (420.0 + log10((in + 0.01) / (0.18 + 0.01)) * 261.5) / 1023.0;
    }
    else
    {
        out = (in * (171.2102946929 - 95.0) / 0.01125000 + 95.0) / 1023.0;
    }
    return out;
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

    float lin_SGamut3Cine[3] = mult_f3_f33(ACES, AP0_2_SGAMUT3_CINE_MAT);

    rOut = lin_to_SLog3(lin_SGamut3Cine[0]);
    gOut = lin_to_SLog3(lin_SGamut3Cine[1]);
    bOut = lin_to_SLog3(lin_SGamut3Cine[2]);
    aOut = aIn;
}