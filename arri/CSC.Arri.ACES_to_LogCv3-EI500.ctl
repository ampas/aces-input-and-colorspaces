// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.ACES_to_LogC3-EI500.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to ARRI LogC3 EI500</ACESuserName>

//
// ACES Color Space Conversion - ACES2065-1 to Arri LogC3 EI500
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Arri LogC3 EI500
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

const float AP0_to_AWG3_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                ARRI_ALEXA_WG_PRI,
                                                                CONE_RESP_MAT_CAT02);

const float EI = 500.0;

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

    float lin_AWG3[3] = mult_f3_f33(ACES, AP0_to_AWG3_MAT);

    rOut = relativeExposureToNormalizedLogC3(lin_AWG3[0], EI);
    gOut = relativeExposureToNormalizedLogC3(lin_AWG3[1], EI);
    bOut = relativeExposureToNormalizedLogC3(lin_AWG3[2], EI);
    aOut = aIn;
}