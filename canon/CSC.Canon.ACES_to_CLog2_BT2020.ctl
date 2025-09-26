// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Canon.ACES_to_CLog2_BT2020.a1.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Canon Log 2 BT.2020</ACESuserName>

//
// ACES Color Space Conversion - ACES to Canon Log 2 BT.2020
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Canon Log 2 BT.2020
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities BT2020_PRI =
    {
        {0.70800, 0.29200},
        {0.17000, 0.79700},
        {0.13100, 0.04600},
        {0.31270, 0.32900}};

const float AP0_to_BT2020_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                  BT2020_PRI,
                                                                  CONE_RESP_MAT_CAT02);

float lin_to_CLog2(input varying float in)
{
    float out;
    if (in < 0)
    {
        out = -0.24136077 * log10(1 - 87.099375 * in) + 0.092864125;
    }
    else
    {
        out = 0.24136077 * log10(87.099375 * in + 1) + 0.092864125;
    }
    return out;
}

void main(input varying float rIn,
          input varying float gIn,
          input varying float bIn,
          input varying float aIn,
          output varying float rOut,
          output varying float gOut,
          output varying float bOut,
          output varying float aOut)
{
    float ACES[3] = {rIn, gIn, bIn};

    float lin_CGamut[3] = mult_f3_f33(ACES, AP0_to_BT2020_MAT);

    rOut = lin_to_CLog2(lin_CGamut[0] / 0.9);
    gOut = lin_to_CLog2(lin_CGamut[1] / 0.9);
    bOut = lin_to_CLog2(lin_CGamut[2] / 0.9);
    aOut = aIn;
}
