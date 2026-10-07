#include "mta-helper.fx"

float gMultiplier = 10; // Aumentando o multiplicador global
float alpha = 1; // Aumentando a transparência das cores

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
    MinFilter = Linear;
    MagFilter = Linear;
};

struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = MTACalcScreenPosition(VS.Position);
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float time = gTime * 0.6; // Ajuste a velocidade da transição aqui

    // Transição linear entre as cores baseada na coordenada X da textura
    float phase = frac(time + PS.TexCoord.x); // Adiciona a coordenada X da textura ao tempo para criar variação espacial

    float4 color = tex2D(Sampler0, PS.TexCoord);
    if (phase < 0.33)
    {
        // Transição de vermelho para verde
        color.r = lerp(1.0, 0.0, phase / 0.33) * alpha * gMultiplier;
        color.g = lerp(0.0, 1.0, phase / 0.33) * alpha * gMultiplier;
        color.b = 0.0 * gMultiplier;
    }
    else if (phase < 0.66)
    {
        // Transição de verde para azul
        phase = (phase - 0.33) / 0.33;
        color.r = 0.0 * gMultiplier;
        color.g = lerp(1.0, 0.0, phase) * alpha * gMultiplier;
        color.b = lerp(0.0, 1.0, phase) * alpha * gMultiplier;
    }
    else
    {
        // Transição de azul para vermelho
        phase = (phase - 0.66) / 0.34;
        color.r = lerp(0.0, 1.0, phase) * alpha * gMultiplier;
        color.g = 0.0 * gMultiplier;
        color.b = lerp(1.0, 0.0, phase) * alpha * gMultiplier;
    }


    return color;
}

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}