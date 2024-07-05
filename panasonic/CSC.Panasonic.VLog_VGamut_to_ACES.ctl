
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Panasonic.VLog_VGamut_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>Panasonic Varicam V-Log V-Gamut to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Panasonic Varicam V-Log V-Gamut to ACES
//
// converts Panasonic Varicam V-Log V-Gamut to
//          ACES2065-1 (AP0 w/ linear encoding)
//



import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";



const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
{
  { 0.73470,  0.26530},
  { 0.00000,  1.00000},
  { 0.00010, -0.07700},
  { 0.32168,  0.33767}
};

const Chromaticities PANASONIC_VGAMUT_PRI =
{
  { 0.730,  0.280},
  { 0.165,  0.840},
  { 0.100, -0.030},
  { 0.3127,  0.3290}
};

const float VGAMUT_2_AP0_MAT[3][3] = 
                        calculate_rgb_to_rgb_matrix( PANASONIC_VGAMUT_PRI, 
                                                     AP0 );


const float cut2 = 0.181;
const float b = 0.00873;
const float c = 0.241514;
const float d = 0.598206;

float VLog_to_lin( input varying float in)
{
    if ( in < cut2 )
    {
        return (in - 0.125)/5.6;
    }
    else
    {
        return pow(10.0, ((in - d) / c)) - b;
    }
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
    float lin_VGamut[3];
    lin_VGamut[0] = VLog_to_lin( rIn);
    lin_VGamut[1] = VLog_to_lin( gIn);
    lin_VGamut[2] = VLog_to_lin( bIn);

    float ACES[3] = mult_f3_f33( lin_VGamut, VGAMUT_2_AP0_MAT);
  
    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}