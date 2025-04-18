
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.ACES_to_LogC3_EI800.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to ARRI LogC3 EI800</ACESuserName>

//
// ACES Color Space Conversion - ACES2065-1 to Arri LogC3 EI800
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Arri LogC3 at EI800 
//

import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

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

const float nominalEI = 400.0;
const float blackSignal = 16.0 / 4095.0;
const float midGraySignal = 0.01;
const float encodingGain = 500.0 / 1023.0 * 0.525;
const float encodingOffset = 400.0 / 1023.0;
const float cut = 1.0 / 9.0;
const float slope = 1.0 / (cut * log(10.0));
const float offset = log10(cut) - slope * cut;

float relativeExposureToNormalizedSensor_EI800(float re)
{
    return re / (0.18 / (midGraySignal * nominalEI / 800)) + blackSignal;
}

float relativeExposureToNormalizedLogC3_EI800(float x)
{
    float nz;
    float out;
    float ns;
    const float gain = 800 / nominalEI;
    const float gray = midGraySignal / gain;
    const float encGain = (log2(gain) * (0.89 - 1.0) / 3.0 + 1.0) * encodingGain;
    float encOffset = encodingOffset;
    for (int i = 0; i < 3; i = i + 1)
    {
        nz = ((95.0 / 1023.0 - encOffset) / encGain - offset) / slope;
        encOffset = encodingOffset - log10(1.0 + nz) * encGain;
    }
    ns = relativeExposureToNormalizedSensor_EI800(x);
    ns = (ns - blackSignal) / gray + nz;
    if (ns > cut)
    {
        out = log10(ns);
    }
    else
    {
        out = ns * slope + offset;
    }
    return out * encGain + encOffset;
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
    float ACES[3] = {rIn, gIn, bIn};

    float lin_AWG3[3] = mult_f3_f33(ACES, AP0_to_AWG3_MAT);

    rOut = relativeExposureToNormalizedLogC3_EI800(lin_AWG3[0]);
    gOut = relativeExposureToNormalizedLogC3_EI800(lin_AWG3[1]);
    bOut = relativeExposureToNormalizedLogC3_EI800(lin_AWG3[2]);
    aOut = aIn;
}
