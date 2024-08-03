
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.DJI.ACES_to_DLog_DGamut.a1.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to DJI DLog DGamut</ACESuserName>

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

// AP0 to D-Gamut matrix
const float AP0_TO_DGamut_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                  DJI_DGAMUT_PRI,
                                                                  CONE_RESP_MAT_CAT02);

float lin_to_DLog(float x)
{
  if (x <= 0.0078)
    return 6.025 * x + 0.0929;
  else
    return (log10(x * 0.9892 + 0.0108)) * 0.256663 + 0.584555;
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

  float linear_DGamut_rgb[3] = mult_f3_f33(ACES, AP0_TO_DGamut_MAT);

  float DLog_DGamut[3];
  DLog_DGamut[0] = lin_to_DLog(linear_DGamut_rgb[0]);
  DLog_DGamut[1] = lin_to_DLog(linear_DGamut_rgb[1]);
  DLog_DGamut[2] = lin_to_DLog(linear_DGamut_rgb[2]);

  rOut = DLog_DGamut[0];
  gOut = DLog_DGamut[1];
  bOut = DLog_DGamut[2];
  aOut = aIn;
}