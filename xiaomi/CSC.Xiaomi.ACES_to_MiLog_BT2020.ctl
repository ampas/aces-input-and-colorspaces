// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Xiaomi.ACES_to_MiLog_BT2020.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Mi-Log Rec2020</ACESuserName>

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

const float AP0_TO_REC2020_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                   REC2020_PRI,
                                                                   CONE_RESP_MAT_CAT02);

float lin_to_MiLog(float x)
{
    const float R_0 = -0.09023729;
    const float R_t = 0.01974185;
    const float c = 18.10531998;
    const float gamma = 0.09271529;
    const float beta = 0.01384578;
    const float delta = 0.67291850;

    if (x >= R_t)
    {
        return gamma * log2(x + beta) + delta;
    }
    else if (x < R_t && x >= R_0)
    {
        return c * pow(x - R_0, 2.);
    }
    else
    {
        return 0;
    }
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

    float lin_rec2020[3] = mult_f3_f33(ACES, AP0_TO_REC2020_MAT);

    rOut = lin_to_MiLog(lin_rec2020[0]);
    gOut = lin_to_MiLog(lin_rec2020[1]);
    bOut = lin_to_MiLog(lin_rec2020[2]);
    aOut = aIn;
}