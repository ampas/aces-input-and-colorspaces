// <ACEStransformID>urn:ampas:aces:transformId:v2.0:Lib.Arri.LogC3.a2.v1</ACEStransformID>
// <ACESuserName>LogC3 Constants and Functions</ACESuserName>

//
// LogC3 Constants and Functions
//
// NOTE: Due to the Hermite spline blending region between 0.8 and 1.0, the
// relativeExposureToNormalizedLogC3() function is only defined for EI values
// below 1600.
//

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

float relativeExposureToNormalizedSensor(float re, float EI)
{
    return re * (midGraySignal * nominalEI / EI) / 0.18 + blackSignal;
}

float relativeExposureToNormalizedLogC3(float re, float EI)
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
        return 0;
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
