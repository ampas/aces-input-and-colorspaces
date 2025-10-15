// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.LogC3-EI640_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ARRI LogC3 EI640 to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Arri LogC3 EI640 to ACES2065-1
//
// converts Arri LogC3 EI640 to
//          ACES2065-1 (AP0 w/ linear encoding)
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";
import "Lib.Arri.LogC3";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities ARRI_ALEXA_WG_PRI =
    {
        {0.68400, 0.31300},
        {0.22100, 0.84800},
        {0.08610, -0.10200},
        {0.31270, 0.32900}};

const float AWG3_to_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(ARRI_ALEXA_WG_PRI,
                                                                AP0,
                                                                CONE_RESP_MAT_CAT02);

const float EI = 640.0;

void main(input varying float rIn,
          input varying float gIn,
          input varying float bIn,
          input varying float aIn,
          output varying float rOut,
          output varying float gOut,
          output varying float bOut,
          output varying float aOut)
{
    float lin_AWG3[3];
    lin_AWG3[0] = normalizedLogC3ToRelativeExposure(rIn, EI);
    lin_AWG3[1] = normalizedLogC3ToRelativeExposure(gIn, EI);
    lin_AWG3[2] = normalizedLogC3ToRelativeExposure(bIn, EI);

    float ACES[3] = mult_f3_f33(lin_AWG3, AWG3_to_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}