
// <ACEStransformID>ACEScsc.ACES_to_CLog2_CGamut.a1.v1</ACEStransformID>
// <ACESuserName>ACES2065-1 to Canon Log 2 Cinema Gamut</ACESuserName>


import "ACESlib.Utilities_Color";


const float AP0_2_CGAMUT_MAT[3][3] = 
                        calculate_rgb_to_rgb_matrix( AP0, 
                                                     CANON_CGAMUT_PRI, 
                                                     CONE_RESP_MAT_CAT02 );


float lin_to_CLog2( input varying float in)
{
    float out;
    if ( in < 0 )
    {
        out = -0.24136077 * log10(1 - 87.099375 * in) + 0.092864125;
    }
    else
    {
        out = 0.24136077 * log10(87.099375 * in + 1) + 0.092864125;
    }
    return out;
}



void main
(   input varying float rIn,
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

    float lin_CGamut[3] = mult_f3_f33( ACES, AP0_2_CGAMUT_MAT);

    rOut = lin_to_CLog2( lin_CGamut[0] / 0.9);
    gOut = lin_to_CLog2( lin_CGamut[1] / 0.9);
    bOut = lin_to_CLog2( lin_CGamut[2] / 0.9);
    aOut = aIn;
}
