
// <ACEStransformID>urn:ampas:aces:transformId:v2.0:CSC.Sony.Venice_SLog3_SGamut3_to_ACES.a2.v1</ACEStransformID>
// <ACESuserName>Sony VENICE S-Log3 S-Gamut3 to ACES2065-1</ACESuserName>

//
// ACES Color Space Conversion - Sony VENICE S-Log3 S-Gamut3 to ACES
//
// converts Sony VENICE S-Log3 / S-Gamut3 to
//          ACES2065-1 (AP0 w/ linear encoding)
//

// Provided by Sony Electronics Corp.
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

// Note: No official published primaries exist as of this day for the
// Sony VENICE SGamut3 and Sony VENICE SGamut3.Cine colorspaces. The primaries
// have thus been derived from the IDT matrices.
const Chromaticities SONY_VENICE_SGAMUT3_PRI =
{
  { 0.740464264304292,  0.279364374750660},
  { 0.089241145423286,  0.893809528608105},
  { 0.110488236673827, -0.052579333080476},
  { 0.312700000000000,  0.329000000000000}
};

//------------------------------------------------------------
//  VENICE S-Gamut3 to AP0 matrix coeffs
//------------------------------------------------------------
const float VENICE_SGAMUT3_2_AP0_MAT[3][3] =
                        calculate_rgb_to_rgb_matrix( SONY_VENICE_SGAMUT3_PRI,
                                                     AP0, 
                                                     CONE_RESP_MAT_CAT02);

//------------------------------------------------------------------------------------
//  S-Log 3 to linear
//------------------------------------------------------------------------------------
float SLog3_to_linear( float SLog )
{
	float out;

	if (SLog >= 171.2102946929 / 1023.0)
	{
		out = pow(10.0, (SLog*1023.0-420.0)/261.5)*(0.18+0.01)-0.01;
	}
	else
	{
		out = (SLog*1023.0-95.0)*0.01125000/(171.2102946929-95.0);
	}

	return out;
}

//------------------------------------------------------------------------------------
//  main
//------------------------------------------------------------------------------------
void main (
	input varying float rIn,
	input varying float gIn,
	input varying float bIn,
	input varying float aIn,
	output varying float rOut,
	output varying float gOut,
	output varying float bOut,
	output varying float aOut )
{
	float SLog3[3];
	SLog3[0] = rIn;
	SLog3[1] = gIn;
	SLog3[2] = bIn;

	float linear[3];
	linear[0] = SLog3_to_linear( SLog3[0] );
	linear[1] = SLog3_to_linear( SLog3[1] );
	linear[2] = SLog3_to_linear( SLog3[2] );

	float ACES[3] = mult_f3_f33( linear, VENICE_SGAMUT3_2_AP0_MAT );

	rOut = ACES[0];
	gOut = ACES[1];
	bOut = ACES[2];
	aOut = aIn;
}