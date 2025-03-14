// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Xiaomi.ACES_to_MLog_BT2020.a1.v2</ACEStransformID>
// <ACESuserName>ACES2065-1 to MLog Rec2020</ACESuserName>

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
const float AP0_TO_REC2020_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                   REC2020_PRI,
                                                                   CONE_RESP_MAT_CAT02);

float lin_to_mlog(float x)
{
    const float R_0 = -0.061;
    const float R_t = 0.0164;
    const float a = 0.115476;
    const float b = 0.002741;
    const float g = 0.670058;
    const float c = 35.4922;

    if (x >= R_t)
    {
        return a * log(x + b) + g;
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

    float lin_rgb[3] = mult_f3_f33(ACES, AP0_TO_REC2020_MAT);

    float MLog[3];
    MLog[0] = lin_to_mlog(lin_rgb[0]);
    MLog[1] = lin_to_mlog(lin_rgb[1]);
    MLog[2] = lin_to_mlog(lin_rgb[2]);

    rOut = MLog[0];
    gOut = MLog[1];
    bOut = MLog[2];
    aOut = aIn;
}