texture diffuseMap;

technique standard
{
	pass Pass_0
	{
		ZENABLE = FALSE;
		ZWRITEENABLE = FALSE;
		ALPHABLENDENABLE = TRUE;
		ALPHATESTENABLE = FALSE;
		CULLMODE = NONE;
		FOGENABLE = FALSE;
		SRCBLEND = ONE;
		DESTBLEND = INVSRCCOLOR;

		ADDRESSU[0] = CLAMP;
		ADDRESSV[0] = CLAMP;
		ADDRESSW[0] = CLAMP;
		MAGFILTER[0] = LINEAR;
		MINFILTER[0] = LINEAR;
		MIPFILTER[0] = NONE;
		COLOROP[0] = SELECTARG1;
		COLORARG1[0] = TEXTURE;
		Texture[0] = <diffuseMap>;

		COLOROP[1] = DISABLE;
		ALPHAOP[0] = DISABLE;
		
		VertexShader = NULL;
		PixelShader = NULL;
	}
}