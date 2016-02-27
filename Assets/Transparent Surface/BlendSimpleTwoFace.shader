Shader "CGTransparentSurfaces/BlendSimpleTwoFace"
{
	SubShader
	{
		Tags {"Queue" = "Transparent"}
		// draw after all the opaque qeometry has been drawn
		Pass
		{
			Cull Front // first pass renders only back faces 
			// (the "inside")
			ZWrite Off // don't write to depth buffer 
			// in order not to occlude other objects

			Blend SrcAlpha OneMinusSrcAlpha //use alpha blending 

			CGPROGRAM

			#pragma vertex Vert
			#pragma fragment Frag

			float4 Vert(float4 VertexPosition : POSITION) : SV_POSITION
			{
				return mul(UNITY_MATRIX_MVP, VertexPosition);
			}

			float4 Frag(void) : COLOR
			{
				return float4(0.0, 1.0, 0.0, 0.3);
				// The Fourth Component (alpha) is important 
			}
			ENDCG
		}

		Pass
		{
			Cull Back // first pass renders only back faces 
			// (the "inside")
			ZWrite Off // don't write to depth buffer 
			// in order not to occlude other objects

			Blend SrcAlpha OneMinusSrcAlpha //use alpha blending 

			CGPROGRAM

			#pragma vertex Vert
			#pragma fragment Frag

			float4 Vert(float4 VertexPosition : POSITION) : SV_POSITION
			{
				return mul(UNITY_MATRIX_MVP, VertexPosition);
			}

			float4 Frag(void) : COLOR
			{
				return float4(0.0, 1.0, 0.0, 0.3);
				// The Fourth Component (alpha) is important 
			}
			ENDCG
		}
	}
}
