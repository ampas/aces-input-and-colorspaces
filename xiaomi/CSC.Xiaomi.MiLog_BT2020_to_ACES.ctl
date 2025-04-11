// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Xiaomi.MiLog_BT2020_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>Mi-Log Rec2020 to ACES2065-1</ACESuserName>

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

const float REC2020_TO_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(REC2020_PRI,
                                                                   AP0,
                                                                   CONE_RESP_MAT_CAT02);

float MiLog_to_lin(float x)
{
    const float R_0 = -0.09023729;
    const float R_t = 0.01974185;
    const float c = 18.10531998;
    const float gamma = 0.09271529;
    const float beta = 0.01384578;
    const float delta = 0.67291850;
    const float P_t = c * pow(R_t - R_0, 2.);

    if (x >= P_t)
    {
        return pow(2.,(x - delta) / gamma) - beta;
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
    float lin_rec2020[3];
    lin_rec2020[0] = MiLog_to_lin(rIn);
    lin_rec2020[1] = MiLog_to_lin(gIn);
    lin_rec2020[2] = MiLog_to_lin(bIn);

    float ACES[3] = mult_f3_f33(lin_rec2020, REC2020_TO_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}