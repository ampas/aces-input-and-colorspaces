
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Academy.ACESproxy12i_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>ACESproxy to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - ACESproxy (12-bit) to ACES
//
// converts ACESproxy (AP1 w/ ACESproxy encoding) to 
//          ACES2065-1 (AP0 w/ linear encoding)
//
// This transform follows the formulas from S-2013-001. Please refer to the 
// aforementioned document for the exact math and a table of reference values.
//

// *-*-*-*-*-*-*-*-*
// ACESproxy is intended to be a transient encoding used only for signal 
// transmission in systems limited to 10- or 12-bit video signals.
// ACESproxy is not intended for interchange, mastering finals, or archiving 
// and as such should NOT be written into a container file in actual 
// implementations! 
// *-*-*-*-*-*-*-*-*



import "Lib.Academy.Utilities";
import "Lib.Academy.ColorSpaces";



const Chromaticities AP0 = // ACES Primaries from SMPTE ST2065-1
{
  { 0.73470,  0.26530},
  { 0.00000,  1.00000},
  { 0.00010, -0.07700},
  { 0.32168,  0.33767}
};

const Chromaticities AP1 = // Working space primaries for ACES
{
  { 0.713,    0.293},
  { 0.165,    0.830},
  { 0.128,    0.044},
  { 0.32168,  0.33767}
};

const float AP1_to_AP0_MAT[3][3] = calculate_rgb_to_rgb_matrix( AP1, AP0);



const float StepsPerStop = 200.;
const float MidCVoffset = 1700.;
const int CVmin = 256;
const int CVmax = 3760;



float ACESproxy_to_lin
( 
  input varying int in,
  input varying float StepsPerStop,
  input varying float MidCVoffset,
  input varying float CVmin,
  input varying float CVmax
)
{
  return pow( 2., ( in - MidCVoffset)/StepsPerStop - 2.5);
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
    // Prepare input values based on application bit depth handling
    //  NOTE: This step is required for use with ctlrender. 
    //  ctlrender scales input values from the bit depth of the input file to 
    //  the range 0.0-1.0. For the reference images provided with the ACES 
    //  Release, the ACESproxy files are written into a 16-bit TIFF file, and so 
    //  will be divided by 65535 by ctlrender, resulting in values ranged 
    //  0.0-1.0 going into this CTL transformation. Therefore, it is important 
    //  to first scale the 0.0-1.0 ranged values to integer values appropriate 
    //  for the ACESproxy-to-linear function.
    int ACESproxy[3];
    ACESproxy[0] = rIn * 4095.0;
    ACESproxy[1] = gIn * 4095.0;
    ACESproxy[2] = bIn * 4095.0;

    float lin_AP1[3];
    lin_AP1[0] = ACESproxy_to_lin( ACESproxy[0], StepsPerStop, MidCVoffset, CVmin, CVmax);
    lin_AP1[1] = ACESproxy_to_lin( ACESproxy[1], StepsPerStop, MidCVoffset, CVmin, CVmax);
    lin_AP1[2] = ACESproxy_to_lin( ACESproxy[2], StepsPerStop, MidCVoffset, CVmin, CVmax);

    float ACES[3] = mult_f3_f33( lin_AP1, AP1_to_AP0_MAT);

    rOut = ACES[0];
    gOut = ACES[1];
    bOut = ACES[2];
    aOut = aIn;
}