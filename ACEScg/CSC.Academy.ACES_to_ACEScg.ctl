// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

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

    float ACEScg[3] = mult_f3_f33(ACES, AP0_to_AP1_MAT);

    rOut = ACEScg[0];
    gOut = ACEScg[1];
    bOut = ACEScg[2];
    aOut = aIn;
}