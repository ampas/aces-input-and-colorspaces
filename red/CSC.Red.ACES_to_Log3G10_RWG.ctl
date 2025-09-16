// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Red.ACES_to_Log3G10_RWG.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to RED Log3G10 REDWideGamutRGB</ACESuserName>

//
// ACES Color Space Conversion - ACES to RED Log3G10 REDWideGamutRGB
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          RED Log3G10 REDWideGamutRGB
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities RED_WIDEGAMUTRGB_PRI =
    {
        {0.780308, 0.304253},
        {0.121595, 1.493994},
        {0.095612, -0.084589},
        {0.3127, 0.3290}};

const float AP0_2_RWG_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                              RED_WIDEGAMUTRGB_PRI);

const float a = 0.224282;
const float b = 155.975327;
const float c = 0.01;
const float g = 15.1927;

float lin_to_Log3G10(input varying float in)
{
    float out = in + c;
    if (out < 0.0)
    {
        out = out * g;
    }
    else
    {
        out = a * log10((out * b) + 1.0);
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

    float lin_RWG[3] = mult_f3_f33(ACES, AP0_2_RWG_MAT);

    rOut = lin_to_Log3G10(lin_RWG[0]);
    gOut = lin_to_Log3G10(lin_RWG[1]);
    bOut = lin_to_Log3G10(lin_RWG[2]);
    aOut = aIn;
}