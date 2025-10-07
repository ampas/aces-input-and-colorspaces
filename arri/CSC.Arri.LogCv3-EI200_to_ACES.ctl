// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the ACES Project.

// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Arri.LogC3-EI200_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ARRI LogC3 EI200 to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Arri LogC3 EI200 to ACES2065-1
//
// converts Arri LogC3 EI200 to
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

const Chromaticities ARRI_ALEXA_WG_PRI =
    {
        {0.68400, 0.31300},
        {0.22100, 0.84800},
        {0.08610, -0.10200},
        {0.31270, 0.32900}};

const float AWG3_to_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix(ARRI_ALEXA_WG_PRI,
                                                                AP0,
                                                                CONE_RESP_MAT_CAT02);

const float nominalEI = 400.0;
const float blackSignal = 16.0 / 4095.0;
const float midGraySignal = 0.01;
const float encodingGain = 500.0 / 1023.0 * 0.525;
const float encodingOffset = 400.0 / 1023.0;
const float cut = 1.0 / 9.0;
const float slope = 1.0 / (cut * log(10.0));
const float offset = log10(cut) - slope * cut;

float[4] hermiteWeights(float x, float x1, float x2)
{
    const float d = x2 - x1;
    const float s = (x - x1) / d;
    const float s2 = 1.0 - s;
    float out[4];
    out[0] = (1.0 + 2.0 * s) * s2 * s2;
    out[1] = (3.0 - 2.0 * s) * s * s;
    out[2] = d * s * s2 * s2;
    out[3] = -d * s * s * s2;
    return out;
}

float normalizedSensorToRelativeExposure(float ns, float EI)
{
    return (ns - blackSignal) * (0.18 / (midGraySignal * nominalEI / EI));
}

float normalizedLogC3ToRelativeExposure(float t, float EI)
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
    if (xm > 1)
    {
        float hw[4] = hermiteWeights(t, 0.8, 1.0);
        float d = 0.2 / (xm - 0.8);
        float v[4];
        v[0] = 0.8;
        v[1] = xm;
        v[2] = 1.0;
        v[3] = 1.0 / (d * d);
        if (t <= 0.8)
        {
            out = t;
        }
        else
        {
            out = hw[0] * v[0] + hw[1] * v[1] + hw[2] * v[2] + hw[3] * v[3];
        }
    }
    else
    {
        out = t;
    }
    out = (out - encOffset) / encGain;
    ns = (out - offset) / slope;
    if (ns > cut)
    {
        ns = pow(10.0, out);
    }
    ns = (ns - nz) * gray + blackSignal;
    return normalizedSensorToRelativeExposure(ns, EI);
}

void main(input varying float rIn,
          input varying float gIn,
          input varying float bIn,
          input varying float aIn,
          output varying float rOut,
          output varying float gOut,
          output varying float bOut,
          output varying float aOut,
          input uniform float EI = 200.0)
{
    float lin_AWG3[3];
    lin_AWG3[0] = normalizedLogC3ToRelativeExposure(rIn, EI);
    lin_AWG3[1] = normalizedLogC3ToRelativeExposure(gIn, EI);
    lin_AWG3[2] = normalizedLogC3ToRelativeExposure(bIn, EI);

    float ACES[3] = mult_f3_f33(lin_AWG3, AWG3_to_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}