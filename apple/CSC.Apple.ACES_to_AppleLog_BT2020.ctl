
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Apple.ACES_to_AppleLog_BT2020.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to AppleLog Rec2020</ACESuserName>

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
const float ACES_to_REC2020_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                    REC2020_PRI);

float linear_to_AppleLog(float R)
{
    const float R_0 = -0.05641088;
    const float R_t = 0.01;
    const float c = 47.28711236;
    const float b = 0.00964052;
    const float g = 0.08550479;
    const float d = 0.69336945;

    if (R >= R_t)
    {
        return g * log2(R + b) + d;
    }
    else if (R < R_t && R >= R_0)
    {
        return c * pow(R - R_0, 2.);
    }
    else
    {
        return 0.0;
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
    float aces[3] = {rIn, gIn, bIn};

    float lin_2020[3] = mult_f3_f33(aces, ACES_to_REC2020_MAT);

    float AppleLog[3];
    AppleLog[0] = linear_to_AppleLog(lin_2020[0]);
    AppleLog[1] = linear_to_AppleLog(lin_2020[1]);
    AppleLog[2] = linear_to_AppleLog(lin_2020[2]);

    rOut = AppleLog[0];
    gOut = AppleLog[1];
    bOut = AppleLog[2];
    aOut = aIn;
}
