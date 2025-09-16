// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Apple.AppleLog_BT2020_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>AppleLog Rec2020 to ACES2065-1</ACESuserName>

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities REC2020_PRI =
    {
        {0.70800, 0.29200},
        {0.17000, 0.79700},
        {0.13100, 0.04600},
        {0.31270, 0.32900}};

// ITU-R BT.2020 -to- ACES conversion matrix
const float REC2020_to_ACES_MAT[3][3] = calculate_rgb_to_rgb_matrix(REC2020_PRI,
                                                                    AP0);

float AppleLog_to_linear(float x)
{
    const float R_0 = -0.05641088;
    const float R_t = 0.01;
    const float c = 47.28711236;
    const float b = 0.00964052;
    const float g = 0.08550479;
    const float d = 0.69336945;
    const float P_t = c * pow((R_t - R_0), 2.0);

    if (x >= P_t)
    {
        return pow(2.0, (x - d) / g) - b;
    }
    else if (x < P_t && x >= 0.0)
    {
        return sqrt(x / c) + R_0;
    }
    else
    {
        return R_0;
    }
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
    float lin_2020[3];
    lin_2020[0] = AppleLog_to_linear(rIn);
    lin_2020[1] = AppleLog_to_linear(gIn);
    lin_2020[2] = AppleLog_to_linear(bIn);

    float ACES[3] = mult_f3_f33(lin_2020, REC2020_to_ACES_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}
