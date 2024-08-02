
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Canon.CLog3_CGamut_to_ACES.a1.v1</ACEStransformID>
// <ACESuserName>Canon Log 3 Cinema Gamut to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Canon Log 3 Cinema Gamut to ACES
//
// converts Canon Log 3 Cinema Gamut to
//          ACES2065-1 (AP0 w/ linear encoding)
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities CANON_CINEMA_GAMUT_PRI =
    {
        {0.7400, 0.2700},
        {0.1700, 1.1400},
        {0.0800, -0.1000},
        {0.3127, 0.3290}};

const float CGAMUT_to_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(CANON_CINEMA_GAMUT_PRI,
                                                                  AP0,
                                                                  CONE_RESP_MAT_CAT02);

float CLog3_to_lin(input varying float in)
{
    float out;
    if (in < 0.097465473)
    {
        out = -(pow(10, (0.12783901 - in) / 0.36726845) - 1) / 14.98325;
    }
    else if (in <= 0.15277891)
    {
        out = (in - 0.12512219) / 1.9754798;
    }
    else
    {
        out = (pow(10, (in - 0.12240537) / 0.36726845) - 1) / 14.98325;
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
    float lin_CGamut[3];
    lin_CGamut[0] = 0.9 * CLog3_to_lin(rIn);
    lin_CGamut[1] = 0.9 * CLog3_to_lin(gIn);
    lin_CGamut[2] = 0.9 * CLog3_to_lin(bIn);

    float ACES[3] = mult_f3_f33(lin_CGamut, CGAMUT_to_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}
