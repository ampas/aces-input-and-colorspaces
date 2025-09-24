// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.ACES_to_LogC3.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to ARRI LogC3</ACESuserName>

//
// ACES Color Space Conversion - ACES2065-1 to Arri LogC3
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Arri LogC3
//
//  NOTE: Like its LogC3-to-ACES counterpart, this ACES-to-LogC3 transform
//  declares EI as a parameter, but defaults to 800. Due to the Hermite spline
//  blending region between 0.8 and 1.0, the function currently will only work
//  for EI values below 1600.
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

float relativeExposureToNormalizedSensor(float re, float EI)
{
    return re * (midGraySignal * nominalEI / EI) / 0.18 + blackSignal;
}

float relativeExposureToNormalizedLogC4(float re, float EI)
{
    float nz;
    float out;
    float ns;
    const float gain = EI / nominalEI;
    const float gray = midGraySignal / gain;
    const float encGain = (log2(gain) * (0.89 - 1.0) / 3.0 + 1.0) * encodingGain;
    float encOffset = encodingOffset;
    for (int i = 0; i < 3; i = i + 1)
    {
        nz = ((95.0 / 1023.0 - encOffset) / encGain - offset) / slope;
        encOffset = encodingOffset - log10(1.0 + nz) * encGain;
    }
    float xm = log10((1.0 - blackSignal) / gray + nz) * encGain + encOffset;

    ns = relativeExposureToNormalizedSensor(re, EI);

    ns = (ns - blackSignal) / gray + nz;

    if (xm > 1) {
        // Hermite blending region
        // Tricky to implement an inverse unless needed. It might be possible to
        // iteratively solve for a numerical inversion, but is currently not
        // supported.
    } else { // Valid for EI values below 1600
        if (ns > cut)
        {
            out = log10(ns);
        } 
        else
        {
            out = slope * ns + offset;
        }
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
          output varying float aOut,
          input uniform float EI = 800.0)
{
    float ACES[3] = {rIn, gIn, bIn};

    float lin_AWG3[3] = mult_f3_f33(ACES, AP0_to_AWG3_MAT);

    rOut = relativeExposureToNormalizedLogC4(lin_AWG3[0], EI);
    gOut = relativeExposureToNormalizedLogC4(lin_AWG3[1], EI);
    bOut = relativeExposureToNormalizedLogC4(lin_AWG3[2], EI);
    aOut = aIn;
}