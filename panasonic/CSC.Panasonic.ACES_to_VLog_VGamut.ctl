
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Panasonic.ACES_to_VLog_VGamut.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Panasonic Varicam V-Log V-Gamut</ACESuserName>

//
// ACES Color Space Conversion - ACES to Panasonic Varicam V-Log V-Gamut
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Panasonic Varicam V-Log V-Gamut
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
    {
        {0.73470, 0.26530},
        {0.00000, 1.00000},
        {0.00010, -0.07700},
        {0.32168, 0.33767}};

const Chromaticities PANASONIC_VGAMUT_PRI =
    {
        {0.730, 0.280},
        {0.165, 0.840},
        {0.100, -0.030},
        {0.3127, 0.3290}};

const float AP0_2_VGAMUT_MAT[3][3] = calculate_rgb_to_rgb_matrix(AP0,
                                                                 PANASONIC_VGAMUT_PRI);

const float cut1 = 0.01;
const float b = 0.00873;
const float c = 0.241514;
const float d = 0.598206;

float lin_to_VLog(input varying float in)
{
    if (in < cut1)
    {
        return 5.6 * in + 0.125;
    }
    else
    {
        return c * log10(in + b) + d;
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

    float lin_VGamut[3] = mult_f3_f33(ACES, AP0_2_VGAMUT_MAT);

    rOut = lin_to_VLog(lin_VGamut[0]);
    gOut = lin_to_VLog(lin_VGamut[1]);
    bOut = lin_to_VLog(lin_VGamut[2]);
    aOut = aIn;
}