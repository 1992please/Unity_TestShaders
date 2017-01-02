Shader "Unlit/ColoredCurve"
{
	Properties
	{
		_Color1("Color1", Color) = (1,1,1,1)
		_Color2 ("Color2", Color) = (1,1,1,1)
		_Color3("Color3", Color) = (1,1,1,1)
		_Color4 ("Color4", Color) = (1,1,1,1)
		_Color5 ("Color5", Color) = (1,1,1,1)
		_Color6 ("Color6", Color) = (1,1,1,1)
		_Color7 ("Color7", Color) = (1,1,1,1)
		_Color8 ("Color8", Color) = (1,1,1,1)
		_Color9 ("Color9", Color) = (1,1,1,1)
		_Color10 ("Color10", Color) = (1,1,1,1)
		_Step("Step", Float) = .1
		_HalfWidth("HalfWidth", Float) = .1


	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

         		uniform float4 _Color1; 
         		uniform float4 _Color2; 
         		uniform float4 _Color3; 
         		uniform float4 _Color4; 
         		uniform float4 _Color5; 
         		uniform float4 _Color6; 
         		uniform float4 _Color7; 
         		uniform float4 _Color8; 
         		uniform float4 _Color9; 
         		uniform float4 _Color10; 

                uniform float _Step;
                uniform float _HalfWidth;

				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 col : TEXCOORD1;
					float4 PosInObjectWorld : TEXCOORD0;
				};

				vertexOutput vert(float4 vertexPos:POSITION)
				{
					vertexOutput output;
					output.pos = mul(UNITY_MATRIX_MVP, vertexPos);
					output.col = lerp(_Color1, _Color2, vertexPos.x + _HalfWidth + .5 - _Step / 2) * step(vertexPos.x, _Step - _HalfWidth) ;
					output.col += lerp(_Color2, _Color3, vertexPos.x + _HalfWidth + .5 - _Step/2 - _Step) * step( _Step - _HalfWidth, vertexPos.x) * step(vertexPos.x, 2 * _Step - _HalfWidth) ;
					output.col += lerp(_Color3, _Color4, vertexPos.x + _HalfWidth + .5 - _Step/2 - 2 *_Step) * step( 2 *_Step - _HalfWidth, vertexPos.x) * step(vertexPos.x, 3 * _Step - _HalfWidth) ;
					output.col += lerp(_Color4, _Color5, vertexPos.x + _HalfWidth + .5 - _Step/2 - 3 *_Step) * step( 3 *_Step - _HalfWidth, vertexPos.x) * step(vertexPos.x, 4 * _Step - _HalfWidth) ;

					output.PosInObjectWorld = vertexPos;
					return output;
				}

				float4 frag(vertexOutput input): COLOR
				{
					return input.col;
				}
			ENDCG
		}
	}
}
