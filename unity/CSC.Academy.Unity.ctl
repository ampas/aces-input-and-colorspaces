
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.Unity.a2.v1</ACEStransformID>
// <ACESuserName>Unity Transform</ACESuserName>

//
// Unity or Identity (no-op) Color Space Conversion
// Useful for cases where a CSC may be required but a no-op is desired; e.g. output = input
//

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
    rOut = rIn;
    gOut = gIn;
    bOut = bIn;
    aOut = aIn;
}