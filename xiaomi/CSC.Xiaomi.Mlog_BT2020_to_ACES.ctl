// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Xiaomi.MLog_BT2020_to_ACES.a1.v2</ACEStransformID>
// <ACESuserName>MLog Rec2020 to ACES2065-1</ACESuserName>

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
const float REC2020_TO_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(REC2020_PRI,
                                                                   AP0,
                                                                   CONE_RESP_MAT_CAT02);

float mlog_to_lin(float x)
{
    const float R_0 = -0.061;
    const float R_t = 0.0164;
    const float a = 0.115476;
    const float b = 0.002741;
    const float g = 0.670058;
    const float c = 35.4922;
    const float P_t = c * pow((R_t - R_0), 2.0);

    if (x >= P_t)
    {
        return exp((x - g) / a) - b;
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
    float lin_rgb[3];
    lin_rgb[0] = mlog_to_lin(rIn);
    lin_rgb[1] = mlog_to_lin(gIn);
    lin_rgb[2] = mlog_to_lin(bIn);

    float ACES[3] = mult_f3_f33(lin_rgb, REC2020_TO_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}