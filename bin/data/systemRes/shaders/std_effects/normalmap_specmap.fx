
#include "stdinclude.fxh"
#ifdef NORMALMAP_ALPHA
BW_ARTIST_EDITABLE_ALPHA_BLEND
#endif

#ifdef IN_GAME
#include "normalmap_specmap.fxh"
#include "unskinned_effect_include.fxh"

//--------------------------------------------------------------//
// Technique Section for for pixel/vertexshader 2
//--------------------------------------------------------------//
#if (COMPILE_SHADER_MODEL_2 || COMPILE_SHADER_MODEL_3)
#include "normalmap_2_0.fxh"

NORMALMAP_SEPARATE_SPOT_VSHADERS( vertexShaders_vs2, vs_2_0, normalMap_vs2, normalMapSpot_vs2, normalmapStatic_vs2, normalmapStaticSpot_vs2 )

PixelShader pixelShaders_ps2[2] =
{
	compile ps_2_0 normalMap_ps2(),
	compile ps_2_0 normalMapSpot_ps2()
};

technique normalmap_shader2
<
	bool bumpMapped = true;
	string label = "SHADER_MODEL_2";
	string desc = "High";
#ifdef NORMALMAP_ALPHA
	string channel = "internalSorted";
#endif
>
{
	pass Pass_0
	{
#ifdef NORMALMAP_ALPHA
		BW_BLENDING_ALPHA
		
#else
		ALPHATESTENABLE = <alphaTestEnable>;
		ALPHAREF = <alphaReference>;
		ALPHAFUNC = GREATER;
		
		ZENABLE = TRUE;
		ZWRITEENABLE = TRUE;
		ZFUNC = LESSEQUAL;
		ALPHABLENDENABLE = FALSE;
#endif //NORMALMAP_ALPHA

		BW_FOG
		POINTSPRITEENABLE = FALSE;
		STENCILENABLE = FALSE;
		BW_CULL_DOUBLESIDED
		
		VertexShader = (vertexShaders_vs2[
			normalMapSeparateSpot_vsIndex(
				nDirectionalLights,
				nPointLights,
				nSpecularDirectionalLights,
				nSpecularPointLights,
				nSpotLights,
				staticLighting)]);
		PixelShader = (pixelShaders_ps2[min(nSpotLights,1)]);
	}
}
#endif


//--------------------------------------------------------------//
// Technique Section for for pixel/vertexshader 1
//--------------------------------------------------------------//
#if (COMPILE_SHADER_MODEL_1)
#include "normalmap_1_1.fxh"

NORMALMAP_DIFFUSEONLY_VSHADERS( diffuseVertexShaders_vs1, vs_1_1 )
NORMALMAP_SPECULARONLY_VSHADERS( specularVertexShaders_vs1, vs_1_1 )
NORMALMAP_DIFFUSEONLY_PSHADERS( diffusePixelShaders_ps1, ps_1_1 )
NORMALMAP_SPECULARONLY_PSHADERS( specularPixelShaders_ps1, ps_1_1 )

technique normalmap_shader1
<
	string label = "SHADER_MODEL_1";
	string desc = "Medium";
	bool bumpMapped = true;
#ifdef NORMALMAP_ALPHA
	string channel = "internalSorted";
#endif
>
{
	pass Pass_0
	{
#ifdef NORMALMAP_ALPHA
		BW_BLENDING_ALPHA
#else
		ALPHATESTENABLE = <alphaTestEnable>;
		ALPHAREF = <alphaReference>;
		ALPHAFUNC = GREATER;
		
		ZENABLE = TRUE;
		ZWRITEENABLE = TRUE;
		ZFUNC = LESSEQUAL;
		ALPHABLENDENABLE = FALSE;
#endif //NORMALMAP_ALPHA

		BW_FOG
		POINTSPRITEENABLE = FALSE;
		STENCILENABLE = FALSE;
		BW_CULL_DOUBLESIDED
	
		VertexShader = (diffuseVertexShaders_vs1[diffuseOnlyVSIndex(nDirectionalLights, nPointLights, staticLighting)]);
		PixelShader = (diffusePixelShaders_ps1[min(nPointLights,2)]);
	}
   
	pass Pass_1
	{
		ZWRITEENABLE = FALSE;
		ZFUNC = EQUAL;

		FOGCOLOR = float4(0,0,0,0);

		ALPHABLENDENABLE = TRUE;
		DESTBLEND = ONE;
		SRCBLEND = ONE;

		VertexShader = (specularVertexShaders_vs1[specularOnlyVSIndex(nSpecularDirectionalLights, nSpecularPointLights)]);
		PixelShader = (specularPixelShaders_ps1[int(nSpecularPointLights>0)]);
	}
}
#endif


//--------------------------------------------------------------//
// Technique section for software mode
//--------------------------------------------------------------//
#if (COMPILE_SHADER_MODEL_0)
#include "normalmap_fallback.fxh"

technique software_fallback
<
	string label = "SHADER_MODEL_0";
	string desc = "Low";
#ifdef NORMALMAP_ALPHA
	string channel = "internalSorted";
#endif
>
{
	pass Pass_0
	{
#ifdef NORMALMAP_ALPHA
		BW_BLENDING_ALPHA
#else
		BW_BLENDING_SOLID
#endif
		ALPHATESTENABLE = <alphaTestEnable>;
		ALPHAREF = <alphaReference>;
		ALPHAFUNC = GREATER;

		BW_FOG
		BW_TEXTURESTAGE_DIFFUSEONLY(0, diffuseMap)
		BW_TEXTURESTAGE_TERMINATE(1)
		BW_CULL_DOUBLESIDED
		
		VertexShader = (fallbackShaders[int(staticLighting)]);
		PixelShader = NULL;
	}
}
#endif


#else	//IN_GAME

#include "normalmap_specmap_max_preview.fxh"

technique max_preview
{
	pass Pass_0
	{
#ifdef NORMALMAP_ALPHA
		BW_BLENDING_ALPHA
#else	
		ALPHATESTENABLE = <alphaTestEnable>;
		ALPHAREF = <alphaReference>;
		ALPHAFUNC = GREATER;
		
		ZENABLE = TRUE;
		ZWRITEENABLE = TRUE;
		ZFUNC = LESSEQUAL;
		ALPHABLENDENABLE = FALSE;
#endif //BW_BLENDING_ALPHA		
		BW_CULL_DOUBLESIDED
		
		VertexShader = compile vs_2_0 normalMapSpecmap_maxpreview_vs2();
		PixelShader = compile ps_2_0 normalMapSpecmap_maxpreview_ps2();
	}
}

#endif