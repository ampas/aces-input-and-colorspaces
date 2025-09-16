// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.DJI.DLog_DGamut_to_ACES.a1.v1</ACEStransformID>
// <ACESuserName>DJI DLog DGamut to ACES2065-1</ACESuserName>

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities DJI_DGAMUT_PRI =
    {
        {0.71, 0.31},
        {0.21, 0.88},
        {0.09, -0.08},
        {0.3127, 0.3290}};

// D-Gamut to AP0 matrix
const float DGamut_TO_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(DJI_DGAMUT_PRI,
                                                                  AP0,
                                                                  CONE_RESP_MAT_CAT02);

float DLog_to_lin(float x)
{
  if (x <= 0.14)
    return (x - 0.0929) / 6.025;
  else
    return (pow(10, (3.89616 * x - 2.27752)) - 0.0108) / 0.9892;
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
  float DLog_DGamut[3] = {rIn, gIn, bIn};

  float lin_DGamut[3];
  lin_DGamut[0] = DLog_to_lin(DLog_DGamut[0]);
  lin_DGamut[1] = DLog_to_lin(DLog_DGamut[1]);
  lin_DGamut[2] = DLog_to_lin(DLog_DGamut[2]);

  float ACES[3] = mult_f3_f33(lin_DGamut, DGamut_TO_AP0_MAT);

  rOut = ACES[0];
  gOut = ACES[1];
  bOut = ACES[2];
  aOut = aIn;
}