float3 sMorphSize = float3(0, 0, 0);
float3 sRotation = float3(0, 0, 0);

#include "mta-helper.fx"

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    float4x4 matRotX = float4x4(
        1, 0, 0, 0,
        0, cos(sRotation.x), -sin(sRotation.x), 0,
        0, sin(sRotation.x), cos(sRotation.x), 0,
        0, 0, 0, 1
    );

    float4x4 matRotZ = float4x4(
        cos(sRotation.z), -sin(sRotation.z), 0, 0,
        sin(sRotation.z), cos(sRotation.z), 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    );

    float4 pos = float4(VS.Position, 1);
    pos = mul(pos, matRotX);
    pos = mul(pos, matRotZ);

    // Aplicando a normalização da superfície
    pos.xyz += normalize(VS.Normal) * sMorphSize;

    PS.Position = MTACalcScreenPosition(pos.xyz);
    PS.Diffuse = MTACalcGTABuildingDiffuse(VS.Diffuse);
    PS.TexCoord = VS.TexCoord;

    return PS;
}


technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
    }
}

technique fallback
{
    pass P0
    {

    }
}