
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Sony.ACES_to_Venice_SLog3_SGamut3Cine.a2.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Sony VENICE S-Log3 S-Gamut3.Cine</ACESuserName>

//
// ACES Color Space Conversion - ACES to Sony VENICE S-Log3 S-Gamut3.Cine
//
// converts ACES2065-1 (AP0 w/ linear encoding) to
//          Sony VENICE S-Log3 S-Gamut3.Cine
//




import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";

// Note: No official published primaries exist as of this day for the
// Sony VENICE SGamut3 and Sony VENICE SGamut3.Cine colorspaces. The primaries
// have thus been derived from the IDT matrices.
const Chromaticities SONY_VENICE_SGAMUT3_CINE_PRI =
{
  { 0.775901871567345,  0.274502392854799},
  { 0.188682902773355,  0.828684937020288},
  { 0.101337382499301, -0.089187517306263},
  { 0.312700000000000,  0.329000000000000}
};

const float AP0_2_VENICE_SGAMUT3_CINE_MAT[3][3] =
                        calculate_rgb_to_rgb_matrix( AP0, 
                                                     SONY_VENICE_SGAMUT3_CINE_PRI,
                                                     CONE_RESP_MAT_CAT02);


float lin_to_SLog3( input varying float in)
{
    float out;
    if ( in >= 0.01125000 )
    {
        out = (420.0 + log10((in + 0.01) / (0.18 + 0.01)) * 261.5) / 1023.0;
    }
    else
    {
        out = (in * (171.2102946929 - 95.0) / 0.01125000 + 95.0) / 1023.0;
    }
    return out;
}



void main
(   
    input varying float rIn,
    input varying float gIn,
    input varying float bIn,
    input varying float aIn,
    output varying float rOut,
    output varying float gOut,
    output varying float bOut,
    output varying float aOut
)
{
    float ACES[3] = { rIn, gIn, bIn};

    float lin_SGamut3Cine[3] = mult_f3_f33( ACES, AP0_2_VENICE_SGAMUT3_CINE_MAT);

    rOut = lin_to_SLog3( lin_SGamut3Cine[0]);
    gOut = lin_to_SLog3( lin_SGamut3Cine[1]);
    bOut = lin_to_SLog3( lin_SGamut3Cine[2]);
    aOut = aIn;
}