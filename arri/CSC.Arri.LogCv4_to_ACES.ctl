
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.LogCv4_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ARRI LogCv4 to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Arri LogC v4 to ACES2065-1
//
// converts Arri LogC v4 to
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

const Chromaticities ARRI_ALEXA_WG4_PRI =
    {
        {0.7347, 0.2653},
        {0.1424, 0.8576},
        {0.0991, -0.0308},
        {0.3127, 0.3290}};

const float AP0_to_AWG4_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                ARRI_ALEXA_WG4_PRI,
                                                                CONE_RESP_MAT_CAT02);

// LogC4 Curve Decoding Function
float normalizedLogC4ToRelativeSceneLinear(float x)
{

    // Constants
    const float a = (pow(2.0, 18.0) - 16.0) / 117.45;
    const float b = (1023.0 - 95.0) / 1023.0;
    const float c = 95.0 / 1023.0;
    const float s = (7.0 * log(2.0) * pow(2.0, 7.0 - 14.0 * c / b)) / (a * b);
    const float t = (pow(2.0, 14.0 * (-c / b) + 6.0) - 64.0) / a;

    if (x < 0.0)
    {
        return x * s + t;
    }

    float p = 14.0 * (x - c) / b + 6.0;
    return (pow(2.0, p) - 64.0) / a;
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
    float lin_AWG4[3];
    lin_AWG4[0] = normalizedLogC4ToRelativeSceneLinear(rIn);
    lin_AWG4[1] = normalizedLogC4ToRelativeSceneLinear(gIn);
    lin_AWG4[2] = normalizedLogC4ToRelativeSceneLinear(bIn);

    float ACES[3] = mult_f3_f33(lin_AWG4, AP0_to_AWG4_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}
